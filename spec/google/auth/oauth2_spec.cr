require "../../spec_helper"

describe Google::Auth::OAuth2Client do
  describe "#initialize" do
    it "creates client with credentials" do
      client = Google::Auth::OAuth2Client.new("client_id", "client_secret")
      client.client_id.should eq("client_id")
      client.client_secret.should eq("client_secret")
      client.redirect_uri.should eq("urn:ietf:wg:oauth:2.0:oob")
    end
  end

  describe "#authorization_url" do
    it "generates correct URL with single scope" do
      client = Google::Auth::OAuth2Client.new("my_id", "my_secret")
      url = client.authorization_url(scope: "https://www.googleapis.com/auth/youtube")

      url.should contain("accounts.google.com")
      url.should contain("client_id=my_id")
      url.should contain("response_type=code")
      url.should contain("access_type=offline")
      url.should contain("prompt=consent")
    end

    it "generates correct URL with multiple scopes" do
      client = Google::Auth::OAuth2Client.new("my_id", "my_secret")
      url = client.authorization_url(scope: [
        Google::Auth::Scopes::YOUTUBE,
        Google::Auth::Scopes::YOUTUBE_READONLY,
      ])

      url.should contain("youtube.readonly")
    end

    it "includes state parameter when provided" do
      client = Google::Auth::OAuth2Client.new("my_id", "my_secret")
      url = client.authorization_url(scope: "test", state: "my_state")
      url.should contain("state=my_state")
    end
  end

  describe "#expired?" do
    it "returns true when expires_at is nil" do
      client = Google::Auth::OAuth2Client.new("id", "secret")
      client.expired?.should be_true
    end

    it "returns false when expires_at is in the future" do
      client = Google::Auth::OAuth2Client.new("id", "secret")
      client.expires_at = Time.utc + 1.hour
      client.expired?.should be_false
    end

    it "returns true when expires_at is in the past" do
      client = Google::Auth::OAuth2Client.new("id", "secret")
      client.expires_at = Time.utc - 1.second
      client.expired?.should be_true
    end
  end

  describe "#valid_token" do
    it "returns access_token when not expired" do
      client = Google::Auth::OAuth2Client.new("id", "secret")
      client.access_token = "test_token"
      client.expires_at = Time.utc + 1.hour

      client.valid_token.should eq("test_token")
    end

    it "raises when no token and no refresh_token" do
      client = Google::Auth::OAuth2Client.new("id", "secret")
      expect_raises(Google::Auth::Error, "No valid access token") do
        client.valid_token
      end
    end
  end
end

describe Google::Auth::Scopes do
  it "defines YouTube scopes" do
    Google::Auth::Scopes::YOUTUBE.should eq("https://www.googleapis.com/auth/youtube")
    Google::Auth::Scopes::YOUTUBE_READONLY.should eq("https://www.googleapis.com/auth/youtube.readonly")
    Google::Auth::Scopes::YOUTUBE_UPLOAD.should eq("https://www.googleapis.com/auth/youtube.upload")
  end
end
