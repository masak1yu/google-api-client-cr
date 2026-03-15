require "http/client"
require "openssl"
require "json"
require "uri"

module Google
  module Apis
    module Core
      # Base class for all Google API services.
      # Handles HTTP communication, authentication, retries, and file upload/download.
      class BaseService
        # The API host (e.g. "www.googleapis.com")
        property root_url : String
        # The API base path (e.g. "youtube/v3/")
        property base_path : String
        # API key for unauthenticated requests. Read from `ENV["API_KEY"]` by default.
        property key : String?
        # OAuth2 access token for authenticated requests.
        property access_token : String?
        # Maximum number of retries on 429/5xx errors (default: 3).
        property max_retries : Int32 = 3

        @client : HTTP::Client

        def initialize(@root_url : String, @base_path : String)
          @client = HTTP::Client.new(@root_url, tls: OpenSSL::SSL::Context::Client.new)
          @key = ENV["API_KEY"]?
        end

        # :nodoc:
        # For testing: allows replacing the HTTP client with one pointing to a local test server.
        protected def client=(client : HTTP::Client)
          @client = client
        end

        # Execute an HTTP request with automatic retry on transient errors.
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

          execute_with_retries do
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
          if json = body_json
            io << "--#{boundary}\r\n"
            io << "Content-Type: application/json; charset=UTF-8\r\n\r\n"
            io << json << "\r\n"
          end
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

          body_str = io.to_s
          response = execute_with_retries do
            case method.upcase
            when "POST"
              @client.post(full_path, headers: headers, body: body_str)
            when "PUT"
              @client.put(full_path, headers: headers, body: body_str)
            else
              raise "Unsupported upload method: #{method}"
            end
          end
          handle_error(response)
          T.from_json(response.body)
        end

        private def execute_resumable_upload(response_type : T.class, path : String,
                                             query : Hash(String, String?) = {} of String => String?,
                                             upload_source : String | IO = "",
                                             content_type : String = "application/octet-stream",
                                             body_json : String? = nil) : T forall T
          query["key"] = @key if @key && !@access_token
          query["uploadType"] = "resumable"
          query_string = query.compact.map { |k, v| "#{URI.encode_www_form(k)}=#{URI.encode_www_form(v.to_s)}" }.join("&")
          full_path = "/upload/#{@base_path}#{path}"
          full_path += "?#{query_string}" unless query_string.empty?

          source_io = case upload_source
                      when String
                        File.open(upload_source)
                      when IO
                        upload_source
                      end

          total_size = case upload_source
                       when String
                         File.size(upload_source).to_i64
                       else
                         0_i64
                       end

          headers = HTTP::Headers.new
          headers["X-Upload-Content-Type"] = content_type
          if token = @access_token
            headers["Authorization"] = "Bearer #{token}"
          end

          uploader = ResumableUpload.new(total_size: total_size)
          uploader.initiate(@root_url, full_path, headers, body_json)
          response = uploader.upload(source_io, @max_retries)

          if upload_source.is_a?(String) && source_io.is_a?(File)
            source_io.close
          end

          handle_error(response)
          T.from_json(response.body)
        end

        private def execute_with_retries(& : -> HTTP::Client::Response) : HTTP::Client::Response
          retries = 0
          loop do
            response = yield
            if retryable?(response) && retries < @max_retries
              retries += 1
              wait = retry_delay(retries, response)
              sleep(wait)
              next
            end
            return response
          end
        end

        private def retryable?(response : HTTP::Client::Response) : Bool
          response.status_code == 429 || response.status_code >= 500
        end

        private def retry_delay(attempt : Int32, response : HTTP::Client::Response) : Time::Span
          if retry_after = response.headers["Retry-After"]?
            return retry_after.to_i.seconds rescue 1.second
          end
          base = (2 ** (attempt - 1)).to_f
          jitter = Random.rand * base
          (base + jitter).seconds
        end

        private def handle_error(response : HTTP::Client::Response)
          return if response.success?

          message = "API request failed: #{response.status_code} #{response.body}"
          case response.status_code
          when 401
            raise Google::Apis::AuthorizationError.new(message, response.status_code)
          when 429
            raise Google::Apis::RateLimitError.new(message, response.status_code)
          when 400..499
            raise Google::Apis::ClientError.new(message, response.status_code)
          when 500..599
            raise Google::Apis::ServerError.new(message, response.status_code)
          else
            raise Google::Apis::Error.new(message, response.status_code)
          end
        end
      end
    end
  end
end
