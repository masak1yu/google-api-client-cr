require "http/client"
require "openssl"
require "json"
require "uri"

module Google
  module Apis
    module Core
      class BaseService
        property root_url : String
        property base_path : String
        property key : String?
        property access_token : String?

        @client : HTTP::Client

        def initialize(@root_url : String, @base_path : String)
          @client = HTTP::Client.new(@root_url, tls: OpenSSL::SSL::Context::Client.new)
          @key = ENV["API_KEY"]?
        end

        def execute(method : String, path : String, query : Hash(String, String?) = {} of String => String?,
                    body : String? = nil, headers : HTTP::Headers? = nil) : HTTP::Client::Response
          query["key"] = @key if @key && !@access_token

          query_string = query.compact.map { |k, v| "#{URI.encode_www_form(k)}=#{URI.encode_www_form(v.to_s)}" }.join("&")
          full_path = "/#{@base_path}#{path}"
          full_path += "?#{query_string}" unless query_string.empty?

          headers ||= HTTP::Headers.new
          if body
            headers["Content-Type"] = "application/json"
          end
          if token = @access_token
            headers["Authorization"] = "Bearer #{token}"
          end

          case method.upcase
          when "GET"
            @client.get(full_path, headers: headers)
          when "POST"
            @client.post(full_path, headers: headers, body: body)
          when "PUT"
            @client.put(full_path, headers: headers, body: body)
          when "DELETE"
            @client.delete(full_path, headers: headers)
          else
            raise "Unsupported HTTP method: #{method}"
          end
        end

        private def execute_and_parse(response_type : T.class, method : String, path : String,
                                       query : Hash(String, String?) = {} of String => String?,
                                       body : String? = nil) : T forall T
          response = execute(method, path, query, body)
          handle_error(response)
          T.from_json(response.body)
        end

        private def execute_delete(method : String, path : String,
                                    query : Hash(String, String?) = {} of String => String?) : Nil
          response = execute(method, path, query)
          handle_error(response)
        end

        # Download response body to a file
        private def execute_download(method : String, path : String,
                                      query : Hash(String, String?) = {} of String => String?,
                                      download_dest : String | IO = "") : Nil
          response = execute(method, path, query)
          handle_error(response)
          case download_dest
          when String
            File.write(download_dest, response.body)
          when IO
            download_dest.print(response.body)
          end
        end

        # Upload a file with multipart request
        private def execute_upload(response_type : T.class, method : String, path : String,
                                    query : Hash(String, String?) = {} of String => String?,
                                    upload_source : String | IO | Nil = nil,
                                    content_type : String = "application/octet-stream",
                                    body_json : String? = nil) : T forall T
          query["key"] = @key if @key && !@access_token

          query["uploadType"] = "multipart"
          query_string = query.compact.map { |k, v| "#{URI.encode_www_form(k)}=#{URI.encode_www_form(v.to_s)}" }.join("&")
          full_path = "/upload/#{@base_path}#{path}"
          full_path += "?#{query_string}" unless query_string.empty?

          boundary = "----CrystalGoogleApi#{Random.new.hex(16)}"
          headers = HTTP::Headers.new
          headers["Content-Type"] = "multipart/related; boundary=#{boundary}"
          if token = @access_token
            headers["Authorization"] = "Bearer #{token}"
          end

          io = IO::Memory.new
          # Part 1: JSON metadata
          if json = body_json
            io << "--#{boundary}\r\n"
            io << "Content-Type: application/json; charset=UTF-8\r\n\r\n"
            io << json << "\r\n"
          end
          # Part 2: File content
          if source = upload_source
            io << "--#{boundary}\r\n"
            io << "Content-Type: #{content_type}\r\n\r\n"
            case source
            when String
              io << File.read(source)
            when IO
              IO.copy(source, io)
            end
            io << "\r\n"
          end
          io << "--#{boundary}--\r\n"

          response = case method.upcase
                     when "POST"
                       @client.post(full_path, headers: headers, body: io.to_s)
                     when "PUT"
                       @client.put(full_path, headers: headers, body: io.to_s)
                     else
                       raise "Unsupported upload method: #{method}"
                     end
          handle_error(response)
          T.from_json(response.body)
        end

        private def handle_error(response : HTTP::Client::Response)
          return if response.success?

          message = "API request failed: #{response.status_code} #{response.body}"
          case response.status_code
          when 401
            raise Google::Apis::AuthorizationError.new(message)
          when 400..499
            raise Google::Apis::ClientError.new(message)
          when 500..599
            raise Google::Apis::ServerError.new(message)
          else
            raise Google::Apis::Error.new(message)
          end
        end
      end
    end
  end
end
