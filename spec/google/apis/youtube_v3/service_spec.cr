require "../../../spec_helper"

describe Google::Apis::YoutubeV3::YouTubeService do
  # ============================================================
  # Search
  # ============================================================

  describe "#list_searches" do
    it "returns parsed SearchListsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/search", 200, %({
        "kind":"youtube#searchListResponse","etag":"test_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "nextPageToken":"TOKEN2",
        "items":[{
          "kind":"youtube#searchResult","etag":"item_etag",
          "id":{"kind":"youtube#video","videoId":"vid123"},
          "snippet":{"publishedAt":"2024-01-01T00:00:00Z","channelId":"UC123",
            "title":"Test Video","description":"desc",
            "thumbnails":{"default":{"url":"https://example.com/thumb.jpg","width":120,"height":90}},
            "channelTitle":"TestCh","liveBroadcastContent":"none"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_searches("snippet", q: "test", type: "video", max_results: 5)
        result.kind.should eq("youtube#searchListResponse")
        result.etag.should eq("test_etag")
        result.next_page_token.should eq("TOKEN2")
        result.page_info.not_nil!.total_results.should eq(1)
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.not_nil!.video_id.should eq("vid123")
        items[0].snippet.not_nil!.title.should eq("Test Video")
        items[0].snippet.not_nil!.channel_title.should eq("TestCh")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Videos
  # ============================================================

  describe "#list_videos" do
    it "returns parsed ListVideosResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos", 200, %({
        "kind":"youtube#videoListResponse","etag":"test",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#video","etag":"v_etag","id":"vid456",
          "snippet":{"title":"My Video","channelId":"UC1","categoryId":"22",
            "thumbnails":{"default":{"url":"https://example.com/t.jpg","width":120,"height":90}}},
          "statistics":{"viewCount":"100","likeCount":"10","commentCount":"5"},
          "contentDetails":{"duration":"PT5M","definition":"hd"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_videos("snippet,statistics,contentDetails", id: "vid456")
        result.kind.should eq("youtube#videoListResponse")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("vid456")
        items[0].snippet.not_nil!.title.should eq("My Video")
        items[0].statistics.not_nil!.view_count.should eq("100")
        items[0].content_details.not_nil!.duration.should eq("PT5M")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_video" do
    it "returns parsed Video on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos", 200, %({
        "kind":"youtube#video","etag":"new","id":"new_vid",
        "snippet":{"title":"Uploaded","categoryId":"22"},
        "status":{"privacyStatus":"private"}
      }))
      begin
        service = create_test_service(mock)
        video = Google::Apis::YoutubeV3::Video.from_json(%({"snippet":{"title":"Uploaded","categoryId":"22"},"status":{"privacyStatus":"private"}}))
        result = service.insert_video("snippet,status", video)
        result.id.should eq("new_vid")
        result.snippet.not_nil!.title.should eq("Uploaded")
        result.status.not_nil!.privacy_status.should eq("private")
      ensure
        mock.close
      end
    end
  end

  describe "#update_video" do
    it "returns parsed Video on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos", 200, %({
        "kind":"youtube#video","etag":"upd","id":"vid456",
        "snippet":{"title":"Updated Title"}
      }))
      begin
        service = create_test_service(mock)
        video = Google::Apis::YoutubeV3::Video.from_json(%({"id":"vid456","snippet":{"title":"Updated Title"}}))
        result = service.update_video("snippet", video)
        result.id.should eq("vid456")
        result.snippet.not_nil!.title.should eq("Updated Title")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_video" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_video("vid456")
      ensure
        mock.close
      end
    end
  end

  describe "#rate_video" do
    it "completes without error" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos/rate", 204, "")
      begin
        service = create_test_service(mock)
        service.rate_video("vid456", "like")
      ensure
        mock.close
      end
    end
  end

  describe "#get_video_rating" do
    it "returns JSON::Any" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos/getRating", 200, %({"items":[{"videoId":"vid456","rating":"like"}]}))
      begin
        service = create_test_service(mock)
        result = service.get_video_rating("vid456")
        result["items"][0]["rating"].as_s.should eq("like")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Channels
  # ============================================================

  describe "#list_channels" do
    it "returns parsed ListChannelsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/channels", 200, %({
        "kind":"youtube#channelListResponse","etag":"ch_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#channel","etag":"c_etag","id":"UC123",
          "snippet":{"title":"Test Channel","description":"A channel"},
          "statistics":{"viewCount":"5000","subscriberCount":"100","videoCount":"50"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_channels("snippet,statistics", id: "UC123")
        result.kind.should eq("youtube#channelListResponse")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("UC123")
        items[0].snippet.not_nil!.title.should eq("Test Channel")
        items[0].statistics.not_nil!.subscriber_count.should eq("100")
      ensure
        mock.close
      end
    end
  end

  describe "#update_channel" do
    it "returns parsed Channel on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/channels", 200, %({
        "kind":"youtube#channel","etag":"upd","id":"UC123",
        "snippet":{"title":"Updated Channel"}
      }))
      begin
        service = create_test_service(mock)
        channel = Google::Apis::YoutubeV3::Channel.from_json(%({"id":"UC123","snippet":{"title":"Updated Channel"}}))
        result = service.update_channel("snippet", channel)
        result.snippet.not_nil!.title.should eq("Updated Channel")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Playlists
  # ============================================================

  describe "#list_playlists" do
    it "returns parsed ListPlaylistsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlists", 200, %({
        "kind":"youtube#playlistListResponse","etag":"pl_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#playlist","etag":"p_etag","id":"PL123",
          "snippet":{"title":"My Playlist","description":"desc"},
          "contentDetails":{"itemCount":10},
          "status":{"privacyStatus":"public"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_playlists("snippet,contentDetails,status", channel_id: "UC123")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("PL123")
        items[0].snippet.not_nil!.title.should eq("My Playlist")
        items[0].content_details.not_nil!.item_count.should eq(10)
        items[0].status.not_nil!.privacy_status.should eq("public")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_playlist" do
    it "returns parsed Playlist on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlists", 200, %({
        "kind":"youtube#playlist","id":"PL_NEW",
        "snippet":{"title":"New Playlist"},"status":{"privacyStatus":"private"}
      }))
      begin
        service = create_test_service(mock)
        playlist = Google::Apis::YoutubeV3::Playlist.from_json(%({"snippet":{"title":"New Playlist"},"status":{"privacyStatus":"private"}}))
        result = service.insert_playlist("snippet,status", playlist)
        result.id.should eq("PL_NEW")
      ensure
        mock.close
      end
    end
  end

  describe "#update_playlist" do
    it "returns parsed Playlist on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlists", 200, %({
        "kind":"youtube#playlist","id":"PL123",
        "snippet":{"title":"Renamed"}
      }))
      begin
        service = create_test_service(mock)
        playlist = Google::Apis::YoutubeV3::Playlist.from_json(%({"id":"PL123","snippet":{"title":"Renamed"}}))
        result = service.update_playlist("snippet", playlist)
        result.snippet.not_nil!.title.should eq("Renamed")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_playlist" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlists", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_playlist("PL123")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # PlaylistItems
  # ============================================================

  describe "#list_playlist_items" do
    it "returns parsed ListPlaylistItemsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlistItems", 200, %({
        "kind":"youtube#playlistItemListResponse","etag":"pi_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#playlistItem","etag":"pi_e","id":"PLI1",
          "snippet":{"playlistId":"PL123","position":0,
            "resourceId":{"kind":"youtube#video","videoId":"vid1"}},
          "contentDetails":{"videoId":"vid1"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_playlist_items("snippet,contentDetails", playlist_id: "PL123")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.playlist_id.should eq("PL123")
        items[0].snippet.not_nil!.resource_id.not_nil!.video_id.should eq("vid1")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_playlist_item" do
    it "returns parsed PlaylistItem on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlistItems", 200, %({
        "kind":"youtube#playlistItem","id":"PLI_NEW",
        "snippet":{"playlistId":"PL123","resourceId":{"kind":"youtube#video","videoId":"vid1"}}
      }))
      begin
        service = create_test_service(mock)
        item = Google::Apis::YoutubeV3::PlaylistItem.from_json(%({"snippet":{"playlistId":"PL123","resourceId":{"kind":"youtube#video","videoId":"vid1"}}}))
        result = service.insert_playlist_item("snippet", item)
        result.id.should eq("PLI_NEW")
      ensure
        mock.close
      end
    end
  end

  describe "#update_playlist_item" do
    it "returns parsed PlaylistItem on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlistItems", 200, %({
        "kind":"youtube#playlistItem","id":"PLI1",
        "snippet":{"playlistId":"PL123","position":2,"resourceId":{"kind":"youtube#video","videoId":"vid1"}}
      }))
      begin
        service = create_test_service(mock)
        item = Google::Apis::YoutubeV3::PlaylistItem.from_json(%({"id":"PLI1","snippet":{"playlistId":"PL123","position":2,"resourceId":{"kind":"youtube#video","videoId":"vid1"}}}))
        result = service.update_playlist_item("snippet", item)
        result.snippet.not_nil!.position.should eq(2)
      ensure
        mock.close
      end
    end
  end

  describe "#delete_playlist_item" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlistItems", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_playlist_item("PLI1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Comments
  # ============================================================

  describe "#list_comments" do
    it "returns parsed ListCommentsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/comments", 200, %({
        "kind":"youtube#commentListResponse","etag":"cm_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":20},
        "items":[{
          "kind":"youtube#comment","etag":"c_e","id":"cmt1",
          "snippet":{"textDisplay":"Great video!","likeCount":5,"authorDisplayName":"User1"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_comments("snippet", parent_id: "cmt_parent")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("cmt1")
        items[0].snippet.not_nil!.text_display.should eq("Great video!")
        items[0].snippet.not_nil!.like_count.should eq(5)
      ensure
        mock.close
      end
    end
  end

  describe "#insert_comment" do
    it "returns parsed Comment on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/comments", 200, %({
        "kind":"youtube#comment","id":"cmt_new",
        "snippet":{"textOriginal":"Nice!","textDisplay":"Nice!"}
      }))
      begin
        service = create_test_service(mock)
        comment = Google::Apis::YoutubeV3::Comment.from_json(%({"snippet":{"textOriginal":"Nice!"}}))
        result = service.insert_comment("snippet", comment)
        result.id.should eq("cmt_new")
      ensure
        mock.close
      end
    end
  end

  describe "#update_comment" do
    it "returns parsed Comment on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/comments", 200, %({
        "kind":"youtube#comment","id":"cmt1",
        "snippet":{"textOriginal":"Edited","textDisplay":"Edited"}
      }))
      begin
        service = create_test_service(mock)
        comment = Google::Apis::YoutubeV3::Comment.from_json(%({"id":"cmt1","snippet":{"textOriginal":"Edited"}}))
        result = service.update_comment("snippet", comment)
        result.snippet.not_nil!.text_display.should eq("Edited")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_comment" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/comments", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_comment("cmt1")
      ensure
        mock.close
      end
    end
  end

  describe "#mark_comment_as_spam" do
    it "completes without error" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/comments/markAsSpam", 204, "")
      begin
        service = create_test_service(mock)
        service.mark_comment_as_spam("cmt1")
      ensure
        mock.close
      end
    end
  end

  describe "#set_comment_moderation_status" do
    it "completes without error" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/comments/setModerationStatus", 204, "")
      begin
        service = create_test_service(mock)
        service.set_comment_moderation_status("cmt1", "published")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # CommentThreads
  # ============================================================

  describe "#list_comment_threads" do
    it "returns parsed ListCommentThreadsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/commentThreads", 200, %({
        "kind":"youtube#commentThreadListResponse","etag":"ct_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":20},
        "items":[{
          "kind":"youtube#commentThread","etag":"ct_e","id":"ct1",
          "snippet":{"videoId":"vid1","totalReplyCount":3,"isPublic":true,
            "topLevelComment":{"kind":"youtube#comment","id":"cmt_top","snippet":{"textDisplay":"Top comment"}}}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_comment_threads("snippet", video_id: "vid1")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.total_reply_count.should eq(3)
        items[0].snippet.not_nil!.top_level_comment.not_nil!.snippet.not_nil!.text_display.should eq("Top comment")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_comment_thread" do
    it "returns parsed CommentThread on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/commentThreads", 200, %({
        "kind":"youtube#commentThread","id":"ct_new",
        "snippet":{"videoId":"vid1","topLevelComment":{"kind":"youtube#comment","id":"cmt_new","snippet":{"textOriginal":"Hello"}}}
      }))
      begin
        service = create_test_service(mock)
        ct = Google::Apis::YoutubeV3::CommentThread.from_json(%({"snippet":{"videoId":"vid1","topLevelComment":{"snippet":{"textOriginal":"Hello"}}}}))
        result = service.insert_comment_thread("snippet", ct)
        result.id.should eq("ct_new")
      ensure
        mock.close
      end
    end
  end

  describe "#update_comment_thread" do
    it "returns parsed CommentThread on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/commentThreads", 200, %({
        "kind":"youtube#commentThread","id":"ct1",
        "snippet":{"videoId":"vid1"}
      }))
      begin
        service = create_test_service(mock)
        ct = Google::Apis::YoutubeV3::CommentThread.from_json(%({"id":"ct1","snippet":{"videoId":"vid1"}}))
        result = service.update_comment_thread(ct, part: "snippet")
        result.id.should eq("ct1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Subscriptions
  # ============================================================

  describe "#list_subscriptions" do
    it "returns parsed ListSubscriptionsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/subscriptions", 200, %({
        "kind":"youtube#subscriptionListResponse","etag":"sub_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#subscription","etag":"s_e","id":"sub1",
          "snippet":{"title":"Subscribed Channel","resourceId":{"kind":"youtube#channel","channelId":"UC999"}},
          "contentDetails":{"totalItemCount":50,"newItemCount":2}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_subscriptions("snippet,contentDetails", channel_id: "UC123")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.title.should eq("Subscribed Channel")
        items[0].content_details.not_nil!.total_item_count.should eq(50)
      ensure
        mock.close
      end
    end
  end

  describe "#insert_subscription" do
    it "returns parsed Subscription on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/subscriptions", 200, %({
        "kind":"youtube#subscription","id":"sub_new",
        "snippet":{"resourceId":{"kind":"youtube#channel","channelId":"UC999"}}
      }))
      begin
        service = create_test_service(mock)
        sub = Google::Apis::YoutubeV3::Subscription.from_json(%({"snippet":{"resourceId":{"kind":"youtube#channel","channelId":"UC999"}}}))
        result = service.insert_subscription("snippet", sub)
        result.id.should eq("sub_new")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_subscription" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/subscriptions", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_subscription("sub1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Video Categories
  # ============================================================

  describe "#list_video_categories" do
    it "returns parsed ListVideoCategoriesResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videoCategories", 200, %({
        "kind":"youtube#videoCategoryListResponse","etag":"vc_etag",
        "items":[{
          "kind":"youtube#videoCategory","etag":"vc_e","id":"22",
          "snippet":{"channelId":"UCBR8-60-B28hp2BmDPdntcQ","title":"People & Blogs","assignable":true}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_video_categories("snippet", region_code: "US")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("22")
        items[0].snippet.not_nil!.title.should eq("People & Blogs")
        items[0].snippet.not_nil!.assignable.should be_true
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # I18n Languages
  # ============================================================

  describe "#list_i18n_languages" do
    it "returns parsed ListI18nLanguagesResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/i18nLanguages", 200, %({
        "kind":"youtube#i18nLanguageListResponse","etag":"i18n_etag",
        "items":[{
          "kind":"youtube#i18nLanguage","etag":"l_e","id":"en",
          "snippet":{"hl":"en","name":"English"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_i18n_languages("snippet")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("en")
        items[0].snippet.not_nil!.name.should eq("English")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # I18n Regions
  # ============================================================

  describe "#list_i18n_regions" do
    it "returns parsed ListI18nRegionsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/i18nRegions", 200, %({
        "kind":"youtube#i18nRegionListResponse","etag":"r_etag",
        "items":[{
          "kind":"youtube#i18nRegion","etag":"r_e","id":"US",
          "snippet":{"gl":"US","name":"United States"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_i18n_regions("snippet")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("US")
        items[0].snippet.not_nil!.name.should eq("United States")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Captions
  # ============================================================

  describe "#list_captions" do
    it "returns parsed ListCaptionsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/captions", 200, %({
        "kind":"youtube#captionListResponse","etag":"cap_etag",
        "items":[{
          "kind":"youtube#caption","etag":"c_e","id":"cap1",
          "snippet":{"videoId":"vid1","language":"en","name":"English","status":"serving","trackKind":"standard"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_captions("snippet", video_id: "vid1")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("cap1")
        items[0].snippet.not_nil!.language.should eq("en")
        items[0].snippet.not_nil!.track_kind.should eq("standard")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_caption" do
    it "returns parsed Caption on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/captions", 200, %({
        "kind":"youtube#caption","id":"cap_new",
        "snippet":{"videoId":"vid1","language":"ja","name":"Japanese"}
      }))
      begin
        service = create_test_service(mock)
        caption = Google::Apis::YoutubeV3::Caption.from_json(%({"snippet":{"videoId":"vid1","language":"ja","name":"Japanese"}}))
        result = service.insert_caption("snippet", caption)
        result.id.should eq("cap_new")
      ensure
        mock.close
      end
    end
  end

  describe "#update_caption" do
    it "returns parsed Caption on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/captions", 200, %({
        "kind":"youtube#caption","id":"cap1",
        "snippet":{"videoId":"vid1","language":"en","isDraft":false}
      }))
      begin
        service = create_test_service(mock)
        caption = Google::Apis::YoutubeV3::Caption.from_json(%({"id":"cap1","snippet":{"isDraft":false}}))
        result = service.update_caption("snippet", caption)
        result.snippet.not_nil!.is_draft.should be_false
      ensure
        mock.close
      end
    end
  end

  describe "#delete_caption" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/captions", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_caption("cap1")
      ensure
        mock.close
      end
    end
  end

  describe "#download_caption" do
    it "writes caption content to IO" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/captions/cap1", 200, "WEBVTT\n\n00:00.000 --> 00:05.000\nHello world")
      begin
        service = create_test_service(mock)
        io = IO::Memory.new
        service.download_caption("cap1", download_dest: io)
        io.to_s.should eq("WEBVTT\n\n00:00.000 --> 00:05.000\nHello world")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Channel Sections
  # ============================================================

  describe "#list_channel_sections" do
    it "returns parsed ListChannelSectionsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/channelSections", 200, %({
        "kind":"youtube#channelSectionListResponse","etag":"cs_etag",
        "items":[{
          "kind":"youtube#channelSection","etag":"cs_e","id":"cs1",
          "snippet":{"channelId":"UC123","title":"Uploads","type":"singlePlaylist","position":0}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_channel_sections("snippet", channel_id: "UC123")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("cs1")
        items[0].snippet.not_nil!.type.should eq("singlePlaylist")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_channel_section" do
    it "returns parsed ChannelSection on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/channelSections", 200, %({
        "kind":"youtube#channelSection","id":"cs_new",
        "snippet":{"title":"New Section","type":"multiplePlaylists"}
      }))
      begin
        service = create_test_service(mock)
        cs = Google::Apis::YoutubeV3::ChannelSection.from_json(%({"snippet":{"title":"New Section","type":"multiplePlaylists"}}))
        result = service.insert_channel_section("snippet", cs)
        result.id.should eq("cs_new")
      ensure
        mock.close
      end
    end
  end

  describe "#update_channel_section" do
    it "returns parsed ChannelSection on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/channelSections", 200, %({
        "kind":"youtube#channelSection","id":"cs1",
        "snippet":{"title":"Renamed Section"}
      }))
      begin
        service = create_test_service(mock)
        cs = Google::Apis::YoutubeV3::ChannelSection.from_json(%({"id":"cs1","snippet":{"title":"Renamed Section"}}))
        result = service.update_channel_section("snippet", cs)
        result.snippet.not_nil!.title.should eq("Renamed Section")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_channel_section" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/channelSections", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_channel_section("cs1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Activities
  # ============================================================

  describe "#list_activities" do
    it "returns parsed ListActivitiesResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/activities", 200, %({
        "kind":"youtube#activityListResponse","etag":"act_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#activity","etag":"a_e","id":"act1",
          "snippet":{"type":"upload","title":"New upload","channelId":"UC123"},
          "contentDetails":{"upload":{"videoId":"vid999"}}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_activities("snippet,contentDetails", channel_id: "UC123")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.type.should eq("upload")
        items[0].content_details.not_nil!.upload.not_nil!.video_id.should eq("vid999")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Live Broadcasts
  # ============================================================

  describe "#list_live_broadcasts" do
    it "returns parsed ListLiveBroadcastsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveBroadcasts", 200, %({
        "kind":"youtube#liveBroadcastListResponse","etag":"lb_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#liveBroadcast","etag":"lb_e","id":"lb1",
          "snippet":{"title":"My Stream","scheduledStartTime":"2024-06-01T12:00:00Z"},
          "status":{"lifeCycleStatus":"ready","privacyStatus":"public"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_live_broadcasts("snippet,status")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.title.should eq("My Stream")
        items[0].status.not_nil!.life_cycle_status.should eq("ready")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_live_broadcast" do
    it "returns parsed LiveBroadcast on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveBroadcasts", 200, %({
        "kind":"youtube#liveBroadcast","id":"lb_new",
        "snippet":{"title":"New Broadcast"},
        "status":{"privacyStatus":"private"}
      }))
      begin
        service = create_test_service(mock)
        lb = Google::Apis::YoutubeV3::LiveBroadcast.from_json(%({"snippet":{"title":"New Broadcast"},"status":{"privacyStatus":"private"}}))
        result = service.insert_live_broadcast("snippet,status", lb)
        result.id.should eq("lb_new")
      ensure
        mock.close
      end
    end
  end

  describe "#update_live_broadcast" do
    it "returns parsed LiveBroadcast on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveBroadcasts", 200, %({
        "kind":"youtube#liveBroadcast","id":"lb1",
        "snippet":{"title":"Updated Broadcast"}
      }))
      begin
        service = create_test_service(mock)
        lb = Google::Apis::YoutubeV3::LiveBroadcast.from_json(%({"id":"lb1","snippet":{"title":"Updated Broadcast"}}))
        result = service.update_live_broadcast("snippet", lb)
        result.snippet.not_nil!.title.should eq("Updated Broadcast")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_live_broadcast" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveBroadcasts", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_live_broadcast("lb1")
      ensure
        mock.close
      end
    end
  end

  describe "#bind_live_broadcast" do
    it "returns parsed LiveBroadcast" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveBroadcasts/bind", 200, %({
        "kind":"youtube#liveBroadcast","id":"lb1",
        "contentDetails":{"boundStreamId":"stream1"}
      }))
      begin
        service = create_test_service(mock)
        result = service.bind_live_broadcast("lb1", "snippet,contentDetails", stream_id: "stream1")
        result.content_details.not_nil!.bound_stream_id.should eq("stream1")
      ensure
        mock.close
      end
    end
  end

  describe "#transition_live_broadcast" do
    it "returns parsed LiveBroadcast" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveBroadcasts/transition", 200, %({
        "kind":"youtube#liveBroadcast","id":"lb1",
        "status":{"lifeCycleStatus":"live"}
      }))
      begin
        service = create_test_service(mock)
        result = service.transition_live_broadcast("live", "lb1", "status")
        result.status.not_nil!.life_cycle_status.should eq("live")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Live Streams
  # ============================================================

  describe "#list_live_streams" do
    it "returns parsed ListLiveStreamsResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveStreams", 200, %({
        "kind":"youtube#liveStreamListResponse","etag":"ls_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#liveStream","etag":"ls_e","id":"stream1",
          "snippet":{"title":"My Stream"},
          "status":{"streamStatus":"active"},
          "cdn":{"ingestionType":"rtmp","resolution":"1080p"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_live_streams("snippet,status,cdn")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.title.should eq("My Stream")
        items[0].status.not_nil!.stream_status.should eq("active")
        items[0].cdn.not_nil!.ingestion_type.should eq("rtmp")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_live_stream" do
    it "returns parsed LiveStream on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveStreams", 200, %({
        "kind":"youtube#liveStream","id":"stream_new",
        "snippet":{"title":"New Stream"},
        "cdn":{"ingestionType":"rtmp"}
      }))
      begin
        service = create_test_service(mock)
        ls = Google::Apis::YoutubeV3::LiveStream.from_json(%({"snippet":{"title":"New Stream"},"cdn":{"ingestionType":"rtmp"}}))
        result = service.insert_live_stream("snippet,cdn", ls)
        result.id.should eq("stream_new")
      ensure
        mock.close
      end
    end
  end

  describe "#update_live_stream" do
    it "returns parsed LiveStream on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveStreams", 200, %({
        "kind":"youtube#liveStream","id":"stream1",
        "snippet":{"title":"Renamed Stream"}
      }))
      begin
        service = create_test_service(mock)
        ls = Google::Apis::YoutubeV3::LiveStream.from_json(%({"id":"stream1","snippet":{"title":"Renamed Stream"}}))
        result = service.update_live_stream("snippet", ls)
        result.snippet.not_nil!.title.should eq("Renamed Stream")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_live_stream" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveStreams", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_live_stream("stream1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Live Chat Messages
  # ============================================================

  describe "#list_live_chat_messages" do
    it "returns parsed LiveChatMessageListResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveChat/messages", 200, %({
        "kind":"youtube#liveChatMessageListResponse","etag":"lcm_etag",
        "pollingIntervalMillis":5000,
        "pageInfo":{"totalResults":1,"resultsPerPage":200},
        "items":[{
          "kind":"youtube#liveChatMessage","etag":"lcm_e","id":"msg1",
          "snippet":{"type":"textMessageDetails","liveChatId":"LC1","displayMessage":"Hello!",
            "textMessageDetails":{"messageText":"Hello!"}},
          "authorDetails":{"channelId":"UC1","displayName":"Chatter"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_live_chat_messages("LC1", "snippet,authorDetails")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.display_message.should eq("Hello!")
        items[0].author_details.not_nil!.display_name.should eq("Chatter")
        result.polling_interval_millis.should eq(5000)
      ensure
        mock.close
      end
    end
  end

  describe "#insert_live_chat_message" do
    it "returns parsed LiveChatMessage on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveChat/messages", 200, %({
        "kind":"youtube#liveChatMessage","id":"msg_new",
        "snippet":{"liveChatId":"LC1","textMessageDetails":{"messageText":"Hi there"}}
      }))
      begin
        service = create_test_service(mock)
        msg = Google::Apis::YoutubeV3::LiveChatMessage.from_json(%({"snippet":{"liveChatId":"LC1","textMessageDetails":{"messageText":"Hi there"}}}))
        result = service.insert_live_chat_message("snippet", msg)
        result.id.should eq("msg_new")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_live_chat_message" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveChat/messages", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_live_chat_message("msg1")
      ensure
        mock.close
      end
    end
  end

  describe "#transition_live_chat_message" do
    it "completes without error" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveChat/messages/transition", 204, "")
      begin
        service = create_test_service(mock)
        service.transition_live_chat_message(id: "msg1", status: "closed")
      ensure
        mock.close
      end
    end
  end

  describe "#stream_live_chat_messages" do
    it "returns parsed LiveChatMessageListResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveChat/messages/stream", 200, %({
        "kind":"youtube#liveChatMessageListResponse","etag":"s_etag",
        "items":[]
      }))
      begin
        service = create_test_service(mock)
        result = service.stream_live_chat_messages(live_chat_id: "LC1", part: "snippet")
        result.kind.should eq("youtube#liveChatMessageListResponse")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Live Chat Moderators
  # ============================================================

  describe "#list_live_chat_moderators" do
    it "returns parsed LiveChatModeratorListResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveChat/moderators", 200, %({
        "kind":"youtube#liveChatModeratorListResponse","etag":"lcmod_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#liveChatModerator","etag":"mod_e","id":"mod1",
          "snippet":{"liveChatId":"LC1","moderatorDetails":{"channelId":"UC_MOD","displayName":"Moderator"}}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_live_chat_moderators("LC1", "snippet")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.moderator_details.not_nil!.display_name.should eq("Moderator")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_live_chat_moderator" do
    it "returns parsed LiveChatModerator on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveChat/moderators", 200, %({
        "kind":"youtube#liveChatModerator","id":"mod_new",
        "snippet":{"liveChatId":"LC1"}
      }))
      begin
        service = create_test_service(mock)
        mod = Google::Apis::YoutubeV3::LiveChatModerator.from_json(%({"snippet":{"liveChatId":"LC1"}}))
        result = service.insert_live_chat_moderator("snippet", mod)
        result.id.should eq("mod_new")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_live_chat_moderator" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveChat/moderators", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_live_chat_moderator("mod1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Live Chat Bans
  # ============================================================

  describe "#insert_live_chat_ban" do
    it "returns parsed LiveChatBan on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveChat/bans", 200, %({
        "kind":"youtube#liveChatBan","id":"ban1",
        "snippet":{"liveChatId":"LC1","type":"permanent"}
      }))
      begin
        service = create_test_service(mock)
        ban = Google::Apis::YoutubeV3::LiveChatBan.from_json(%({"snippet":{"liveChatId":"LC1","type":"permanent"}}))
        result = service.insert_live_chat_ban("snippet", ban)
        result.id.should eq("ban1")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_live_chat_ban" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveChat/bans", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_live_chat_ban("ban1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Watermarks
  # ============================================================

  describe "#set_watermark" do
    it "completes without error" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/watermarks/set", 204, "")
      begin
        service = create_test_service(mock)
        branding = Google::Apis::YoutubeV3::InvideoBranding.from_json(%({"targetChannelId":"UC123"}))
        service.set_watermark("UC123", branding)
      ensure
        mock.close
      end
    end
  end

  describe "#unset_watermark" do
    it "completes without error" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/watermarks/unset", 204, "")
      begin
        service = create_test_service(mock)
        service.unset_watermark("UC123")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Thumbnails
  # ============================================================

  describe "#set_thumbnail" do
    it "returns parsed SetThumbnailResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/thumbnails/set", 200, %({
        "kind":"youtube#thumbnailSetResponse","etag":"th_etag",
        "items":[{"default":{"url":"https://example.com/thumb.jpg","width":120,"height":90}}]
      }))
      begin
        service = create_test_service(mock)
        result = service.set_thumbnail("vid1")
        result.items.not_nil!.size.should eq(1)
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Members
  # ============================================================

  describe "#list_members" do
    it "returns parsed MemberListResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/members", 200, %({
        "kind":"youtube#memberListResponse","etag":"mem_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#member","etag":"m_e",
          "snippet":{"creatorChannelId":"UC123",
            "memberDetails":{"channelId":"UC_MEM","displayName":"Member1"}}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_members("snippet")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.member_details.not_nil!.display_name.should eq("Member1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Memberships Levels
  # ============================================================

  describe "#list_memberships_levels" do
    it "returns parsed MembershipsLevelListResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/membershipsLevels", 200, %({
        "kind":"youtube#membershipsLevelListResponse","etag":"ml_etag",
        "items":[{
          "kind":"youtube#membershipsLevel","etag":"ml_e","id":"level1",
          "snippet":{"creatorChannelId":"UC123","levelDetails":{"displayName":"Bronze"}}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_memberships_levels("snippet")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("level1")
        items[0].snippet.not_nil!.level_details.not_nil!.display_name.should eq("Bronze")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Super Chat Events
  # ============================================================

  describe "#list_super_chat_events" do
    it "returns parsed SuperChatEventListResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/superChatEvents", 200, %({
        "kind":"youtube#superChatEventListResponse","etag":"sc_etag",
        "pageInfo":{"totalResults":1,"resultsPerPage":5},
        "items":[{
          "kind":"youtube#superChatEvent","etag":"sc_e","id":"sc1",
          "snippet":{"channelId":"UC123","amountMicros":5000000,"currency":"USD","commentText":"Awesome!"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_super_chat_events("snippet")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.amount_micros.should eq(5000000)
        items[0].snippet.not_nil!.currency.should eq("USD")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Video Abuse Report Reasons
  # ============================================================

  describe "#list_video_abuse_report_reasons" do
    it "returns parsed ListVideoAbuseReportReasonResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videoAbuseReportReasons", 200, %({
        "kind":"youtube#videoAbuseReportReasonListResponse","etag":"var_etag",
        "items":[{
          "kind":"youtube#videoAbuseReportReason","etag":"var_e","id":"reason1",
          "snippet":{"label":"Spam or misleading"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_video_abuse_report_reasons("snippet")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].snippet.not_nil!.label.should eq("Spam or misleading")
      ensure
        mock.close
      end
    end
  end

  describe "#report_video_abuse" do
    it "completes without error" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos/reportAbuse", 204, "")
      begin
        service = create_test_service(mock)
        report = Google::Apis::YoutubeV3::VideoAbuseReport.from_json(%({"videoId":"vid1","reasonId":"reason1"}))
        service.report_video_abuse(report)
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Abuse Reports
  # ============================================================

  describe "#insert_abuse_report" do
    it "returns JSON::Any" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/abuseReports", 200, %({"kind":"youtube#abuseReport","id":"ar1"}))
      begin
        service = create_test_service(mock)
        report = JSON.parse(%({"abuseTypes":["spam"],"subject":{"videoId":"vid1"}}))
        result = service.insert_abuse_report("snippet", report)
        result["id"].as_s.should eq("ar1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Video Trainability
  # ============================================================

  describe "#get_video_trainability" do
    it "returns parsed VideoTrainability" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos/getTrainability", 200, %({
        "kind":"youtube#videoTrainability","etag":"vt_etag","id":"vid1"
      }))
      begin
        service = create_test_service(mock)
        result = service.get_video_trainability(id: "vid1")
        result.id.should eq("vid1")
        result.kind.should eq("youtube#videoTrainability")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Third Party Links
  # ============================================================

  describe "#list_third_party_links" do
    it "returns parsed ThirdPartyLinkListResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/thirdPartyLinks", 200, %({
        "kind":"youtube#thirdPartyLinkListResponse","etag":"tpl_etag",
        "items":[{
          "kind":"youtube#thirdPartyLink","etag":"tpl_e",
          "linkingToken":"token123",
          "snippet":{"type":"channelToStoreLink"},
          "status":{"linkStatus":"active"}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_third_party_links("snippet,status")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].linking_token.should eq("token123")
        items[0].status.not_nil!.link_status.should eq("active")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_third_party_link" do
    it "returns parsed ThirdPartyLink on insert" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/thirdPartyLinks", 200, %({
        "kind":"youtube#thirdPartyLink","linkingToken":"token_new",
        "snippet":{"type":"channelToStoreLink"}
      }))
      begin
        service = create_test_service(mock)
        link = Google::Apis::YoutubeV3::ThirdPartyLink.from_json(%({"snippet":{"type":"channelToStoreLink"}}))
        result = service.insert_third_party_link("snippet", link)
        result.linking_token.should eq("token_new")
      ensure
        mock.close
      end
    end
  end

  describe "#update_third_party_link" do
    it "returns parsed ThirdPartyLink on update" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/thirdPartyLinks", 200, %({
        "kind":"youtube#thirdPartyLink","linkingToken":"token123",
        "status":{"linkStatus":"disabled"}
      }))
      begin
        service = create_test_service(mock)
        link = Google::Apis::YoutubeV3::ThirdPartyLink.from_json(%({"linkingToken":"token123","status":{"linkStatus":"disabled"}}))
        result = service.update_third_party_link("snippet,status", link)
        result.status.not_nil!.link_status.should eq("disabled")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_third_party_link" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/thirdPartyLinks", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_third_party_link("token123", "channelToStoreLink")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Playlist Images
  # ============================================================

  describe "#list_playlist_images" do
    it "returns parsed PlaylistImageListResponse" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlistImages", 200, %({
        "kind":"youtube#playlistImageListResponse",
        "items":[{
          "kind":"youtube#playlistImage","id":"pimg1",
          "snippet":{"playlistId":"PL123","height":720,"width":1280}
        }]
      }))
      begin
        service = create_test_service(mock)
        result = service.list_playlist_images(part: "snippet", parent: "PL123")
        items = result.items.not_nil!
        items.size.should eq(1)
        items[0].id.should eq("pimg1")
        items[0].snippet.not_nil!.playlist_id.should eq("PL123")
      ensure
        mock.close
      end
    end
  end

  describe "#insert_playlist_image (no upload)" do
    it "returns parsed PlaylistImage" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlistImages", 200, %({
        "kind":"youtube#playlistImage","id":"pimg_new",
        "snippet":{"playlistId":"PL123"}
      }))
      begin
        service = create_test_service(mock)
        img = Google::Apis::YoutubeV3::PlaylistImage.from_json(%({"snippet":{"playlistId":"PL123"}}))
        result = service.insert_playlist_image(playlist_image_object: img, part: "snippet")
        result.id.should eq("pimg_new")
      ensure
        mock.close
      end
    end
  end

  describe "#delete_playlist_image" do
    it "completes without error on 204" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlistImages", 204, "")
      begin
        service = create_test_service(mock)
        service.delete_playlist_image(id: "pimg1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Cuepoint
  # ============================================================

  describe "#insert_live_broadcast_cuepoint" do
    it "returns parsed Cuepoint" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/liveBroadcasts/cuepoint", 200, %({
        "cueType":"cueTypeAd","durationSecs":30,"etag":"cp_etag","id":"cp1"
      }))
      begin
        service = create_test_service(mock)
        cp = Google::Apis::YoutubeV3::Cuepoint.from_json(%({"cueType":"cueTypeAd","durationSecs":30}))
        result = service.insert_live_broadcast_cuepoint(cuepoint_object: cp, id: "lb1")
        result.cue_type.should eq("cueTypeAd")
        result.duration_secs.should eq(30)
        result.id.should eq("cp1")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Channel Banner
  # ============================================================

  describe "#insert_channel_banner (no upload)" do
    it "returns parsed ChannelBannerResource" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/channelBanners/insert", 200, %({
        "kind":"youtube#channelBannerResource","etag":"cb_etag",
        "url":"https://example.com/banner.jpg"
      }))
      begin
        service = create_test_service(mock)
        result = service.insert_channel_banner(channel_id: "UC123")
        result.url.should eq("https://example.com/banner.jpg")
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Test Item (internal)
  # ============================================================

  describe "#insert_test" do
    it "returns parsed TestItem" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/tests", 200, %({
        "etag":"ti_etag","id":"test1","featuredPart":true,"gaia":12345
      }))
      begin
        service = create_test_service(mock)
        result = service.insert_test("snippet")
        result.id.should eq("test1")
        result.featured_part.should be_true
        result.gaia.should eq(12345)
      ensure
        mock.close
      end
    end
  end

  # ============================================================
  # Error handling
  # ============================================================

  describe "error handling" do
    it "raises AuthorizationError on 401" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos", 401, %({"error":{"message":"Unauthorized","code":401}}))
      begin
        service = create_test_service(mock)
        expect_raises(Google::Apis::AuthorizationError) do
          service.list_videos("snippet", id: "vid1")
        end
      ensure
        mock.close
      end
    end

    it "raises RateLimitError on 429" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos", 429, %({"error":{"message":"Too Many Requests","code":429}}))
      begin
        service = create_test_service(mock)
        expect_raises(Google::Apis::RateLimitError) do
          service.list_videos("snippet", id: "vid1")
        end
      ensure
        mock.close
      end
    end

    it "raises ClientError on 400" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/search", 400, %({"error":{"message":"Bad Request","code":400}}))
      begin
        service = create_test_service(mock)
        expect_raises(Google::Apis::ClientError) do
          service.list_searches("snippet", q: "test")
        end
      ensure
        mock.close
      end
    end

    it "raises ClientError on 403" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/channels", 403, %({"error":{"message":"Forbidden","code":403}}))
      begin
        service = create_test_service(mock)
        expect_raises(Google::Apis::ClientError) do
          service.list_channels("snippet", id: "UC123")
        end
      ensure
        mock.close
      end
    end

    it "raises ServerError on 500" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/playlists", 500, %({"error":{"message":"Internal Server Error","code":500}}))
      begin
        service = create_test_service(mock)
        expect_raises(Google::Apis::ServerError) do
          service.list_playlists("snippet", channel_id: "UC123")
        end
      ensure
        mock.close
      end
    end

    it "raises ServerError on 503" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/subscriptions", 503, %({"error":{"message":"Service Unavailable","code":503}}))
      begin
        service = create_test_service(mock)
        expect_raises(Google::Apis::ServerError) do
          service.list_subscriptions("snippet", channel_id: "UC123")
        end
      ensure
        mock.close
      end
    end

    it "raises ClientError on 404 for delete" do
      mock = MockAPIServer.new
      mock.register("/youtube/v3/videos", 404, %({"error":{"message":"Not Found","code":404}}))
      begin
        service = create_test_service(mock)
        expect_raises(Google::Apis::ClientError) do
          service.delete_video("nonexistent")
        end
      ensure
        mock.close
      end
    end
  end
end
