require "../../../spec_helper"

describe "YouTube V3 Data Models" do
  describe Google::Apis::YoutubeV3::SearchListsResponse do
    it "deserializes search response JSON" do
      json = File.read("spec/fixtures/search_response.json")
      response = Google::Apis::YoutubeV3::SearchListsResponse.from_json(json)

      response.kind.should eq("youtube#searchListResponse")
      response.etag.should eq("test_etag")
      response.next_page_token.should eq("CAUQAA")
      response.region_code.should eq("JP")
      response.page_info.not_nil!.total_results.should eq(1000000)
      response.page_info.not_nil!.results_per_page.should eq(5)

      items = response.items.not_nil!
      items.size.should eq(1)

      item = items[0]
      item.id.not_nil!.video_id.should eq("abc123")
      item.snippet.not_nil!.title.should eq("Test Video")
      item.snippet.not_nil!.channel_title.should eq("Test Channel")
    end

    it "includes Paginated module" do
      json = File.read("spec/fixtures/search_response.json")
      response = Google::Apis::YoutubeV3::SearchListsResponse.from_json(json)
      response.is_a?(Google::Apis::Core::Paginated).should be_true
      response.next_page_token.should eq("CAUQAA")
    end
  end

  describe Google::Apis::YoutubeV3::ListVideosResponse do
    it "deserializes video response JSON" do
      json = File.read("spec/fixtures/video_response.json")
      response = Google::Apis::YoutubeV3::ListVideosResponse.from_json(json)

      items = response.items.not_nil!
      items.size.should eq(1)

      video = items[0]
      video.id.should eq("abc123")
      video.snippet.not_nil!.title.should eq("Test Video Title")
      video.snippet.not_nil!.tags.should eq(["test", "crystal"])
      video.snippet.not_nil!.category_id.should eq("22")
      video.statistics.not_nil!.view_count.should eq("12345")
      video.statistics.not_nil!.like_count.should eq("100")
      video.status.not_nil!.privacy_status.should eq("public")
      video.status.not_nil!.embeddable.should be_true
      video.status.not_nil!.made_for_kids.should be_false
      video.content_details.not_nil!.duration.should eq("PT10M30S")
      video.content_details.not_nil!.definition.should eq("hd")
    end
  end

  describe Google::Apis::YoutubeV3::ThumbnailDetails do
    it "deserializes thumbnails" do
      json = File.read("spec/fixtures/search_response.json")
      response = Google::Apis::YoutubeV3::SearchListsResponse.from_json(json)
      thumbnails = response.items.not_nil![0].snippet.not_nil!.thumbnails.not_nil!

      thumbnails.default.not_nil!.width.should eq(120)
      thumbnails.medium.not_nil!.width.should eq(320)
      thumbnails.high.not_nil!.width.should eq(480)
    end
  end

  describe "JSON round-trip" do
    it "serializes and deserializes Video" do
      video = Google::Apis::YoutubeV3::Video.from_json(%({
        "id": "test",
        "snippet": {"title": "My Video", "tags": ["a", "b"]},
        "status": {"privacyStatus": "private", "embeddable": true}
      }))

      json = video.to_json
      restored = Google::Apis::YoutubeV3::Video.from_json(json)

      restored.id.should eq("test")
      restored.snippet.not_nil!.title.should eq("My Video")
      restored.snippet.not_nil!.tags.should eq(["a", "b"])
      restored.status.not_nil!.privacy_status.should eq("private")
      restored.status.not_nil!.embeddable.should be_true
    end

    it "serializes and deserializes Playlist" do
      playlist = Google::Apis::YoutubeV3::Playlist.from_json(%({
        "snippet": {"title": "Test Playlist", "description": "Desc"},
        "status": {"privacyStatus": "unlisted"}
      }))

      json = playlist.to_json
      restored = Google::Apis::YoutubeV3::Playlist.from_json(json)
      restored.snippet.not_nil!.title.should eq("Test Playlist")
      restored.status.not_nil!.privacy_status.should eq("unlisted")
    end

    it "serializes and deserializes PlaylistItem with ResourceId" do
      item = Google::Apis::YoutubeV3::PlaylistItem.from_json(%({
        "snippet": {
          "playlistId": "PL123",
          "resourceId": {"kind": "youtube#video", "videoId": "vid1"}
        }
      }))

      json = item.to_json
      restored = Google::Apis::YoutubeV3::PlaylistItem.from_json(json)
      restored.snippet.not_nil!.playlist_id.should eq("PL123")
      restored.snippet.not_nil!.resource_id.not_nil!.video_id.should eq("vid1")
    end

    it "serializes and deserializes Cuepoint" do
      cuepoint = Google::Apis::YoutubeV3::Cuepoint.from_json(%({
        "cueType": "cueTypeAd",
        "durationSecs": 30
      }))

      cuepoint.cue_type.should eq("cueTypeAd")
      cuepoint.duration_secs.should eq(30)
    end

    it "handles nil fields gracefully" do
      video = Google::Apis::YoutubeV3::Video.from_json(%({"id": "test"}))
      video.snippet.should be_nil
      video.statistics.should be_nil
      video.status.should be_nil
      video.content_details.should be_nil
    end
  end
end
