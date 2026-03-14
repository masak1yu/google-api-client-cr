require "../../spec_helper"

describe Google::Auth::TokenStore do
  describe "#save and .load" do
    it "persists and restores token data" do
      path = "/tmp/test_token_store_#{Random.new.hex(8)}.json"

      store = Google::Auth::TokenStore.new(
        access_token: "test_access",
        refresh_token: "test_refresh",
        expires_at: "2025-01-01T00:00:00Z"
      )
      store.save(path)

      loaded = Google::Auth::TokenStore.load(path)
      loaded.access_token.should eq("test_access")
      loaded.refresh_token.should eq("test_refresh")
      loaded.expires_at.should eq("2025-01-01T00:00:00Z")

      File.delete(path)
    end
  end

  describe ".from_client" do
    it "extracts tokens from OAuth2Client" do
      client = Google::Auth::OAuth2Client.new("id", "secret")
      client.access_token = "my_token"
      client.refresh_token = "my_refresh"
      client.expires_at = Time.utc(2025, 6, 1, 12, 0, 0)

      store = Google::Auth::TokenStore.from_client(client)
      store.access_token.should eq("my_token")
      store.refresh_token.should eq("my_refresh")
      store.expires_at.not_nil!.should contain("2025-06-01")
    end
  end

  describe "#apply_to" do
    it "applies stored tokens to OAuth2Client" do
      store = Google::Auth::TokenStore.new(
        access_token: "restored_token",
        refresh_token: "restored_refresh",
        expires_at: "2025-06-01T12:00:00Z"
      )

      client = Google::Auth::OAuth2Client.new("id", "secret")
      store.apply_to(client)

      client.access_token.should eq("restored_token")
      client.refresh_token.should eq("restored_refresh")
      client.expires_at.not_nil!.year.should eq(2025)
    end
  end
end
