require "spec"
require "http/server"
require "../src/google-api-client-cr"

# A local HTTP server that returns preconfigured responses per request path.
# Used to test service methods without hitting the real Google API.
class MockAPIServer
  getter port : Int32
  @server : HTTP::Server
  @responses : Hash(String, {Int32, String}) # path => {status, body}

  def initialize
    @responses = {} of String => {Int32, String}
    @port = 0
    @server = HTTP::Server.new do |context|
      # Match on path only (ignore query string) for simpler registration
      path = context.request.path
      if response = @responses[path]?
        context.response.status_code = response[0]
        context.response.content_type = "application/json"
        context.response.print response[1]
      else
        context.response.status_code = 404
        context.response.print %({"error":"not found","path":"#{path}"})
      end
    end
    address = @server.bind_tcp("127.0.0.1", 0)
    @port = address.port
    spawn { @server.listen }
    Fiber.yield # let the server start
  end

  # Register a canned response for a given path.
  def register(path : String, status : Int32 = 200, body : String = "{}")
    @responses[path] = {status, body}
  end

  def close
    @server.close
  end
end

# Subclass that exposes the protected client= setter for testing.
class TestableYouTubeService < Google::Apis::YoutubeV3::YouTubeService
  def set_test_client(client : HTTP::Client)
    self.client = client
  end
end

# Create a YouTubeService wired to a MockAPIServer.
def create_test_service(mock : MockAPIServer) : TestableYouTubeService
  service = TestableYouTubeService.new
  client = HTTP::Client.new("127.0.0.1", mock.port)
  service.set_test_client(client)
  service.key = nil
  service.max_retries = 0 # don't retry in tests
  service
end
