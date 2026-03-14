require "http/client"
require "openssl"

module Google
  module Apis
    module Core
      class BatchRequest
        MAX_BATCH_SIZE = 50

        struct Entry
          getter method : String
          getter path : String
          getter body : String?
          getter headers : Hash(String, String)
          getter callback : Proc(HTTP::Client::Response, Nil)?

          def initialize(@method, @path, @body = nil, @headers = {} of String => String,
                         @callback = nil)
          end
        end

        getter entries : Array(Entry)

        @host : String
        @batch_path : String
        @authorization : String?

        def initialize(@host : String, @batch_path : String = "/batch/youtube/v3",
                       @authorization : String? = nil)
          @entries = [] of Entry
        end

        def add(method : String, path : String, body : String? = nil,
                headers : Hash(String, String) = {} of String => String,
                &callback : HTTP::Client::Response ->) : Nil
          if @entries.size >= MAX_BATCH_SIZE
            raise Google::Apis::Error.new("Batch request limit exceeded (max #{MAX_BATCH_SIZE})")
          end
          @entries << Entry.new(method, path, body, headers, callback)
        end

        def add(method : String, path : String, body : String? = nil,
                headers : Hash(String, String) = {} of String => String) : Nil
          if @entries.size >= MAX_BATCH_SIZE
            raise Google::Apis::Error.new("Batch request limit exceeded (max #{MAX_BATCH_SIZE})")
          end
          @entries << Entry.new(method, path, body, headers)
        end

        def execute : Array(HTTP::Client::Response)
          raise Google::Apis::Error.new("No requests in batch") if @entries.empty?

          boundary = "batch_#{Random.new.hex(16)}"
          body = build_multipart_body(boundary)

          client = HTTP::Client.new(@host, tls: OpenSSL::SSL::Context::Client.new)
          headers = HTTP::Headers{
            "Content-Type" => "multipart/mixed; boundary=#{boundary}",
          }
          if auth = @authorization
            headers["Authorization"] = auth
          end

          response = client.post(@batch_path, headers: headers, body: body)
          unless response.success?
            raise Google::Apis::Error.new("Batch request failed: #{response.status_code} #{response.body}")
          end

          responses = parse_multipart_response(response)

          @entries.each_with_index do |entry, i|
            if cb = entry.callback
              cb.call(responses[i]) if i < responses.size
            end
          end

          responses
        end

        private def build_multipart_body(boundary : String) : String
          io = IO::Memory.new
          @entries.each_with_index do |entry, i|
            io << "--#{boundary}\r\n"
            io << "Content-Type: application/http\r\n"
            io << "Content-ID: <item#{i + 1}>\r\n\r\n"

            io << "#{entry.method.upcase} #{entry.path} HTTP/1.1\r\n"
            entry.headers.each do |k, v|
              io << "#{k}: #{v}\r\n"
            end
            if body = entry.body
              io << "Content-Type: application/json\r\n"
              io << "Content-Length: #{body.bytesize}\r\n"
            end
            io << "\r\n"
            io << entry.body if entry.body
            io << "\r\n"
          end
          io << "--#{boundary}--\r\n"
          io.to_s
        end

        private def parse_multipart_response(response : HTTP::Client::Response) : Array(HTTP::Client::Response)
          content_type = response.headers["Content-Type"]? || ""
          boundary = extract_boundary(content_type)
          return [response] unless boundary

          parts = response.body.split("--#{boundary}")
          results = [] of HTTP::Client::Response

          parts.each do |part|
            next if part.strip.empty? || part.strip == "--"
            if http_start = part.index("HTTP/")
              http_part = part[http_start..]
              parsed = parse_http_response(http_part)
              results << parsed if parsed
            end
          end

          results
        end

        private def extract_boundary(content_type : String) : String?
          if match = content_type.match(/boundary=(.+?)(?:;|$)/)
            match[1].strip.strip('"')
          end
        end

        private def parse_http_response(raw : String) : HTTP::Client::Response?
          lines = raw.strip.split("\r\n")
          return nil if lines.empty?

          status_line = lines[0]
          if match = status_line.match(/HTTP\/[\d.]+ (\d+)/)
            status_code = match[1].to_i
          else
            return nil
          end

          headers = HTTP::Headers.new
          body_start = 1
          lines[1..].each_with_index do |line, i|
            if line.empty?
              body_start = i + 2
              break
            end
            if colon = line.index(':')
              key = line[0...colon].strip
              value = line[colon + 1..].strip
              headers[key] = value
            end
          end

          body = lines[body_start..].join("\r\n")
          HTTP::Client::Response.new(status_code, body: body, headers: headers)
        end
      end
    end
  end
end
