require "./http_command"

module Google
  module Apis
    module Core
      class ApiCommand < HttpCommand
        JSON_CONTENT_TYPE = "application/json"
        FIELDS_PARAM      = "fields"
      end
    end
  end
end
