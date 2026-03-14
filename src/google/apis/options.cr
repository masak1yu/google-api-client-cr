module Google
  module Apis
    class ClientOptions
      property application_name : String?
      property application_version : String?

      def self.default
        new
      end

      def initialize(@application_name : String? = nil, @application_version : String? = nil)
      end
    end

    class RequestOptions
      property authorization : String?
      property retries : Int32

      def initialize(@authorization : String? = nil, @retries : Int32 = 0)
      end
    end
  end
end
