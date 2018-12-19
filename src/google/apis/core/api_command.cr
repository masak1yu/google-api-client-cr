require "./http_command"

module Google
  module Apis
    module Core
      # Command for executing most basic API request with JSON requests/responses
      class ApiCommand < HttpCommand
        JSON_CONTENT_TYPE = "application/json"
        FIELDS_PARAM = "fields"
      end
    end
  end
end