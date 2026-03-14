require "http/client"
require "openssl"
require "json"
require "uri"

module Google
  module Apis
    module Core
      class ResumableUpload
        DEFAULT_CHUNK_SIZE = 8 * 1024 * 1024 # 8MB

        property session_uri : String?
        property chunk_size : Int32
        property total_size : Int64
        property bytes_sent : Int64 = 0

        @client : HTTP::Client?

        def initialize(@chunk_size : Int32 = DEFAULT_CHUNK_SIZE, @total_size : Int64 = 0)
        end

        # Initiate a resumable upload session
        def initiate(host : String, path : String, headers : HTTP::Headers,
                     metadata_json : String? = nil) : String
          client = HTTP::Client.new(host, tls: OpenSSL::SSL::Context::Client.new)

          headers["X-Upload-Content-Length"] = @total_size.to_s if @total_size > 0

          body = metadata_json
          if body
            headers["Content-Type"] = "application/json; charset=UTF-8"
          end

          response = client.post(path, headers: headers, body: body)
          unless response.status_code == 200
            raise Google::Apis::Error.new("Failed to initiate resumable upload: #{response.status_code} #{response.body}")
          end

          @session_uri = response.headers["Location"]? ||
                         raise Google::Apis::Error.new("No Location header in resumable upload initiation response")
          @session_uri.not_nil!
        end

        # Upload the entire file in chunks
        def upload(source : IO, max_retries : Int32 = 3) : HTTP::Client::Response
          uri = URI.parse(@session_uri.not_nil!)
          client = HTTP::Client.new(uri.host.not_nil!, tls: OpenSSL::SSL::Context::Client.new)

          @bytes_sent = 0_i64
          buffer = Bytes.new(@chunk_size)

          loop do
            bytes_read = source.read(buffer)
            break if bytes_read == 0

            chunk = buffer[0, bytes_read]
            range_start = @bytes_sent
            range_end = @bytes_sent + bytes_read - 1
            total = @total_size > 0 ? @total_size.to_s : "*"

            headers = HTTP::Headers{
              "Content-Length" => bytes_read.to_s,
              "Content-Range"  => "bytes #{range_start}-#{range_end}/#{total}",
            }

            response = upload_chunk_with_retries(client, uri, chunk, headers, max_retries)
            @bytes_sent += bytes_read

            case response.status_code
            when 200, 201
              return response
            when 308
              next
            else
              raise Google::Apis::Error.new("Upload chunk failed: #{response.status_code} #{response.body}")
            end
          end

          raise Google::Apis::Error.new("Upload completed without final response")
        end

        # Query the upload status to resume
        def query_status(max_retries : Int32 = 3) : Int64
          uri = URI.parse(@session_uri.not_nil!)
          client = HTTP::Client.new(uri.host.not_nil!, tls: OpenSSL::SSL::Context::Client.new)
          total = @total_size > 0 ? @total_size.to_s : "*"

          headers = HTTP::Headers{
            "Content-Length" => "0",
            "Content-Range"  => "bytes */#{total}",
          }

          response = client.put(uri.request_target, headers: headers)
          case response.status_code
          when 308
            if range = response.headers["Range"]?
              @bytes_sent = range.split("-").last.to_i64 + 1
            end
          when 200, 201
            @bytes_sent = @total_size
          end
          @bytes_sent
        end

        private def upload_chunk_with_retries(client : HTTP::Client, uri : URI, chunk : Bytes,
                                              headers : HTTP::Headers, max_retries : Int32) : HTTP::Client::Response
          retries = 0
          loop do
            response = client.put(uri.request_target, headers: headers, body: chunk)
            if (response.status_code == 429 || response.status_code >= 500) && retries < max_retries
              retries += 1
              sleep((2 ** (retries - 1)).seconds + Random.rand.seconds)
              next
            end
            return response
          end
        end
      end
    end
  end
end
