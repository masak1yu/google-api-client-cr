module Google
  module Apis
    class Error < Exception
    end

    class ClientError < Error
    end

    class ServerError < Error
    end

    class AuthorizationError < Error
    end
  end
end
