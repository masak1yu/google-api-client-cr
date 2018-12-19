require "http/client"
require "openssl"

module Google
  module Apis
    module Core
      class BaseService
        property :root_url
        property :base_path
        property :key
        getter   :client
        getter   :builder

        def initialize(root_url : String, base_path : String)
          @root_url  = root_url
          @base_path = base_path
          @client    = HTTP::Client.new(root_url, tls: OpenSSL::SSL::Context::Client.new)
          @builder   = HTTP::Params::Builder.new
          @key       = ENV["API_KEY"]?
        end

        def make_simple_command(method, path, options)
          # url = root_url + base_path + path
        end
      end
    end
  end
end