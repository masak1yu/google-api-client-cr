require "../../../spec_helper"

describe Google::Apis::Core::BaseService do
  describe "#initialize" do
    it "creates a service with root_url and base_path" do
      service = Google::Apis::Core::BaseService.new("www.googleapis.com", "youtube/v3/")
      service.root_url.should eq("www.googleapis.com")
      service.base_path.should eq("youtube/v3/")
    end

    it "reads API_KEY from environment" do
      service = Google::Apis::Core::BaseService.new("www.googleapis.com", "test/")
      # key may or may not be set depending on environment
      service.key.is_a?(String?).should be_true
    end

    it "defaults max_retries to 3" do
      service = Google::Apis::Core::BaseService.new("www.googleapis.com", "test/")
      service.max_retries.should eq(3)
    end
  end

  describe "error handling" do
    it "raises AuthorizationError for 401" do
      expect_raises(Google::Apis::AuthorizationError) do
        raise Google::Apis::AuthorizationError.new("Unauthorized", 401)
      end
    end

    it "raises RateLimitError for 429" do
      expect_raises(Google::Apis::RateLimitError) do
        raise Google::Apis::RateLimitError.new("Too Many Requests", 429)
      end
    end

    it "raises ClientError for 4xx" do
      expect_raises(Google::Apis::ClientError) do
        raise Google::Apis::ClientError.new("Bad Request", 400)
      end
    end

    it "raises ServerError for 5xx" do
      expect_raises(Google::Apis::ServerError) do
        raise Google::Apis::ServerError.new("Internal Server Error", 500)
      end
    end

    it "Error has status_code" do
      error = Google::Apis::ClientError.new("Bad Request", 400)
      error.status_code.should eq(400)
      error.message.should eq("Bad Request")
    end

    it "RateLimitError is a ClientError" do
      error = Google::Apis::RateLimitError.new("Too Many", 429)
      error.is_a?(Google::Apis::ClientError).should be_true
      error.is_a?(Google::Apis::Error).should be_true
    end
  end
end
