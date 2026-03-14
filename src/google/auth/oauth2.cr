require "http/client"
require "json"
require "uri"

module Google
  module Auth
    class OAuth2Client
      GOOGLE_AUTH_URL  = "https://accounts.google.com/o/oauth2/v2/auth"
      GOOGLE_TOKEN_URL = "oauth2.googleapis.com"
      TOKEN_PATH       = "/token"

      property client_id : String
      property client_secret : String
      property redirect_uri : String
      property access_token : String?
      property refresh_token : String?
      property expires_at : Time?

      def initialize(@client_id : String, @client_secret : String,
                     @redirect_uri : String = "urn:ietf:wg:oauth:2.0:oob")
      end

      # Generate the authorization URL for the user to visit
      def authorization_url(scope : String | Array(String), state : String? = nil,
                            access_type : String = "offline",
                            prompt : String = "consent") : String
        scopes = scope.is_a?(Array) ? scope.join(" ") : scope

        params = HTTP::Params.build do |p|
          p.add("client_id", @client_id)
          p.add("redirect_uri", @redirect_uri)
          p.add("response_type", "code")
          p.add("scope", scopes)
          p.add("access_type", access_type)
          p.add("prompt", prompt)
          p.add("state", state) if state
        end

        "#{GOOGLE_AUTH_URL}?#{params}"
      end

      # Exchange authorization code for tokens
      def authorize(code : String) : String
        body = HTTP::Params.build do |p|
          p.add("code", code)
          p.add("client_id", @client_id)
          p.add("client_secret", @client_secret)
          p.add("redirect_uri", @redirect_uri)
          p.add("grant_type", "authorization_code")
        end

        response = token_request(body)
        parse_token_response(response)
        @access_token.not_nil!
      end

      # Refresh the access token using the refresh token
      def refresh! : String
        rt = @refresh_token
        raise Google::Auth::Error.new("No refresh token available") unless rt

        body = HTTP::Params.build do |p|
          p.add("refresh_token", rt)
          p.add("client_id", @client_id)
          p.add("client_secret", @client_secret)
          p.add("grant_type", "refresh_token")
        end

        response = token_request(body)
        parse_token_response(response)
        @access_token.not_nil!
      end

      # Check if the token is expired
      def expired? : Bool
        return true unless ea = @expires_at
        Time.utc < ea
      end

      # Get a valid access token, refreshing if necessary
      def valid_token : String
        if @access_token && !expired?
          return @access_token.not_nil!
        end
        if @refresh_token
          return refresh!
        end
        raise Google::Auth::Error.new("No valid access token. Call authorize first.")
      end

      private def token_request(body : String) : HTTP::Client::Response
        client = HTTP::Client.new(GOOGLE_TOKEN_URL, tls: OpenSSL::SSL::Context::Client.new)
        headers = HTTP::Headers{
          "Content-Type" => "application/x-www-form-urlencoded",
        }
        client.post(TOKEN_PATH, headers: headers, body: body)
      end

      private def parse_token_response(response : HTTP::Client::Response)
        unless response.success?
          raise Google::Auth::Error.new("Token request failed: #{response.status_code} #{response.body}")
        end

        data = JSON.parse(response.body)
        @access_token = data["access_token"].as_s
        if rt = data["refresh_token"]?
          @refresh_token = rt.as_s
        end
        if expires_in = data["expires_in"]?
          @expires_at = Time.utc + expires_in.as_i.seconds
        end
      end
    end

    class Error < Exception
    end

    # YouTube API OAuth2 scopes
    module Scopes
      YOUTUBE                           = "https://www.googleapis.com/auth/youtube"
      YOUTUBE_READONLY                  = "https://www.googleapis.com/auth/youtube.readonly"
      YOUTUBE_UPLOAD                    = "https://www.googleapis.com/auth/youtube.upload"
      YOUTUBE_FORCE_SSL                 = "https://www.googleapis.com/auth/youtube.force-ssl"
      YOUTUBE_CHANNEL_MEMBERSHIPS       = "https://www.googleapis.com/auth/youtube.channel-memberships.creator"
      YOUTUBE_PARTNER                   = "https://www.googleapis.com/auth/youtubepartner"
      YOUTUBE_PARTNER_CHANNEL_AUDIT     = "https://www.googleapis.com/auth/youtubepartner-channel-audit"
    end
  end
end
