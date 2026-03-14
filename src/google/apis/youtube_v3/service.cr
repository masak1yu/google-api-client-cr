require "../core/base_service"
require "./classes"

module Google
  module Apis
    module YoutubeV3
      class YouTubeService < Google::Apis::Core::BaseService
        def initialize
          super("www.googleapis.com", "youtube/v3/")
        end

        # Set OAuth2 client and apply access token
        def authorize(oauth_client : Google::Auth::OAuth2Client)
          self.access_token = oauth_client.valid_token
        end

        # ============================================================
        # Search
        # ============================================================

        def list_searches(part : String,
                          channel_id : String? = nil,
                          channel_type : String? = nil,
                          event_type : String? = nil,
                          for_content_owner : Bool? = nil,
                          for_developer : Bool? = nil,
                          for_mine : Bool? = nil,
                          location : String? = nil,
                          location_radius : String? = nil,
                          max_results : Int32? = nil,
                          on_behalf_of_content_owner : String? = nil,
                          order : String? = nil,
                          page_token : String? = nil,
                          published_after : String? = nil,
                          published_before : String? = nil,
                          q : String? = nil,
                          region_code : String? = nil,
                          relevance_language : String? = nil,
                          safe_search : String? = nil,
                          topic_id : String? = nil,
                          type : String? = nil,
                          video_caption : String? = nil,
                          video_category_id : String? = nil,
                          video_definition : String? = nil,
                          video_dimension : String? = nil,
                          video_duration : String? = nil,
                          video_embeddable : String? = nil,
                          video_license : String? = nil,
                          video_paid_product_placement : String? = nil,
                          video_syndicated : String? = nil,
                          video_type : String? = nil,
                          fields : String? = nil,
                          quota_user : String? = nil) : SearchListsResponse
          query = {} of String => String?
          query["part"] = part
          query["channelId"] = channel_id
          query["channelType"] = channel_type
          query["eventType"] = event_type
          query["forContentOwner"] = for_content_owner.to_s if for_content_owner
          query["forDeveloper"] = for_developer.to_s if for_developer
          query["forMine"] = for_mine.to_s if for_mine
          query["location"] = location
          query["locationRadius"] = location_radius
          query["maxResults"] = max_results.to_s if max_results
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["order"] = order
          query["pageToken"] = page_token
          query["publishedAfter"] = published_after
          query["publishedBefore"] = published_before
          query["q"] = q
          query["regionCode"] = region_code
          query["relevanceLanguage"] = relevance_language
          query["safeSearch"] = safe_search
          query["topicId"] = topic_id
          query["type"] = type
          query["videoCaption"] = video_caption
          query["videoCategoryId"] = video_category_id
          query["videoDefinition"] = video_definition
          query["videoDimension"] = video_dimension
          query["videoDuration"] = video_duration
          query["videoEmbeddable"] = video_embeddable
          query["videoLicense"] = video_license
          query["videoPaidProductPlacement"] = video_paid_product_placement
          query["videoSyndicated"] = video_syndicated
          query["videoType"] = video_type
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(SearchListsResponse, "GET", "search", query)
        end

        # ============================================================
        # Videos
        # ============================================================

        def list_videos(part : String,
                        chart : String? = nil,
                        hl : String? = nil,
                        id : String? = nil,
                        locale : String? = nil,
                        max_height : Int32? = nil,
                        max_results : Int32? = nil,
                        max_width : Int32? = nil,
                        my_rating : String? = nil,
                        on_behalf_of_content_owner : String? = nil,
                        page_token : String? = nil,
                        region_code : String? = nil,
                        video_category_id : String? = nil,
                        fields : String? = nil,
                        quota_user : String? = nil) : ListVideosResponse
          query = {} of String => String?
          query["part"] = part
          query["chart"] = chart
          query["hl"] = hl
          query["id"] = id
          query["locale"] = locale
          query["maxHeight"] = max_height.to_s if max_height
          query["maxResults"] = max_results.to_s if max_results
          query["maxWidth"] = max_width.to_s if max_width
          query["myRating"] = my_rating
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["pageToken"] = page_token
          query["regionCode"] = region_code
          query["videoCategoryId"] = video_category_id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListVideosResponse, "GET", "videos", query)
        end

        def delete_video(id : String,
                         on_behalf_of_content_owner : String? = nil,
                         fields : String? = nil,
                         quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "videos", query)
        end

        def rate_video(id : String,
                       rating : String,
                       fields : String? = nil,
                       quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["rating"] = rating
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("POST", "videos/rate", query)
        end

        def insert_video(part : String,
                         video_object : Video,
                         auto_levels : Bool? = nil,
                         notify_subscribers : Bool? = nil,
                         on_behalf_of_content_owner : String? = nil,
                         on_behalf_of_content_owner_channel : String? = nil,
                         stabilize : Bool? = nil,
                         fields : String? = nil,
                         quota_user : String? = nil) : Video
          query = {} of String => String?
          query["part"] = part
          query["autoLevels"] = auto_levels.to_s if auto_levels
          query["notifySubscribers"] = notify_subscribers.to_s unless notify_subscribers.nil?
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["stabilize"] = stabilize.to_s if stabilize
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Video, "POST", "videos", query, video_object.to_json)
        end

        def update_video(part : String,
                         video_object : Video,
                         on_behalf_of_content_owner : String? = nil,
                         fields : String? = nil,
                         quota_user : String? = nil) : Video
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Video, "PUT", "videos", query, video_object.to_json)
        end

        def get_video_rating(id : String,
                             on_behalf_of_content_owner : String? = nil,
                             fields : String? = nil,
                             quota_user : String? = nil) : JSON::Any
          query = {} of String => String?
          query["id"] = id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          response = execute("GET", "videos/getRating", query)
          JSON.parse(response.body)
        end

        # ============================================================
        # Channels
        # ============================================================

        def list_channels(part : String,
                          category_id : String? = nil,
                          for_handle : String? = nil,
                          for_username : String? = nil,
                          hl : String? = nil,
                          id : String? = nil,
                          managed_by_me : Bool? = nil,
                          max_results : Int32? = nil,
                          mine : Bool? = nil,
                          my_subscribers : Bool? = nil,
                          on_behalf_of_content_owner : String? = nil,
                          page_token : String? = nil,
                          fields : String? = nil,
                          quota_user : String? = nil) : ListChannelsResponse
          query = {} of String => String?
          query["part"] = part
          query["categoryId"] = category_id
          query["forHandle"] = for_handle
          query["forUsername"] = for_username
          query["hl"] = hl
          query["id"] = id
          query["managedByMe"] = managed_by_me.to_s if managed_by_me
          query["maxResults"] = max_results.to_s if max_results
          query["mine"] = mine.to_s if mine
          query["mySubscribers"] = my_subscribers.to_s if my_subscribers
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["pageToken"] = page_token
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListChannelsResponse, "GET", "channels", query)
        end

        def update_channel(part : String,
                           channel_object : Channel,
                           on_behalf_of_content_owner : String? = nil,
                           fields : String? = nil,
                           quota_user : String? = nil) : Channel
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Channel, "PUT", "channels", query, channel_object.to_json)
        end

        # ============================================================
        # Playlists
        # ============================================================

        def list_playlists(part : String,
                           channel_id : String? = nil,
                           hl : String? = nil,
                           id : String? = nil,
                           max_results : Int32? = nil,
                           mine : Bool? = nil,
                           on_behalf_of_content_owner : String? = nil,
                           on_behalf_of_content_owner_channel : String? = nil,
                           page_token : String? = nil,
                           fields : String? = nil,
                           quota_user : String? = nil) : ListPlaylistsResponse
          query = {} of String => String?
          query["part"] = part
          query["channelId"] = channel_id
          query["hl"] = hl
          query["id"] = id
          query["maxResults"] = max_results.to_s if max_results
          query["mine"] = mine.to_s if mine
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["pageToken"] = page_token
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListPlaylistsResponse, "GET", "playlists", query)
        end

        def insert_playlist(part : String,
                            playlist_object : Playlist,
                            on_behalf_of_content_owner : String? = nil,
                            on_behalf_of_content_owner_channel : String? = nil,
                            fields : String? = nil,
                            quota_user : String? = nil) : Playlist
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Playlist, "POST", "playlists", query, playlist_object.to_json)
        end

        def update_playlist(part : String,
                            playlist_object : Playlist,
                            on_behalf_of_content_owner : String? = nil,
                            fields : String? = nil,
                            quota_user : String? = nil) : Playlist
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Playlist, "PUT", "playlists", query, playlist_object.to_json)
        end

        def delete_playlist(id : String,
                            on_behalf_of_content_owner : String? = nil,
                            fields : String? = nil,
                            quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "playlists", query)
        end

        # ============================================================
        # PlaylistItems
        # ============================================================

        def list_playlist_items(part : String,
                                id : String? = nil,
                                max_results : Int32? = nil,
                                on_behalf_of_content_owner : String? = nil,
                                page_token : String? = nil,
                                playlist_id : String? = nil,
                                video_id : String? = nil,
                                fields : String? = nil,
                                quota_user : String? = nil) : ListPlaylistItemsResponse
          query = {} of String => String?
          query["part"] = part
          query["id"] = id
          query["maxResults"] = max_results.to_s if max_results
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["pageToken"] = page_token
          query["playlistId"] = playlist_id
          query["videoId"] = video_id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListPlaylistItemsResponse, "GET", "playlistItems", query)
        end

        def insert_playlist_item(part : String,
                                 playlist_item_object : PlaylistItem,
                                 on_behalf_of_content_owner : String? = nil,
                                 fields : String? = nil,
                                 quota_user : String? = nil) : PlaylistItem
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(PlaylistItem, "POST", "playlistItems", query, playlist_item_object.to_json)
        end

        def update_playlist_item(part : String,
                                 playlist_item_object : PlaylistItem,
                                 on_behalf_of_content_owner : String? = nil,
                                 fields : String? = nil,
                                 quota_user : String? = nil) : PlaylistItem
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(PlaylistItem, "PUT", "playlistItems", query, playlist_item_object.to_json)
        end

        def delete_playlist_item(id : String,
                                 on_behalf_of_content_owner : String? = nil,
                                 fields : String? = nil,
                                 quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "playlistItems", query)
        end

        # ============================================================
        # Comments
        # ============================================================

        def list_comments(part : String,
                          id : String? = nil,
                          max_results : Int32? = nil,
                          page_token : String? = nil,
                          parent_id : String? = nil,
                          text_format : String? = nil,
                          fields : String? = nil,
                          quota_user : String? = nil) : ListCommentsResponse
          query = {} of String => String?
          query["part"] = part
          query["id"] = id
          query["maxResults"] = max_results.to_s if max_results
          query["pageToken"] = page_token
          query["parentId"] = parent_id
          query["textFormat"] = text_format
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListCommentsResponse, "GET", "comments", query)
        end

        def insert_comment(part : String,
                           comment_object : Comment,
                           fields : String? = nil,
                           quota_user : String? = nil) : Comment
          query = {} of String => String?
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Comment, "POST", "comments", query, comment_object.to_json)
        end

        def update_comment(part : String,
                           comment_object : Comment,
                           fields : String? = nil,
                           quota_user : String? = nil) : Comment
          query = {} of String => String?
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Comment, "PUT", "comments", query, comment_object.to_json)
        end

        def mark_comment_as_spam(id : String,
                                 fields : String? = nil,
                                 quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("POST", "comments/markAsSpam", query)
        end

        def set_comment_moderation_status(id : String,
                                          moderation_status : String,
                                          ban_author : Bool? = nil,
                                          fields : String? = nil,
                                          quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["moderationStatus"] = moderation_status
          query["banAuthor"] = ban_author.to_s if ban_author
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("POST", "comments/setModerationStatus", query)
        end

        def delete_comment(id : String,
                           fields : String? = nil,
                           quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "comments", query)
        end

        # ============================================================
        # CommentThreads
        # ============================================================

        def insert_comment_thread(part : String,
                                  comment_thread_object : CommentThread,
                                  fields : String? = nil,
                                  quota_user : String? = nil) : CommentThread
          query = {} of String => String?
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(CommentThread, "POST", "commentThreads", query, comment_thread_object.to_json)
        end

        def list_comment_threads(part : String,
                                 all_threads_related_to_channel_id : String? = nil,
                                 channel_id : String? = nil,
                                 id : String? = nil,
                                 max_results : Int32? = nil,
                                 moderation_status : String? = nil,
                                 order : String? = nil,
                                 page_token : String? = nil,
                                 search_terms : String? = nil,
                                 text_format : String? = nil,
                                 video_id : String? = nil,
                                 fields : String? = nil,
                                 quota_user : String? = nil) : ListCommentThreadsResponse
          query = {} of String => String?
          query["part"] = part
          query["allThreadsRelatedToChannelId"] = all_threads_related_to_channel_id
          query["channelId"] = channel_id
          query["id"] = id
          query["maxResults"] = max_results.to_s if max_results
          query["moderationStatus"] = moderation_status
          query["order"] = order
          query["pageToken"] = page_token
          query["searchTerms"] = search_terms
          query["textFormat"] = text_format
          query["videoId"] = video_id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListCommentThreadsResponse, "GET", "commentThreads", query)
        end

        # ============================================================
        # Subscriptions
        # ============================================================

        def list_subscriptions(part : String,
                               channel_id : String? = nil,
                               for_channel_id : String? = nil,
                               id : String? = nil,
                               max_results : Int32? = nil,
                               mine : Bool? = nil,
                               my_recent_subscribers : Bool? = nil,
                               my_subscribers : Bool? = nil,
                               on_behalf_of_content_owner : String? = nil,
                               on_behalf_of_content_owner_channel : String? = nil,
                               order : String? = nil,
                               page_token : String? = nil,
                               fields : String? = nil,
                               quota_user : String? = nil) : ListSubscriptionsResponse
          query = {} of String => String?
          query["part"] = part
          query["channelId"] = channel_id
          query["forChannelId"] = for_channel_id
          query["id"] = id
          query["maxResults"] = max_results.to_s if max_results
          query["mine"] = mine.to_s if mine
          query["myRecentSubscribers"] = my_recent_subscribers.to_s if my_recent_subscribers
          query["mySubscribers"] = my_subscribers.to_s if my_subscribers
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["order"] = order
          query["pageToken"] = page_token
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListSubscriptionsResponse, "GET", "subscriptions", query)
        end

        def insert_subscription(part : String,
                                subscription_object : Subscription,
                                fields : String? = nil,
                                quota_user : String? = nil) : Subscription
          query = {} of String => String?
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Subscription, "POST", "subscriptions", query, subscription_object.to_json)
        end

        def delete_subscription(id : String,
                                fields : String? = nil,
                                quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "subscriptions", query)
        end

        # ============================================================
        # Video Categories
        # ============================================================

        def list_video_categories(part : String,
                                  hl : String? = nil,
                                  id : String? = nil,
                                  region_code : String? = nil,
                                  fields : String? = nil,
                                  quota_user : String? = nil) : ListVideoCategoriesResponse
          query = {} of String => String?
          query["part"] = part
          query["hl"] = hl
          query["id"] = id
          query["regionCode"] = region_code
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListVideoCategoriesResponse, "GET", "videoCategories", query)
        end

        # ============================================================
        # I18n
        # ============================================================

        def list_i18n_languages(part : String,
                                hl : String? = nil,
                                fields : String? = nil,
                                quota_user : String? = nil) : ListI18nLanguagesResponse
          query = {} of String => String?
          query["part"] = part
          query["hl"] = hl
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListI18nLanguagesResponse, "GET", "i18nLanguages", query)
        end

        # ============================================================
        # Captions
        # ============================================================

        def list_captions(part : String,
                          video_id : String,
                          id : String? = nil,
                          on_behalf_of : String? = nil,
                          on_behalf_of_content_owner : String? = nil,
                          fields : String? = nil,
                          quota_user : String? = nil) : ListCaptionsResponse
          query = {} of String => String?
          query["part"] = part
          query["videoId"] = video_id
          query["id"] = id
          query["onBehalfOf"] = on_behalf_of
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListCaptionsResponse, "GET", "captions", query)
        end

        def insert_caption(part : String,
                           caption_object : Caption,
                           on_behalf_of : String? = nil,
                           on_behalf_of_content_owner : String? = nil,
                           sync : Bool? = nil,
                           fields : String? = nil,
                           quota_user : String? = nil) : Caption
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOf"] = on_behalf_of
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["sync"] = sync.to_s if sync
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Caption, "POST", "captions", query, caption_object.to_json)
        end

        def update_caption(part : String,
                           caption_object : Caption,
                           on_behalf_of : String? = nil,
                           on_behalf_of_content_owner : String? = nil,
                           sync : Bool? = nil,
                           fields : String? = nil,
                           quota_user : String? = nil) : Caption
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOf"] = on_behalf_of
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["sync"] = sync.to_s if sync
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Caption, "PUT", "captions", query, caption_object.to_json)
        end

        def delete_caption(id : String,
                           on_behalf_of : String? = nil,
                           on_behalf_of_content_owner : String? = nil,
                           fields : String? = nil,
                           quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["onBehalfOf"] = on_behalf_of
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "captions", query)
        end

        # ============================================================
        # Channel Sections
        # ============================================================

        def list_channel_sections(part : String,
                                  channel_id : String? = nil,
                                  hl : String? = nil,
                                  id : String? = nil,
                                  mine : Bool? = nil,
                                  on_behalf_of_content_owner : String? = nil,
                                  fields : String? = nil,
                                  quota_user : String? = nil) : ListChannelSectionsResponse
          query = {} of String => String?
          query["part"] = part
          query["channelId"] = channel_id
          query["hl"] = hl
          query["id"] = id
          query["mine"] = mine.to_s if mine
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListChannelSectionsResponse, "GET", "channelSections", query)
        end

        def insert_channel_section(part : String,
                                   channel_section_object : ChannelSection,
                                   on_behalf_of_content_owner : String? = nil,
                                   on_behalf_of_content_owner_channel : String? = nil,
                                   fields : String? = nil,
                                   quota_user : String? = nil) : ChannelSection
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ChannelSection, "POST", "channelSections", query, channel_section_object.to_json)
        end

        def update_channel_section(part : String,
                                   channel_section_object : ChannelSection,
                                   on_behalf_of_content_owner : String? = nil,
                                   fields : String? = nil,
                                   quota_user : String? = nil) : ChannelSection
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ChannelSection, "PUT", "channelSections", query, channel_section_object.to_json)
        end

        def delete_channel_section(id : String,
                                   on_behalf_of_content_owner : String? = nil,
                                   fields : String? = nil,
                                   quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "channelSections", query)
        end

        # ============================================================
        # Activities
        # ============================================================

        def list_activities(part : String,
                            channel_id : String? = nil,
                            home : Bool? = nil,
                            max_results : Int32? = nil,
                            mine : Bool? = nil,
                            page_token : String? = nil,
                            published_after : String? = nil,
                            published_before : String? = nil,
                            region_code : String? = nil,
                            fields : String? = nil,
                            quota_user : String? = nil) : ListActivitiesResponse
          query = {} of String => String?
          query["part"] = part
          query["channelId"] = channel_id
          query["home"] = home.to_s if home
          query["maxResults"] = max_results.to_s if max_results
          query["mine"] = mine.to_s if mine
          query["pageToken"] = page_token
          query["publishedAfter"] = published_after
          query["publishedBefore"] = published_before
          query["regionCode"] = region_code
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListActivitiesResponse, "GET", "activities", query)
        end

        # ============================================================
        # Live Broadcasts
        # ============================================================

        def list_live_broadcasts(part : String,
                                 broadcast_status : String? = nil,
                                 broadcast_type : String? = nil,
                                 id : String? = nil,
                                 max_results : Int32? = nil,
                                 mine : Bool? = nil,
                                 on_behalf_of_content_owner : String? = nil,
                                 on_behalf_of_content_owner_channel : String? = nil,
                                 page_token : String? = nil,
                                 fields : String? = nil,
                                 quota_user : String? = nil) : ListLiveBroadcastsResponse
          query = {} of String => String?
          query["part"] = part
          query["broadcastStatus"] = broadcast_status
          query["broadcastType"] = broadcast_type
          query["id"] = id
          query["maxResults"] = max_results.to_s if max_results
          query["mine"] = mine.to_s if mine
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["pageToken"] = page_token
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListLiveBroadcastsResponse, "GET", "liveBroadcasts", query)
        end

        def insert_live_broadcast(part : String,
                                  live_broadcast_object : LiveBroadcast,
                                  on_behalf_of_content_owner : String? = nil,
                                  on_behalf_of_content_owner_channel : String? = nil,
                                  fields : String? = nil,
                                  quota_user : String? = nil) : LiveBroadcast
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveBroadcast, "POST", "liveBroadcasts", query, live_broadcast_object.to_json)
        end

        def update_live_broadcast(part : String,
                                  live_broadcast_object : LiveBroadcast,
                                  on_behalf_of_content_owner : String? = nil,
                                  on_behalf_of_content_owner_channel : String? = nil,
                                  fields : String? = nil,
                                  quota_user : String? = nil) : LiveBroadcast
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveBroadcast, "PUT", "liveBroadcasts", query, live_broadcast_object.to_json)
        end

        def delete_live_broadcast(id : String,
                                  on_behalf_of_content_owner : String? = nil,
                                  on_behalf_of_content_owner_channel : String? = nil,
                                  fields : String? = nil,
                                  quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "liveBroadcasts", query)
        end

        def bind_live_broadcast(id : String,
                                part : String,
                                on_behalf_of_content_owner : String? = nil,
                                on_behalf_of_content_owner_channel : String? = nil,
                                stream_id : String? = nil,
                                fields : String? = nil,
                                quota_user : String? = nil) : LiveBroadcast
          query = {} of String => String?
          query["id"] = id
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["streamId"] = stream_id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveBroadcast, "POST", "liveBroadcasts/bind", query)
        end

        def transition_live_broadcast(broadcast_status : String,
                                      id : String,
                                      part : String,
                                      on_behalf_of_content_owner : String? = nil,
                                      on_behalf_of_content_owner_channel : String? = nil,
                                      fields : String? = nil,
                                      quota_user : String? = nil) : LiveBroadcast
          query = {} of String => String?
          query["broadcastStatus"] = broadcast_status
          query["id"] = id
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveBroadcast, "POST", "liveBroadcasts/transition", query)
        end

        # ============================================================
        # Live Streams
        # ============================================================

        def list_live_streams(part : String,
                              id : String? = nil,
                              max_results : Int32? = nil,
                              mine : Bool? = nil,
                              on_behalf_of_content_owner : String? = nil,
                              on_behalf_of_content_owner_channel : String? = nil,
                              page_token : String? = nil,
                              fields : String? = nil,
                              quota_user : String? = nil) : ListLiveStreamsResponse
          query = {} of String => String?
          query["part"] = part
          query["id"] = id
          query["maxResults"] = max_results.to_s if max_results
          query["mine"] = mine.to_s if mine
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["pageToken"] = page_token
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListLiveStreamsResponse, "GET", "liveStreams", query)
        end

        def insert_live_stream(part : String,
                               live_stream_object : LiveStream,
                               on_behalf_of_content_owner : String? = nil,
                               on_behalf_of_content_owner_channel : String? = nil,
                               fields : String? = nil,
                               quota_user : String? = nil) : LiveStream
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveStream, "POST", "liveStreams", query, live_stream_object.to_json)
        end

        def update_live_stream(part : String,
                               live_stream_object : LiveStream,
                               on_behalf_of_content_owner : String? = nil,
                               on_behalf_of_content_owner_channel : String? = nil,
                               fields : String? = nil,
                               quota_user : String? = nil) : LiveStream
          query = {} of String => String?
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveStream, "PUT", "liveStreams", query, live_stream_object.to_json)
        end

        def delete_live_stream(id : String,
                               on_behalf_of_content_owner : String? = nil,
                               on_behalf_of_content_owner_channel : String? = nil,
                               fields : String? = nil,
                               quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "liveStreams", query)
        end

        # ============================================================
        # Live Chat Messages
        # ============================================================

        def list_live_chat_messages(live_chat_id : String,
                                    part : String,
                                    hl : String? = nil,
                                    max_results : Int32? = nil,
                                    page_token : String? = nil,
                                    profile_image_size : Int32? = nil,
                                    fields : String? = nil,
                                    quota_user : String? = nil) : LiveChatMessageListResponse
          query = {} of String => String?
          query["liveChatId"] = live_chat_id
          query["part"] = part
          query["hl"] = hl
          query["maxResults"] = max_results.to_s if max_results
          query["pageToken"] = page_token
          query["profileImageSize"] = profile_image_size.to_s if profile_image_size
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveChatMessageListResponse, "GET", "liveChat/messages", query)
        end

        def insert_live_chat_message(part : String,
                                     live_chat_message_object : LiveChatMessage,
                                     fields : String? = nil,
                                     quota_user : String? = nil) : LiveChatMessage
          query = {} of String => String?
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveChatMessage, "POST", "liveChat/messages", query, live_chat_message_object.to_json)
        end

        def delete_live_chat_message(id : String,
                                     fields : String? = nil,
                                     quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "liveChat/messages", query)
        end

        # ============================================================
        # Live Chat Moderators
        # ============================================================

        def list_live_chat_moderators(live_chat_id : String,
                                      part : String,
                                      max_results : Int32? = nil,
                                      page_token : String? = nil,
                                      fields : String? = nil,
                                      quota_user : String? = nil) : LiveChatModeratorListResponse
          query = {} of String => String?
          query["liveChatId"] = live_chat_id
          query["part"] = part
          query["maxResults"] = max_results.to_s if max_results
          query["pageToken"] = page_token
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveChatModeratorListResponse, "GET", "liveChat/moderators", query)
        end

        def insert_live_chat_moderator(part : String,
                                       live_chat_moderator_object : LiveChatModerator,
                                       fields : String? = nil,
                                       quota_user : String? = nil) : LiveChatModerator
          query = {} of String => String?
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveChatModerator, "POST", "liveChat/moderators", query, live_chat_moderator_object.to_json)
        end

        def delete_live_chat_moderator(id : String,
                                       fields : String? = nil,
                                       quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "liveChat/moderators", query)
        end

        # ============================================================
        # Live Chat Bans
        # ============================================================

        def insert_live_chat_ban(part : String,
                                 live_chat_ban_object : LiveChatBan,
                                 fields : String? = nil,
                                 quota_user : String? = nil) : LiveChatBan
          query = {} of String => String?
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveChatBan, "POST", "liveChat/bans", query, live_chat_ban_object.to_json)
        end

        def delete_live_chat_ban(id : String,
                                 fields : String? = nil,
                                 quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "liveChat/bans", query)
        end

        # ============================================================
        # Watermarks
        # ============================================================

        def set_watermark(channel_id : String,
                          invideo_branding_object : InvideoBranding,
                          on_behalf_of_content_owner : String? = nil,
                          fields : String? = nil,
                          quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["channelId"] = channel_id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          response = execute("POST", "watermarks/set", query, invideo_branding_object.to_json)
          handle_error(response)
        end

        def unset_watermark(channel_id : String,
                            on_behalf_of_content_owner : String? = nil,
                            fields : String? = nil,
                            quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["channelId"] = channel_id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("POST", "watermarks/unset", query)
        end

        # ============================================================
        # Thumbnails
        # ============================================================

        def set_thumbnail(video_id : String,
                          on_behalf_of_content_owner : String? = nil,
                          fields : String? = nil,
                          quota_user : String? = nil) : SetThumbnailResponse
          query = {} of String => String?
          query["videoId"] = video_id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(SetThumbnailResponse, "POST", "thumbnails/set", query)
        end

        # ============================================================
        # Members / Memberships
        # ============================================================

        def list_members(part : String,
                         filter_by_member_channel_id : String? = nil,
                         has_access_to_level : String? = nil,
                         max_results : Int32? = nil,
                         mode : String? = nil,
                         page_token : String? = nil,
                         fields : String? = nil,
                         quota_user : String? = nil) : MemberListResponse
          query = {} of String => String?
          query["part"] = part
          query["filterByMemberChannelId"] = filter_by_member_channel_id
          query["hasAccessToLevel"] = has_access_to_level
          query["maxResults"] = max_results.to_s if max_results
          query["mode"] = mode
          query["pageToken"] = page_token
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(MemberListResponse, "GET", "members", query)
        end

        def list_memberships_levels(part : String,
                                    fields : String? = nil,
                                    quota_user : String? = nil) : MembershipsLevelListResponse
          query = {} of String => String?
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(MembershipsLevelListResponse, "GET", "membershipsLevels", query)
        end

        # ============================================================
        # Super Chat Events
        # ============================================================

        def list_super_chat_events(part : String,
                                   hl : String? = nil,
                                   max_results : Int32? = nil,
                                   page_token : String? = nil,
                                   fields : String? = nil,
                                   quota_user : String? = nil) : SuperChatEventListResponse
          query = {} of String => String?
          query["part"] = part
          query["hl"] = hl
          query["maxResults"] = max_results.to_s if max_results
          query["pageToken"] = page_token
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(SuperChatEventListResponse, "GET", "superChatEvents", query)
        end

        def list_i18n_regions(part : String,
                              hl : String? = nil,
                              fields : String? = nil,
                              quota_user : String? = nil) : ListI18nRegionsResponse
          query = {} of String => String?
          query["part"] = part
          query["hl"] = hl
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListI18nRegionsResponse, "GET", "i18nRegions", query)
        end

        # ============================================================
        # Abuse Reports
        # ============================================================

        def insert_abuse_report(part : String,
                                abuse_report_object : JSON::Any,
                                fields : String? = nil,
                                quota_user : String? = nil) : JSON::Any
          query = {} of String => String?
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          response = execute("POST", "abuseReports", query, abuse_report_object.to_json)
          handle_error(response)
          JSON.parse(response.body)
        end

        # ============================================================
        # Video Abuse Report Reasons
        # ============================================================

        def list_video_abuse_report_reasons(part : String,
                                            hl : String? = nil,
                                            fields : String? = nil,
                                            quota_user : String? = nil) : ListVideoAbuseReportReasonResponse
          query = {} of String => String?
          query["part"] = part
          query["hl"] = hl
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ListVideoAbuseReportReasonResponse, "GET", "videoAbuseReportReasons", query)
        end

        def report_video_abuse(video_abuse_report_object : VideoAbuseReport,
                               on_behalf_of_content_owner : String? = nil,
                               fields : String? = nil,
                               quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          response = execute("POST", "videos/reportAbuse", query, video_abuse_report_object.to_json)
          handle_error(response)
        end

        def get_video_trainability(id : String? = nil,
                                   fields : String? = nil,
                                   quota_user : String? = nil) : VideoTrainability
          query = {} of String => String?
          query["id"] = id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(VideoTrainability, "GET", "videos/getTrainability", query)
        end

        # ============================================================
        # Third Party Links
        # ============================================================

        def list_third_party_links(part : String,
                                   external_channel_id : String? = nil,
                                   linking_token : String? = nil,
                                   type : String? = nil,
                                   fields : String? = nil,
                                   quota_user : String? = nil) : ThirdPartyLinkListResponse
          query = {} of String => String?
          query["part"] = part
          query["externalChannelId"] = external_channel_id
          query["linkingToken"] = linking_token
          query["type"] = type
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ThirdPartyLinkListResponse, "GET", "thirdPartyLinks", query)
        end

        def insert_third_party_link(part : String,
                                    third_party_link_object : ThirdPartyLink,
                                    external_channel_id : String? = nil,
                                    fields : String? = nil,
                                    quota_user : String? = nil) : ThirdPartyLink
          query = {} of String => String?
          query["part"] = part
          query["externalChannelId"] = external_channel_id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ThirdPartyLink, "POST", "thirdPartyLinks", query, third_party_link_object.to_json)
        end

        def update_third_party_link(part : String,
                                    third_party_link_object : ThirdPartyLink,
                                    external_channel_id : String? = nil,
                                    fields : String? = nil,
                                    quota_user : String? = nil) : ThirdPartyLink
          query = {} of String => String?
          query["part"] = part
          query["externalChannelId"] = external_channel_id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(ThirdPartyLink, "PUT", "thirdPartyLinks", query, third_party_link_object.to_json)
        end

        def delete_third_party_link(linking_token : String,
                                    type : String,
                                    external_channel_id : String? = nil,
                                    part : String? = nil,
                                    fields : String? = nil,
                                    quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["linkingToken"] = linking_token
          query["type"] = type
          query["externalChannelId"] = external_channel_id
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "thirdPartyLinks", query)
        end

        # ============================================================
        # Playlist Images
        # ============================================================

        def list_playlist_images(max_results : Int32? = nil,
                                 on_behalf_of_content_owner : String? = nil,
                                 on_behalf_of_content_owner_channel : String? = nil,
                                 page_token : String? = nil,
                                 parent : String? = nil,
                                 part : String? = nil,
                                 fields : String? = nil,
                                 quota_user : String? = nil) : PlaylistImageListResponse
          query = {} of String => String?
          query["maxResults"] = max_results.to_s if max_results
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["pageToken"] = page_token
          query["parent"] = parent
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(PlaylistImageListResponse, "GET", "playlistImages", query)
        end

        def insert_playlist_image(playlist_image_object : PlaylistImage? = nil,
                                  on_behalf_of_content_owner : String? = nil,
                                  on_behalf_of_content_owner_channel : String? = nil,
                                  part : String? = nil,
                                  fields : String? = nil,
                                  quota_user : String? = nil,
                                  upload_source : String | IO | Nil = nil,
                                  content_type : String = "application/octet-stream") : PlaylistImage
          if upload_source
            query = {} of String => String?
            query["part"] = part
            query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
            query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
            query["fields"] = fields
            query["quotaUser"] = quota_user
            execute_upload(PlaylistImage, "POST", "playlistImages", query, upload_source, content_type, playlist_image_object.try &.to_json)
          else
            query = {} of String => String?
            query["part"] = part
            query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
            query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
            query["fields"] = fields
            query["quotaUser"] = quota_user
            execute_and_parse(PlaylistImage, "POST", "playlistImages", query, playlist_image_object.try &.to_json)
          end
        end

        def update_playlist_image(playlist_image_object : PlaylistImage? = nil,
                                  on_behalf_of_content_owner : String? = nil,
                                  part : String? = nil,
                                  fields : String? = nil,
                                  quota_user : String? = nil,
                                  upload_source : String | IO | Nil = nil,
                                  content_type : String = "application/octet-stream") : PlaylistImage
          if upload_source
            query = {} of String => String?
            query["part"] = part
            query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
            query["fields"] = fields
            query["quotaUser"] = quota_user
            execute_upload(PlaylistImage, "PUT", "playlistImages", query, upload_source, content_type, playlist_image_object.try &.to_json)
          else
            query = {} of String => String?
            query["part"] = part
            query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
            query["fields"] = fields
            query["quotaUser"] = quota_user
            execute_and_parse(PlaylistImage, "PUT", "playlistImages", query, playlist_image_object.try &.to_json)
          end
        end

        def delete_playlist_image(id : String? = nil,
                                  on_behalf_of_content_owner : String? = nil,
                                  fields : String? = nil,
                                  quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("DELETE", "playlistImages", query)
        end

        # ============================================================
        # Live Broadcast Cuepoint
        # ============================================================

        def insert_live_broadcast_cuepoint(cuepoint_object : Cuepoint? = nil,
                                           id : String? = nil,
                                           on_behalf_of_content_owner : String? = nil,
                                           on_behalf_of_content_owner_channel : String? = nil,
                                           part : String? = nil,
                                           fields : String? = nil,
                                           quota_user : String? = nil) : Cuepoint
          query = {} of String => String?
          query["id"] = id
          query["part"] = part
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(Cuepoint, "POST", "liveBroadcasts/cuepoint", query, cuepoint_object.try &.to_json)
        end

        # ============================================================
        # Live Chat Message (additional)
        # ============================================================

        def transition_live_chat_message(id : String? = nil,
                                         status : String? = nil,
                                         fields : String? = nil,
                                         quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["status"] = status
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("POST", "liveChat/messages/transition", query)
        end

        def stream_live_chat_messages(hl : String? = nil,
                                      live_chat_id : String? = nil,
                                      max_results : Int32? = nil,
                                      page_token : String? = nil,
                                      part : String? = nil,
                                      profile_image_size : Int32? = nil,
                                      fields : String? = nil,
                                      quota_user : String? = nil) : LiveChatMessageListResponse
          query = {} of String => String?
          query["hl"] = hl
          query["liveChatId"] = live_chat_id
          query["maxResults"] = max_results.to_s if max_results
          query["pageToken"] = page_token
          query["part"] = part
          query["profileImageSize"] = profile_image_size.to_s if profile_image_size
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(LiveChatMessageListResponse, "GET", "liveChat/messages/stream", query)
        end

        # ============================================================
        # Comment Threads (additional)
        # ============================================================

        def update_comment_thread(comment_thread_object : CommentThread,
                                  part : String? = nil,
                                  fields : String? = nil,
                                  quota_user : String? = nil) : CommentThread
          query = {} of String => String?
          query["part"] = part
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(CommentThread, "PUT", "commentThreads", query, comment_thread_object.to_json)
        end

        # ============================================================
        # Caption Download
        # ============================================================

        def download_caption(id : String,
                             on_behalf_of : String? = nil,
                             on_behalf_of_content_owner : String? = nil,
                             tfmt : String? = nil,
                             tlang : String? = nil,
                             fields : String? = nil,
                             quota_user : String? = nil,
                             download_dest : String | IO = "") : Nil
          query = {} of String => String?
          query["onBehalfOf"] = on_behalf_of
          query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
          query["tfmt"] = tfmt
          query["tlang"] = tlang
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_download("GET", "captions/#{URI.encode_path(id)}", query, download_dest)
        end

        # ============================================================
        # Channel Banner
        # ============================================================

        def insert_channel_banner(channel_banner_resource_object : ChannelBannerResource? = nil,
                                  channel_id : String? = nil,
                                  on_behalf_of_content_owner : String? = nil,
                                  on_behalf_of_content_owner_channel : String? = nil,
                                  fields : String? = nil,
                                  quota_user : String? = nil,
                                  upload_source : String | IO | Nil = nil,
                                  content_type : String = "application/octet-stream") : ChannelBannerResource
          if upload_source
            query = {} of String => String?
            query["channelId"] = channel_id
            query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
            query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
            query["fields"] = fields
            query["quotaUser"] = quota_user
            execute_upload(ChannelBannerResource, "POST", "channelBanners/insert", query, upload_source, content_type, channel_banner_resource_object.try &.to_json)
          else
            query = {} of String => String?
            query["channelId"] = channel_id
            query["onBehalfOfContentOwner"] = on_behalf_of_content_owner
            query["onBehalfOfContentOwnerChannel"] = on_behalf_of_content_owner_channel
            query["fields"] = fields
            query["quotaUser"] = quota_user
            execute_and_parse(ChannelBannerResource, "POST", "channelBanners/insert", query, channel_banner_resource_object.try &.to_json)
          end
        end

        # ============================================================
        # Test (internal)
        # ============================================================

        def insert_test(part : String,
                        test_item_object : TestItem? = nil,
                        external_channel_id : String? = nil,
                        fields : String? = nil,
                        quota_user : String? = nil) : TestItem
          query = {} of String => String?
          query["part"] = part
          query["externalChannelId"] = external_channel_id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_and_parse(TestItem, "POST", "tests", query, test_item_object.try &.to_json)
        end
      end
    end
  end
end
