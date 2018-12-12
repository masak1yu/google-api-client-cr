module Google
  module Apis
    module Core
      class BaseService
        property :root_url
        property :base_path

        def initialize(root_url, base_path)
          self.root_url = root_url
          self.base_path = base_path
        end

        def make_simple_command(method, path, options)
          # url = root_url + base_path + path
        end
      end
    end
  end
end