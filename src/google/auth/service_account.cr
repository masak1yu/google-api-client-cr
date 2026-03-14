require "http/client"
require "json"
require "openssl"
require "base64"

module Google
  module Auth
    # Service Account (JWT) credentials for server-to-server authentication.
    #
    # ```
    # creds = Google::Auth::ServiceAccountCredentials.from_json_key("key.json", scope: Google::Auth::Scopes::YOUTUBE)
    # youtube = Google::Apis::YoutubeV3::YouTubeService.new
    # youtube.authorize(creds)
    # ```
    class ServiceAccountCredentials
      GOOGLE_TOKEN_URL = "oauth2.googleapis.com"
      TOKEN_PATH       = "/token"
      GRANT_TYPE       = "urn:ietf:params:oauth:grant-type:jwt-bearer"

      property client_email : String
      property private_key : String
      property token_uri : String
      property scope : String
      property access_token : String?
      property expires_at : Time?

      def initialize(@client_email : String, @private_key : String,
                     @scope : String, @token_uri : String = "https://#{GOOGLE_TOKEN_URL}#{TOKEN_PATH}")
      end

      def self.from_json_key(json_key_path : String, scope : String | Array(String)) : ServiceAccountCredentials
        data = JSON.parse(File.read(json_key_path))
        scopes = scope.is_a?(Array) ? scope.join(" ") : scope
        new(
          client_email: data["client_email"].as_s,
          private_key: data["private_key"].as_s,
          scope: scopes,
          token_uri: data["token_uri"]?.try(&.as_s) || "https://#{GOOGLE_TOKEN_URL}#{TOKEN_PATH}"
        )
      end

      def valid_token : String
        if token = @access_token
          if ea = @expires_at
            return token if Time.utc < ea
          end
        end
        refresh!
      end

      def refresh! : String
        now = Time.utc
        jwt = build_jwt(now)

        body = HTTP::Params.build do |p|
          p.add("grant_type", GRANT_TYPE)
          p.add("assertion", jwt)
        end

        client = HTTP::Client.new(GOOGLE_TOKEN_URL, tls: OpenSSL::SSL::Context::Client.new)
        headers = HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"}
        response = client.post(TOKEN_PATH, headers: headers, body: body)

        unless response.success?
          raise Google::Auth::Error.new("Service account token request failed: #{response.status_code} #{response.body}")
        end

        data = JSON.parse(response.body)
        @access_token = data["access_token"].as_s
        if expires_in = data["expires_in"]?
          @expires_at = Time.utc + expires_in.as_i.seconds
        end
        @access_token.not_nil!
      end

      def expired? : Bool
        return true unless ea = @expires_at
        Time.utc >= ea
      end

      private def build_jwt(now : Time) : String
        header = base64url({"alg" => "RS256", "typ" => "JWT"}.to_json)
        claim_set = base64url({
          "iss"   => @client_email,
          "scope" => @scope,
          "aud"   => @token_uri,
          "iat"   => now.to_unix,
          "exp"   => (now + 1.hour).to_unix,
        }.to_json)

        signing_input = "#{header}.#{claim_set}"
        rsa = OpenSSL::RSA.new(@private_key)
        signature = rsa.sign(OpenSSL::Algorithm::SHA256, signing_input)
        "#{signing_input}.#{base64url(signature)}"
      end

      private def base64url(data : String) : String
        Base64.urlsafe_encode(data, padding: false)
      end

      private def base64url(data : Bytes) : String
        Base64.urlsafe_encode(data, padding: false)
      end
    end
  end
end
