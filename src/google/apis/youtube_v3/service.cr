require "../core/base_service"
require "./classes"

module Google
  module Apis
    module YoutubeV3
      class YouTubeService < Google::Apis::Core::BaseService
        # Creates a new YouTubeService client configured for the YouTube Data API v3.
        # The base URL is set to `www.googleapis.com/youtube/v3/`.
        def initialize
          super("www.googleapis.com", "youtube/v3/")
        end

        # Sets the authorization credentials using an OAuth2 client.
        # Extracts a valid access token from the client and applies it to all subsequent API requests.
        # See https://developers.google.com/youtube/v3/guides/authentication
        def authorize(oauth_client : Google::Auth::OAuth2Client)
          self.access_token = oauth_client.valid_token
        end

        # Sets the authorization credentials using a service account.
        # Extracts a valid access token from the service account credentials and applies it to all subsequent API requests.
        # See https://developers.google.com/youtube/v3/guides/authentication
        def authorize(credentials : Google::Auth::ServiceAccountCredentials)
          self.access_token = credentials.valid_token
        end

        # Executes multiple API requests in a single HTTP connection using batch processing (max 50 requests).
        # Yields a `BatchRequest` object to which individual requests can be added.
        # Returns an array of HTTP responses, one per batched request.
        def batch(&block : Google::Apis::Core::BatchRequest ->) : Array(HTTP::Client::Response)
          auth = @access_token ? "Bearer #{@access_token}" : nil
          batch_req = Google::Apis::Core::BatchRequest.new(@root_url, authorization: auth)
          yield batch_req
          batch_req.execute
        end

        # ============================================================
        # Search
        # ============================================================

        # Searches for YouTube resources (videos, channels, playlists) matching the given query parameters.
        # The *part* parameter specifies the resource properties to include (e.g., "snippet").
        # Filter by *q* (search query), *type* (video/channel/playlist), *channel_id*, *region_code*, and many more.
        # Returns a `SearchListsResponse` containing matching results with pagination support via *page_token*.
        # See https://developers.google.com/youtube/v3/docs/search/list
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

        # Retrieves a list of videos matching the specified criteria.
        # The *part* parameter specifies which resource properties to include (e.g., "snippet,contentDetails,statistics").
        # Filter by *id* (comma-separated video IDs), *chart* (mostPopular), or *my_rating* (like/dislike).
        # Returns a `ListVideosResponse` with pagination support via *page_token*.
        # See https://developers.google.com/youtube/v3/docs/videos/list
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

        # Deletes a YouTube video identified by *id*.
        # Requires authorization with the appropriate scope. Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/videos/delete
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

        # Adds a like or dislike rating to a video, or removes a rating.
        # The *id* is the video ID and *rating* must be one of "like", "dislike", or "none".
        # See https://developers.google.com/youtube/v3/docs/videos/rate
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

        # Uploads a video to YouTube with the given metadata.
        # The *part* parameter specifies which properties are included in the *video_object* (e.g., "snippet,status").
        # Set *notify_subscribers* to false to suppress notification to channel subscribers.
        # Returns the newly created `Video` resource.
        # See https://developers.google.com/youtube/v3/docs/videos/insert
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

        # Updates a video's metadata.
        # The *part* parameter specifies which properties in *video_object* will be updated.
        # The video ID must be set in the *video_object*. Returns the updated `Video` resource.
        # See https://developers.google.com/youtube/v3/docs/videos/update
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

        # Retrieves the rating (like/dislike/none) that the authorized user gave to a video.
        # The *id* parameter is a comma-separated list of video IDs.
        # Returns a `JSON::Any` containing rating information for each requested video.
        # See https://developers.google.com/youtube/v3/docs/videos/getRating
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

        # Retrieves a list of YouTube channels matching the specified criteria.
        # The *part* parameter specifies which properties to include (e.g., "snippet,statistics,contentDetails").
        # Filter by *id*, *for_username*, *for_handle*, *mine* (authenticated user's channel), or *category_id*.
        # Returns a `ListChannelsResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/docs/channels/list
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

        # Updates a channel's metadata (e.g., branding settings, localized info).
        # The *part* parameter specifies which properties in *channel_object* will be updated.
        # Returns the updated `Channel` resource.
        # See https://developers.google.com/youtube/v3/docs/channels/update
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

        # Retrieves a list of playlists matching the specified criteria.
        # The *part* parameter specifies which properties to include (e.g., "snippet,contentDetails").
        # Filter by *channel_id*, *id* (comma-separated playlist IDs), or *mine* for the authenticated user's playlists.
        # Returns a `ListPlaylistsResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/docs/playlists/list
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

        # Creates a new playlist for the authenticated user.
        # The *part* parameter specifies which properties are set in *playlist_object* (e.g., "snippet,status").
        # Returns the newly created `Playlist` resource.
        # See https://developers.google.com/youtube/v3/docs/playlists/insert
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

        # Updates a playlist's metadata (e.g., title, description, privacy status).
        # The *part* parameter specifies which properties in *playlist_object* will be updated.
        # Returns the updated `Playlist` resource.
        # See https://developers.google.com/youtube/v3/docs/playlists/update
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

        # Deletes a playlist identified by *id*.
        # Returns `Nil` on success. Requires authorization.
        # See https://developers.google.com/youtube/v3/docs/playlists/delete
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

        # Retrieves a list of items in a playlist.
        # The *part* parameter specifies which properties to include (e.g., "snippet,contentDetails").
        # Filter by *playlist_id* to get items from a specific playlist, or *id* for specific item IDs.
        # Returns a `ListPlaylistItemsResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/docs/playlistItems/list
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

        # Adds a resource (video) to a playlist.
        # The *playlist_item_object* must include the playlist ID and the resource to add.
        # Returns the newly created `PlaylistItem` resource.
        # See https://developers.google.com/youtube/v3/docs/playlistItems/insert
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

        # Updates a playlist item (e.g., changes its position in the playlist or updates the video note).
        # The *playlist_item_object* must include the item ID and updated properties.
        # Returns the updated `PlaylistItem` resource.
        # See https://developers.google.com/youtube/v3/docs/playlistItems/update
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

        # Removes an item from a playlist by its *id*.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/playlistItems/delete
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

        # Retrieves a list of comments matching the specified criteria.
        # The *part* parameter specifies which properties to include (e.g., "snippet").
        # Filter by *id* for specific comments or *parent_id* for replies to a top-level comment.
        # Returns a `ListCommentsResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/docs/comments/list
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

        # Creates a reply to an existing comment.
        # The *comment_object* must include the parent comment ID and text content.
        # Returns the newly created `Comment` resource.
        # See https://developers.google.com/youtube/v3/docs/comments/insert
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

        # Updates an existing comment's text.
        # The *comment_object* must include the comment ID and updated text.
        # Returns the updated `Comment` resource.
        # See https://developers.google.com/youtube/v3/docs/comments/update
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

        # Flags one or more comments as spam.
        # The *id* parameter is a comma-separated list of comment IDs to flag.
        # See https://developers.google.com/youtube/v3/docs/comments/markAsSpam
        def mark_comment_as_spam(id : String,
                                 fields : String? = nil,
                                 quota_user : String? = nil) : Nil
          query = {} of String => String?
          query["id"] = id
          query["fields"] = fields
          query["quotaUser"] = quota_user
          execute_delete("POST", "comments/markAsSpam", query)
        end

        # Sets the moderation status of one or more comments.
        # The *moderation_status* can be "published", "heldForReview", or "rejected".
        # Set *ban_author* to true to also ban the comment author from making future comments.
        # See https://developers.google.com/youtube/v3/docs/comments/setModerationStatus
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

        # Deletes a comment identified by *id*.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/comments/delete
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

        # Creates a new top-level comment thread on a video or channel.
        # The *comment_thread_object* must include the channel/video ID and the top-level comment text.
        # Returns the newly created `CommentThread` resource.
        # See https://developers.google.com/youtube/v3/docs/commentThreads/insert
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

        # Retrieves a list of comment threads matching the specified criteria.
        # The *part* parameter specifies which properties to include (e.g., "snippet,replies").
        # Filter by *video_id*, *channel_id*, *all_threads_related_to_channel_id*, or *id*.
        # Use *order* ("time" or "relevance") and *search_terms* to refine results.
        # Returns a `ListCommentThreadsResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/docs/commentThreads/list
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

        # Retrieves a list of subscriptions matching the specified criteria.
        # The *part* parameter specifies which properties to include (e.g., "snippet,contentDetails").
        # Filter by *channel_id*, *mine* (authenticated user), *my_subscribers*, or *id*.
        # Returns a `ListSubscriptionsResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/docs/subscriptions/list
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

        # Subscribes the authenticated user to a channel.
        # The *subscription_object* must include the channel ID to subscribe to.
        # Returns the newly created `Subscription` resource.
        # See https://developers.google.com/youtube/v3/docs/subscriptions/insert
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

        # Removes a subscription identified by *id*.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/subscriptions/delete
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

        # Retrieves a list of video categories available in the specified region.
        # Filter by *id* (comma-separated category IDs) or *region_code*. Use *hl* for localized category names.
        # Returns a `ListVideoCategoriesResponse`.
        # See https://developers.google.com/youtube/v3/docs/videoCategories/list
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

        # Retrieves a list of application languages that the YouTube website supports.
        # Use *hl* to specify the language for localized names. Returns a `ListI18nLanguagesResponse`.
        # See https://developers.google.com/youtube/v3/docs/i18nLanguages/list
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

        # Retrieves a list of caption tracks associated with the specified video.
        # The *video_id* is required. Optionally filter by *id* (comma-separated caption track IDs).
        # Returns a `ListCaptionsResponse`.
        # See https://developers.google.com/youtube/v3/docs/captions/list
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

        # Uploads a caption track for a video.
        # The *caption_object* must include the video ID and language. Set *sync* to true to auto-sync timing.
        # Returns the newly created `Caption` resource.
        # See https://developers.google.com/youtube/v3/docs/captions/insert
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

        # Updates an existing caption track's metadata or replaces the caption data.
        # Set *sync* to true to have YouTube auto-sync the updated caption timing.
        # Returns the updated `Caption` resource.
        # See https://developers.google.com/youtube/v3/docs/captions/update
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

        # Deletes a caption track identified by *id*.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/captions/delete
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

        # Retrieves a list of channel sections for the specified channel.
        # The *part* parameter specifies which properties to include (e.g., "snippet,contentDetails").
        # Filter by *channel_id*, *id*, or *mine*. Returns a `ListChannelSectionsResponse`.
        # See https://developers.google.com/youtube/v3/docs/channelSections/list
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

        # Creates a new channel section (e.g., featured playlists, recent activity) on a channel page.
        # The *channel_section_object* defines the section type and content.
        # Returns the newly created `ChannelSection` resource.
        # See https://developers.google.com/youtube/v3/docs/channelSections/insert
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

        # Updates an existing channel section's metadata.
        # The *channel_section_object* must include the section ID and updated properties.
        # Returns the updated `ChannelSection` resource.
        # See https://developers.google.com/youtube/v3/docs/channelSections/update
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

        # Deletes a channel section identified by *id*.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/channelSections/delete
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

        # Retrieves a list of channel activity events (uploads, likes, favorites, etc.).
        # The *part* parameter specifies which properties to include (e.g., "snippet,contentDetails").
        # Filter by *channel_id* or *mine*. Use *published_after*/*published_before* for date ranges.
        # Returns a `ListActivitiesResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/docs/activities/list
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

        # Retrieves a list of live broadcasts matching the specified criteria.
        # The *part* parameter specifies which properties to include (e.g., "snippet,status,contentDetails").
        # Filter by *broadcast_status* ("active", "all", "completed", "upcoming"), *id*, or *mine*.
        # Returns a `ListLiveBroadcastsResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/live/docs/liveBroadcasts/list
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

        # Creates a new live broadcast event.
        # The *live_broadcast_object* must include title, scheduled start time, and privacy status.
        # Returns the newly created `LiveBroadcast` resource.
        # See https://developers.google.com/youtube/v3/live/docs/liveBroadcasts/insert
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

        # Updates an existing live broadcast's metadata (e.g., title, description, scheduled times).
        # The *live_broadcast_object* must include the broadcast ID and updated properties.
        # Returns the updated `LiveBroadcast` resource.
        # See https://developers.google.com/youtube/v3/live/docs/liveBroadcasts/update
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

        # Deletes a live broadcast identified by *id*.
        # The broadcast must be in "complete" or "testing" status to be deleted.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/live/docs/liveBroadcasts/delete
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

        # Binds a live broadcast to a live stream, or removes an existing binding.
        # The *id* is the broadcast ID. Set *stream_id* to bind, or omit it to unbind the current stream.
        # Returns the updated `LiveBroadcast` resource.
        # See https://developers.google.com/youtube/v3/live/docs/liveBroadcasts/bind
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

        # Transitions a live broadcast to a new status (e.g., "testing", "live", "complete").
        # The *broadcast_status* specifies the target status. The broadcast must be bound to a stream first.
        # Returns the updated `LiveBroadcast` resource.
        # See https://developers.google.com/youtube/v3/live/docs/liveBroadcasts/transition
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

        # Retrieves a list of live streams owned by the authenticated user.
        # The *part* parameter specifies which properties to include (e.g., "snippet,cdn,status").
        # Filter by *id* or *mine*. Returns a `ListLiveStreamsResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/live/docs/liveStreams/list
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

        # Creates a new live stream for the authenticated user.
        # The *live_stream_object* must include CDN settings and a title.
        # Returns the newly created `LiveStream` resource with ingestion info.
        # See https://developers.google.com/youtube/v3/live/docs/liveStreams/insert
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

        # Updates an existing live stream's metadata.
        # The *live_stream_object* must include the stream ID and updated properties.
        # Returns the updated `LiveStream` resource.
        # See https://developers.google.com/youtube/v3/live/docs/liveStreams/update
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

        # Deletes a live stream identified by *id*.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/live/docs/liveStreams/delete
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

        # Retrieves live chat messages from a live broadcast's chat.
        # The *live_chat_id* identifies the chat. Use *page_token* for polling new messages.
        # Returns a `LiveChatMessageListResponse` with messages and a polling interval.
        # See https://developers.google.com/youtube/v3/live/docs/liveChatMessages/list
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

        # Sends a message to a live broadcast's chat.
        # The *live_chat_message_object* must include the live chat ID and message text.
        # Returns the newly created `LiveChatMessage` resource.
        # See https://developers.google.com/youtube/v3/live/docs/liveChatMessages/insert
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

        # Deletes a live chat message identified by *id*.
        # Only the message author or a chat moderator can delete a message. Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/live/docs/liveChatMessages/delete
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

        # Retrieves a list of moderators for a live chat.
        # The *live_chat_id* identifies the chat. Returns a `LiveChatModeratorListResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/live/docs/liveChatModerators/list
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

        # Adds a moderator to a live chat.
        # The *live_chat_moderator_object* must include the live chat ID and the channel ID of the user to promote.
        # Returns the newly created `LiveChatModerator` resource.
        # See https://developers.google.com/youtube/v3/live/docs/liveChatModerators/insert
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

        # Removes a moderator from a live chat identified by *id*.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/live/docs/liveChatModerators/delete
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

        # Bans a user from a live chat, preventing them from sending messages.
        # The *live_chat_ban_object* must include the live chat ID, banned user channel ID, and ban type ("permanent" or "temporary").
        # Returns the newly created `LiveChatBan` resource.
        # See https://developers.google.com/youtube/v3/live/docs/liveChatBans/insert
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

        # Removes a ban from a live chat, allowing the user to send messages again.
        # The *id* is the ban ID. Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/live/docs/liveChatBans/delete
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

        # Sets a watermark image for a channel's videos.
        # The *channel_id* identifies the target channel and *invideo_branding_object* contains the watermark configuration.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/watermarks/set
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

        # Removes the watermark image from a channel's videos.
        # The *channel_id* identifies the channel to remove the watermark from.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/watermarks/unset
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

        # Sets a custom thumbnail image for a video.
        # The *video_id* identifies the video to set the thumbnail for.
        # Returns a `SetThumbnailResponse` containing the thumbnail URLs.
        # See https://developers.google.com/youtube/v3/docs/thumbnails/set
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

        # Retrieves a list of channel members (sponsors) for the authenticated user's channel.
        # Filter by *filter_by_member_channel_id* for specific members, or *has_access_to_level* for a membership level.
        # The *mode* parameter controls listing mode ("list_by_member" or "list_by_newest").
        # Returns a `MemberListResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/docs/members/list
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

        # Retrieves all membership levels defined for the authenticated user's channel.
        # Returns a `MembershipsLevelListResponse` containing the available pricing levels.
        # See https://developers.google.com/youtube/v3/docs/membershipsLevels/list
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

        # Retrieves a list of Super Chat events for the authenticated user's channel.
        # Super Chat events represent paid messages from viewers during live streams.
        # Returns a `SuperChatEventListResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/docs/superChatEvents/list
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

        # Retrieves a list of content regions that the YouTube website supports.
        # Use *hl* to specify the language for localized region names. Returns a `ListI18nRegionsResponse`.
        # See https://developers.google.com/youtube/v3/docs/i18nRegions/list
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

        # Submits an abuse report for a YouTube resource (e.g., video, comment, channel).
        # The *abuse_report_object* contains the report details as JSON. Returns the created report as `JSON::Any`.
        # See https://developers.google.com/youtube/v3/docs/abuseReports/insert
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

        # Retrieves the list of valid reasons for reporting a video as abusive.
        # Use *hl* for localized reason descriptions. Returns a `ListVideoAbuseReportReasonResponse`.
        # See https://developers.google.com/youtube/v3/docs/videoAbuseReportReasons/list
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

        # Reports a video as abusive by submitting a video abuse report.
        # The *video_abuse_report_object* must include the video ID, reason ID, and optionally a secondary reason ID.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/videos/reportAbuse
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

        # Retrieves trainability information for a video.
        # The *id* parameter specifies the video ID. Returns a `VideoTrainability` resource.
        # See https://developers.google.com/youtube/v3/docs/videos
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

        # Retrieves a list of third-party links associated with a channel.
        # Filter by *linking_token*, *type*, or *external_channel_id*.
        # Returns a `ThirdPartyLinkListResponse`.
        # See https://developers.google.com/youtube/v3/docs/thirdPartyLinks/list
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

        # Creates a new third-party link between a YouTube channel and an external platform.
        # The *third_party_link_object* defines the link details. Returns the newly created `ThirdPartyLink`.
        # See https://developers.google.com/youtube/v3/docs/thirdPartyLinks/insert
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

        # Updates an existing third-party link's metadata.
        # The *third_party_link_object* must include the link ID and updated properties.
        # Returns the updated `ThirdPartyLink` resource.
        # See https://developers.google.com/youtube/v3/docs/thirdPartyLinks/update
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

        # Deletes a third-party link identified by *linking_token* and *type*.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/thirdPartyLinks/delete
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

        # Retrieves a list of images associated with a playlist.
        # Use *parent* to specify the playlist ID. Returns a `PlaylistImageListResponse` with pagination support.
        # See https://developers.google.com/youtube/v3/docs/playlistImages/list
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

        # Uploads and associates an image with a playlist.
        # Provide the image via *upload_source* (file path or IO) with the appropriate *content_type*.
        # If no *upload_source* is given, creates the image from *playlist_image_object* metadata only.
        # Returns the newly created `PlaylistImage` resource.
        # See https://developers.google.com/youtube/v3/docs/playlistImages/insert
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

        # Updates an existing playlist image, optionally replacing the image data.
        # Provide a new image via *upload_source* (file path or IO) with the appropriate *content_type*.
        # Returns the updated `PlaylistImage` resource.
        # See https://developers.google.com/youtube/v3/docs/playlistImages/update
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

        # Deletes a playlist image identified by *id*.
        # Returns `Nil` on success.
        # See https://developers.google.com/youtube/v3/docs/playlistImages/delete
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

        # Inserts a cuepoint (ad break) into a live broadcast.
        # The *id* is the broadcast ID. The *cuepoint_object* contains cuepoint settings such as duration.
        # Returns the created `Cuepoint` resource.
        # See https://developers.google.com/youtube/v3/live/docs/liveBroadcasts/cuepoint
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

        # Transitions a live chat message to a new status.
        # The *id* is the message ID and *status* is the target status.
        # Returns `Nil` on success.
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

        # Streams live chat messages via a persistent connection for real-time updates.
        # The *live_chat_id* identifies the chat. Use *page_token* for continuation.
        # Returns a `LiveChatMessageListResponse` with messages and polling metadata.
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

        # Updates an existing comment thread (e.g., modifies the top-level comment text).
        # The *comment_thread_object* must include the thread ID and updated properties.
        # Returns the updated `CommentThread` resource.
        # See https://developers.google.com/youtube/v3/docs/commentThreads
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

        # Downloads a caption track file.
        # The *id* is the caption track ID. Use *tfmt* to specify the output format (e.g., "srt", "vtt", "sbv").
        # Use *tlang* to request a translated caption. The file is written to *download_dest* (file path or IO).
        # See https://developers.google.com/youtube/v3/docs/captions/download
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

        # Uploads a channel banner image. The returned URL can then be used with `update_channel` to set the banner.
        # Provide the image via *upload_source* (file path or IO) with the appropriate *content_type*.
        # Returns a `ChannelBannerResource` containing the URL to use in the channel branding settings.
        # See https://developers.google.com/youtube/v3/docs/channelBanners/insert
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

        # Inserts a test item (internal/testing endpoint).
        # The *test_item_object* contains the test data. Returns the created `TestItem`.
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
