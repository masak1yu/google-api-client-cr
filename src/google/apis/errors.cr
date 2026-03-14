module Google
  module Apis
    class Error < Exception
      getter status_code : Int32?

      def initialize(message : String, @status_code : Int32? = nil)
        super(message)
      end
    end

    class ClientError < Error
    end

    class RateLimitError < ClientError
    end

    class ServerError < Error
    end

    class AuthorizationError < Error
    end
  end
end
