module Google
  module Apis
    class ClientOptions
      def self.default
        @options ||= ClientOptions.new
      end
    end

    # Request options
    class RequestOptions
    end

  end
end