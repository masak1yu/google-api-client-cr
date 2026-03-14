require "json"

module Google
  module Auth
    class TokenStore
      include JSON::Serializable

      property access_token : String?
      property refresh_token : String?
      property expires_at : String?

      def initialize(@access_token : String? = nil, @refresh_token : String? = nil, @expires_at : String? = nil)
      end

      def self.from_client(client : OAuth2Client) : TokenStore
        expires_at_str = client.expires_at.try &.to_rfc3339
        new(client.access_token, client.refresh_token, expires_at_str)
      end

      def apply_to(client : OAuth2Client) : Nil
        client.access_token = @access_token
        client.refresh_token = @refresh_token
        if ea = @expires_at
          client.expires_at = Time.parse_rfc3339(ea)
        end
      end

      def save(path : String) : Nil
        File.write(path, to_pretty_json)
      end

      def self.load(path : String) : TokenStore
        from_json(File.read(path))
      end
    end

    class OAuth2Client
      def save_credentials(path : String) : Nil
        TokenStore.from_client(self).save(path)
      end

      def self.from_credentials(path : String, client_id : String, client_secret : String,
                                redirect_uri : String = "urn:ietf:wg:oauth:2.0:oob") : OAuth2Client
        client = new(client_id, client_secret, redirect_uri)
        store = TokenStore.load(path)
        store.apply_to(client)
        client
      end
    end
  end
end
