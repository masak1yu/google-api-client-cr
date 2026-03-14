module Google
  module Apis
    module Core
      class HttpCommand
        property method : String
        property url : String
        property body : String?
        property query : Hash(String, String?)

        def initialize(@method : String, @url : String, @body : String? = nil)
          @query = {} of String => String?
        end
      end
    end
  end
end
