require "json"

module Google
  module Apis
    module YoutubeV3
      # Paging details for lists of resources
      class PageInfo
        include JSON::Serializable

        @[JSON::Field(key: "totalResults")]
        property total_results : Int32?

        @[JSON::Field(key: "resultsPerPage")]
        property results_per_page : Int32?
      end

      # A thumbnail image
      class Thumbnail
        include JSON::Serializable

        property url : String?
        property width : Int32?
        property height : Int32?
      end

      # Thumbnail images associated with a resource
      class ThumbnailDetails
        include JSON::Serializable

        property default : Thumbnail?
        property medium : Thumbnail?
        property high : Thumbnail?
        property standard : Thumbnail?
        property maxres : Thumbnail?
      end

      # A resource id with type information
      class ResourceId
        include JSON::Serializable

        property kind : String?

        @[JSON::Field(key: "videoId")]
        property video_id : String?

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        @[JSON::Field(key: "playlistId")]
        property playlist_id : String?
      end

      # ============================================================
      # Search
      # ============================================================

      class SearchResultSnippet
        include JSON::Serializable

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        property title : String?
        property description : String?
        property thumbnails : ThumbnailDetails?

        @[JSON::Field(key: "channelTitle")]
        property channel_title : String?

        @[JSON::Field(key: "liveBroadcastContent")]
        property live_broadcast_content : String?
      end

      class SearchResult
        include JSON::Serializable

        property etag : String?
        property id : ResourceId?
        property kind : String?
        property snippet : SearchResultSnippet?
      end

      class SearchListsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(SearchResult)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?

        @[JSON::Field(key: "regionCode")]
        property region_code : String?
      end

      # ============================================================
      # Video
      # ============================================================

      class VideoSnippet
        include JSON::Serializable

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        property title : String?
        property description : String?
        property thumbnails : ThumbnailDetails?

        @[JSON::Field(key: "channelTitle")]
        property channel_title : String?

        property tags : Array(String)?

        @[JSON::Field(key: "categoryId")]
        property category_id : String?

        @[JSON::Field(key: "liveBroadcastContent")]
        property live_broadcast_content : String?

        @[JSON::Field(key: "defaultLanguage")]
        property default_language : String?

        @[JSON::Field(key: "defaultAudioLanguage")]
        property default_audio_language : String?
      end

      class VideoStatistics
        include JSON::Serializable

        @[JSON::Field(key: "viewCount")]
        property view_count : String?

        @[JSON::Field(key: "likeCount")]
        property like_count : String?

        @[JSON::Field(key: "dislikeCount")]
        property dislike_count : String?

        @[JSON::Field(key: "favoriteCount")]
        property favorite_count : String?

        @[JSON::Field(key: "commentCount")]
        property comment_count : String?
      end

      class VideoStatus
        include JSON::Serializable

        @[JSON::Field(key: "uploadStatus")]
        property upload_status : String?

        @[JSON::Field(key: "failureReason")]
        property failure_reason : String?

        @[JSON::Field(key: "rejectionReason")]
        property rejection_reason : String?

        @[JSON::Field(key: "privacyStatus")]
        property privacy_status : String?

        @[JSON::Field(key: "publishAt")]
        property publish_at : String?

        property license : String?
        property embeddable : Bool?

        @[JSON::Field(key: "publicStatsViewable")]
        property public_stats_viewable : Bool?

        @[JSON::Field(key: "madeForKids")]
        property made_for_kids : Bool?

        @[JSON::Field(key: "containsSyntheticMedia")]
        property contains_synthetic_media : Bool?

        @[JSON::Field(key: "selfDeclaredMadeForKids")]
        property self_declared_made_for_kids : Bool?
      end

      class VideoContentDetails
        include JSON::Serializable

        property duration : String?
        property dimension : String?
        property definition : String?
        property caption : String?

        @[JSON::Field(key: "licensedContent")]
        property licensed_content : Bool?

        property projection : String?

        @[JSON::Field(key: "hasCustomThumbnail")]
        property has_custom_thumbnail : Bool?
      end

      class Video
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : VideoSnippet?
        property statistics : VideoStatistics?
        property status : VideoStatus?

        @[JSON::Field(key: "contentDetails")]
        property content_details : VideoContentDetails?
      end

      class ListVideosResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(Video)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?
      end

      # ============================================================
      # Channel
      # ============================================================

      class ChannelSnippet
        include JSON::Serializable

        property title : String?
        property description : String?

        @[JSON::Field(key: "customUrl")]
        property custom_url : String?

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        property thumbnails : ThumbnailDetails?

        @[JSON::Field(key: "defaultLanguage")]
        property default_language : String?

        property country : String?
      end

      class ChannelStatistics
        include JSON::Serializable

        @[JSON::Field(key: "viewCount")]
        property view_count : String?

        @[JSON::Field(key: "subscriberCount")]
        property subscriber_count : String?

        @[JSON::Field(key: "hiddenSubscriberCount")]
        property hidden_subscriber_count : Bool?

        @[JSON::Field(key: "videoCount")]
        property video_count : String?

        @[JSON::Field(key: "commentCount")]
        property comment_count : String?
      end

      class ChannelContentDetailsRelatedPlaylists
        include JSON::Serializable

        property likes : String?
        property favorites : String?
        property uploads : String?

        @[JSON::Field(key: "watchHistory")]
        property watch_history : String?

        @[JSON::Field(key: "watchLater")]
        property watch_later : String?
      end

      class ChannelContentDetails
        include JSON::Serializable

        @[JSON::Field(key: "relatedPlaylists")]
        property related_playlists : ChannelContentDetailsRelatedPlaylists?
      end

      class ChannelStatus
        include JSON::Serializable

        @[JSON::Field(key: "privacyStatus")]
        property privacy_status : String?

        @[JSON::Field(key: "isLinked")]
        property is_linked : Bool?

        @[JSON::Field(key: "longUploadsStatus")]
        property long_uploads_status : String?

        @[JSON::Field(key: "madeForKids")]
        property made_for_kids : Bool?

        @[JSON::Field(key: "selfDeclaredMadeForKids")]
        property self_declared_made_for_kids : Bool?
      end

      class Channel
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : ChannelSnippet?
        property statistics : ChannelStatistics?
        property status : ChannelStatus?

        @[JSON::Field(key: "contentDetails")]
        property content_details : ChannelContentDetails?
      end

      class ListChannelsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(Channel)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?
      end

      # ============================================================
      # Playlist
      # ============================================================

      class PlaylistSnippet
        include JSON::Serializable

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        property title : String?
        property description : String?
        property thumbnails : ThumbnailDetails?

        @[JSON::Field(key: "channelTitle")]
        property channel_title : String?

        @[JSON::Field(key: "defaultLanguage")]
        property default_language : String?

        property tags : Array(String)?
      end

      class PlaylistContentDetails
        include JSON::Serializable

        @[JSON::Field(key: "itemCount")]
        property item_count : Int32?
      end

      class PlaylistStatus
        include JSON::Serializable

        @[JSON::Field(key: "privacyStatus")]
        property privacy_status : String?
      end

      class Playlist
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : PlaylistSnippet?

        @[JSON::Field(key: "contentDetails")]
        property content_details : PlaylistContentDetails?

        property status : PlaylistStatus?
      end

      class ListPlaylistsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(Playlist)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?
      end

      # ============================================================
      # PlaylistItem
      # ============================================================

      class PlaylistItemSnippet
        include JSON::Serializable

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        property title : String?
        property description : String?
        property thumbnails : ThumbnailDetails?

        @[JSON::Field(key: "channelTitle")]
        property channel_title : String?

        @[JSON::Field(key: "playlistId")]
        property playlist_id : String?

        property position : Int32?

        @[JSON::Field(key: "resourceId")]
        property resource_id : ResourceId?

        @[JSON::Field(key: "videoOwnerChannelId")]
        property video_owner_channel_id : String?

        @[JSON::Field(key: "videoOwnerChannelTitle")]
        property video_owner_channel_title : String?
      end

      class PlaylistItemContentDetails
        include JSON::Serializable

        @[JSON::Field(key: "videoId")]
        property video_id : String?

        @[JSON::Field(key: "videoPublishedAt")]
        property video_published_at : String?

        @[JSON::Field(key: "startAt")]
        property start_at : String?

        @[JSON::Field(key: "endAt")]
        property end_at : String?

        property note : String?
      end

      class PlaylistItemStatus
        include JSON::Serializable

        @[JSON::Field(key: "privacyStatus")]
        property privacy_status : String?
      end

      class PlaylistItem
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : PlaylistItemSnippet?

        @[JSON::Field(key: "contentDetails")]
        property content_details : PlaylistItemContentDetails?

        property status : PlaylistItemStatus?
      end

      class ListPlaylistItemsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(PlaylistItem)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?
      end

      # ============================================================
      # Comment
      # ============================================================

      class CommentSnippetAuthorChannelId
        include JSON::Serializable

        property value : String?
      end

      class CommentSnippet
        include JSON::Serializable

        @[JSON::Field(key: "authorDisplayName")]
        property author_display_name : String?

        @[JSON::Field(key: "authorProfileImageUrl")]
        property author_profile_image_url : String?

        @[JSON::Field(key: "authorChannelUrl")]
        property author_channel_url : String?

        @[JSON::Field(key: "authorChannelId")]
        property author_channel_id : CommentSnippetAuthorChannelId?

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        @[JSON::Field(key: "videoId")]
        property video_id : String?

        @[JSON::Field(key: "textDisplay")]
        property text_display : String?

        @[JSON::Field(key: "textOriginal")]
        property text_original : String?

        @[JSON::Field(key: "parentId")]
        property parent_id : String?

        @[JSON::Field(key: "canRate")]
        property can_rate : Bool?

        @[JSON::Field(key: "viewerRating")]
        property viewer_rating : String?

        @[JSON::Field(key: "likeCount")]
        property like_count : Int32?

        @[JSON::Field(key: "moderationStatus")]
        property moderation_status : String?

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        @[JSON::Field(key: "updatedAt")]
        property updated_at : String?
      end

      class Comment
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : CommentSnippet?
      end

      class ListCommentsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(Comment)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?
      end

      # ============================================================
      # CommentThread
      # ============================================================

      class CommentThreadReplies
        include JSON::Serializable

        property comments : Array(Comment)?
      end

      class CommentThreadSnippet
        include JSON::Serializable

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        @[JSON::Field(key: "videoId")]
        property video_id : String?

        @[JSON::Field(key: "topLevelComment")]
        property top_level_comment : Comment?

        @[JSON::Field(key: "canReply")]
        property can_reply : Bool?

        @[JSON::Field(key: "totalReplyCount")]
        property total_reply_count : Int32?

        @[JSON::Field(key: "isPublic")]
        property is_public : Bool?
      end

      class CommentThread
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : CommentThreadSnippet?
        property replies : CommentThreadReplies?
      end

      class ListCommentThreadsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(CommentThread)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?
      end

      # ============================================================
      # Subscription
      # ============================================================

      class SubscriptionSnippet
        include JSON::Serializable

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        property title : String?
        property description : String?
        property thumbnails : ThumbnailDetails?

        @[JSON::Field(key: "resourceId")]
        property resource_id : ResourceId?
      end

      class SubscriptionContentDetails
        include JSON::Serializable

        @[JSON::Field(key: "totalItemCount")]
        property total_item_count : Int32?

        @[JSON::Field(key: "newItemCount")]
        property new_item_count : Int32?

        @[JSON::Field(key: "activityType")]
        property activity_type : String?
      end

      class Subscription
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : SubscriptionSnippet?

        @[JSON::Field(key: "contentDetails")]
        property content_details : SubscriptionContentDetails?
      end

      class ListSubscriptionsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(Subscription)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?
      end

      # ============================================================
      # VideoCategory
      # ============================================================

      class VideoCategorySnippet
        include JSON::Serializable

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        property title : String?
        property assignable : Bool?
      end

      class VideoCategory
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : VideoCategorySnippet?
      end

      class ListVideoCategoriesResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(VideoCategory)?
        property kind : String?
      end

      # ============================================================
      # I18n
      # ============================================================

      class I18nLanguageSnippet
        include JSON::Serializable

        property hl : String?
        property name : String?
      end

      class I18nLanguage
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : I18nLanguageSnippet?
      end

      class ListI18nLanguagesResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(I18nLanguage)?
        property kind : String?
      end

      class I18nRegionSnippet
        include JSON::Serializable

        property gl : String?
        property name : String?
      end

      class I18nRegion
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : I18nRegionSnippet?
      end

      class ListI18nRegionsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(I18nRegion)?
        property kind : String?
      end

      # ============================================================
      # Caption
      # ============================================================

      class CaptionSnippet
        include JSON::Serializable

        @[JSON::Field(key: "audioTrackType")]
        property audio_track_type : String?

        @[JSON::Field(key: "failureReason")]
        property failure_reason : String?

        @[JSON::Field(key: "isAutoSynced")]
        property is_auto_synced : Bool?

        @[JSON::Field(key: "isCC")]
        property is_cc : Bool?

        @[JSON::Field(key: "isDraft")]
        property is_draft : Bool?

        @[JSON::Field(key: "isEasyReader")]
        property is_easy_reader : Bool?

        @[JSON::Field(key: "isLarge")]
        property is_large : Bool?

        property language : String?

        @[JSON::Field(key: "lastUpdated")]
        property last_updated : String?

        property name : String?
        property status : String?

        @[JSON::Field(key: "trackKind")]
        property track_kind : String?

        @[JSON::Field(key: "videoId")]
        property video_id : String?
      end

      class Caption
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : CaptionSnippet?
      end

      class ListCaptionsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(Caption)?
        property kind : String?
      end

      # ============================================================
      # ChannelSection
      # ============================================================

      class ChannelSectionSnippet
        include JSON::Serializable

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        @[JSON::Field(key: "defaultLanguage")]
        property default_language : String?

        property position : Int32?
        property style : String?
        property title : String?
        property type : String?
      end

      class ChannelSectionContentDetails
        include JSON::Serializable

        property channels : Array(String)?
        property playlists : Array(String)?
      end

      class ChannelSection
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : ChannelSectionSnippet?

        @[JSON::Field(key: "contentDetails")]
        property content_details : ChannelSectionContentDetails?
      end

      class ListChannelSectionsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(ChannelSection)?
        property kind : String?
      end

      # ============================================================
      # Activity
      # ============================================================

      class ActivityContentDetailsUpload
        include JSON::Serializable

        @[JSON::Field(key: "videoId")]
        property video_id : String?
      end

      class ActivityContentDetailsLike
        include JSON::Serializable

        @[JSON::Field(key: "resourceId")]
        property resource_id : ResourceId?
      end

      class ActivityContentDetailsFavorite
        include JSON::Serializable

        @[JSON::Field(key: "resourceId")]
        property resource_id : ResourceId?
      end

      class ActivityContentDetailsComment
        include JSON::Serializable

        @[JSON::Field(key: "resourceId")]
        property resource_id : ResourceId?
      end

      class ActivityContentDetailsSubscription
        include JSON::Serializable

        @[JSON::Field(key: "resourceId")]
        property resource_id : ResourceId?
      end

      class ActivityContentDetailsPlaylistItem
        include JSON::Serializable

        @[JSON::Field(key: "resourceId")]
        property resource_id : ResourceId?

        @[JSON::Field(key: "playlistId")]
        property playlist_id : String?

        @[JSON::Field(key: "playlistItemId")]
        property playlist_item_id : String?
      end

      class ActivityContentDetails
        include JSON::Serializable

        property upload : ActivityContentDetailsUpload?
        property like : ActivityContentDetailsLike?
        property favorite : ActivityContentDetailsFavorite?
        property comment : ActivityContentDetailsComment?
        property subscription : ActivityContentDetailsSubscription?

        @[JSON::Field(key: "playlistItem")]
        property playlist_item : ActivityContentDetailsPlaylistItem?
      end

      class ActivitySnippet
        include JSON::Serializable

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        property title : String?
        property description : String?
        property thumbnails : ThumbnailDetails?

        @[JSON::Field(key: "channelTitle")]
        property channel_title : String?

        property type : String?

        @[JSON::Field(key: "groupId")]
        property group_id : String?
      end

      class Activity
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : ActivitySnippet?

        @[JSON::Field(key: "contentDetails")]
        property content_details : ActivityContentDetails?
      end

      class ListActivitiesResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(Activity)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?
      end

      # ============================================================
      # LiveBroadcast
      # ============================================================

      class LiveBroadcastSnippet
        include JSON::Serializable

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        property title : String?
        property description : String?
        property thumbnails : ThumbnailDetails?

        @[JSON::Field(key: "scheduledStartTime")]
        property scheduled_start_time : String?

        @[JSON::Field(key: "scheduledEndTime")]
        property scheduled_end_time : String?

        @[JSON::Field(key: "actualStartTime")]
        property actual_start_time : String?

        @[JSON::Field(key: "actualEndTime")]
        property actual_end_time : String?

        @[JSON::Field(key: "isDefaultBroadcast")]
        property is_default_broadcast : Bool?

        @[JSON::Field(key: "liveChatId")]
        property live_chat_id : String?
      end

      class LiveBroadcastStatus
        include JSON::Serializable

        @[JSON::Field(key: "lifeCycleStatus")]
        property life_cycle_status : String?

        @[JSON::Field(key: "privacyStatus")]
        property privacy_status : String?

        @[JSON::Field(key: "recordingStatus")]
        property recording_status : String?

        @[JSON::Field(key: "liveBroadcastPriority")]
        property live_broadcast_priority : String?

        @[JSON::Field(key: "madeForKids")]
        property made_for_kids : Bool?

        @[JSON::Field(key: "selfDeclaredMadeForKids")]
        property self_declared_made_for_kids : Bool?
      end

      class MonitorStreamInfo
        include JSON::Serializable

        @[JSON::Field(key: "enableMonitorStream")]
        property enable_monitor_stream : Bool?

        @[JSON::Field(key: "broadcastStreamDelayMs")]
        property broadcast_stream_delay_ms : Int64?

        @[JSON::Field(key: "embedHtml")]
        property embed_html : String?
      end

      class LiveBroadcastContentDetails
        include JSON::Serializable

        @[JSON::Field(key: "boundStreamId")]
        property bound_stream_id : String?

        @[JSON::Field(key: "boundStreamLastUpdateTimeMs")]
        property bound_stream_last_update_time_ms : String?

        @[JSON::Field(key: "closedCaptionsType")]
        property closed_captions_type : String?

        @[JSON::Field(key: "enableAutoStart")]
        property enable_auto_start : Bool?

        @[JSON::Field(key: "enableAutoStop")]
        property enable_auto_stop : Bool?

        @[JSON::Field(key: "enableClosedCaptions")]
        property enable_closed_captions : Bool?

        @[JSON::Field(key: "enableContentEncryption")]
        property enable_content_encryption : Bool?

        @[JSON::Field(key: "enableDvr")]
        property enable_dvr : Bool?

        @[JSON::Field(key: "enableEmbed")]
        property enable_embed : Bool?

        @[JSON::Field(key: "enableLowLatency")]
        property enable_low_latency : Bool?

        @[JSON::Field(key: "latencyPreference")]
        property latency_preference : String?

        @[JSON::Field(key: "monitorStream")]
        property monitor_stream : MonitorStreamInfo?

        property projection : String?

        @[JSON::Field(key: "recordFromStart")]
        property record_from_start : Bool?

        @[JSON::Field(key: "startWithSlate")]
        property start_with_slate : Bool?

        @[JSON::Field(key: "stereoLayout")]
        property stereo_layout : String?
      end

      class LiveBroadcast
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : LiveBroadcastSnippet?
        property status : LiveBroadcastStatus?

        @[JSON::Field(key: "contentDetails")]
        property content_details : LiveBroadcastContentDetails?
      end

      class ListLiveBroadcastsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(LiveBroadcast)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?
      end

      # ============================================================
      # LiveStream
      # ============================================================

      class LiveStreamSnippet
        include JSON::Serializable

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        property title : String?
        property description : String?

        @[JSON::Field(key: "isDefaultStream")]
        property is_default_stream : Bool?
      end

      class LiveStreamHealthStatus
        include JSON::Serializable

        property status : String?

        @[JSON::Field(key: "lastUpdateTimeSeconds")]
        property last_update_time_seconds : Int64?
      end

      class LiveStreamStatus
        include JSON::Serializable

        @[JSON::Field(key: "streamStatus")]
        property stream_status : String?

        @[JSON::Field(key: "healthStatus")]
        property health_status : LiveStreamHealthStatus?
      end

      class LiveStreamContentDetails
        include JSON::Serializable

        @[JSON::Field(key: "closedCaptionsIngestionUrl")]
        property closed_captions_ingestion_url : String?

        @[JSON::Field(key: "isReusable")]
        property is_reusable : Bool?
      end

      class CdnSettings
        include JSON::Serializable

        property format : String?

        @[JSON::Field(key: "frameRate")]
        property frame_rate : String?

        @[JSON::Field(key: "ingestionType")]
        property ingestion_type : String?

        property resolution : String?
      end

      class LiveStream
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : LiveStreamSnippet?
        property status : LiveStreamStatus?

        @[JSON::Field(key: "contentDetails")]
        property content_details : LiveStreamContentDetails?

        property cdn : CdnSettings?
      end

      class ListLiveStreamsResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(LiveStream)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?
      end

      # ============================================================
      # LiveChatMessage
      # ============================================================

      class LiveChatTextMessageDetails
        include JSON::Serializable

        @[JSON::Field(key: "messageText")]
        property message_text : String?
      end

      class LiveChatSuperChatDetails
        include JSON::Serializable

        @[JSON::Field(key: "amountMicros")]
        property amount_micros : Int64?

        @[JSON::Field(key: "amountDisplayString")]
        property amount_display_string : String?

        property currency : String?
        property tier : Int32?

        @[JSON::Field(key: "userComment")]
        property user_comment : String?
      end

      class LiveChatSuperStickerDetails
        include JSON::Serializable

        @[JSON::Field(key: "amountMicros")]
        property amount_micros : Int64?

        @[JSON::Field(key: "amountDisplayString")]
        property amount_display_string : String?

        property currency : String?
        property tier : Int32?

        @[JSON::Field(key: "superStickerMetadata")]
        property super_sticker_metadata : JSON::Any?
      end

      class LiveChatMessageSnippet
        include JSON::Serializable

        property type : String?

        @[JSON::Field(key: "liveChatId")]
        property live_chat_id : String?

        @[JSON::Field(key: "authorChannelId")]
        property author_channel_id : String?

        @[JSON::Field(key: "publishedAt")]
        property published_at : String?

        @[JSON::Field(key: "hasDisplayContent")]
        property has_display_content : Bool?

        @[JSON::Field(key: "displayMessage")]
        property display_message : String?

        @[JSON::Field(key: "textMessageDetails")]
        property text_message_details : LiveChatTextMessageDetails?

        @[JSON::Field(key: "superChatDetails")]
        property super_chat_details : LiveChatSuperChatDetails?

        @[JSON::Field(key: "superStickerDetails")]
        property super_sticker_details : LiveChatSuperStickerDetails?
      end

      class LiveChatMessageAuthorDetails
        include JSON::Serializable

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        @[JSON::Field(key: "channelUrl")]
        property channel_url : String?

        @[JSON::Field(key: "displayName")]
        property display_name : String?

        @[JSON::Field(key: "profileImageUrl")]
        property profile_image_url : String?

        @[JSON::Field(key: "isVerified")]
        property is_verified : Bool?

        @[JSON::Field(key: "isChatOwner")]
        property is_chat_owner : Bool?

        @[JSON::Field(key: "isChatSponsor")]
        property is_chat_sponsor : Bool?

        @[JSON::Field(key: "isChatModerator")]
        property is_chat_moderator : Bool?
      end

      class LiveChatMessage
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : LiveChatMessageSnippet?

        @[JSON::Field(key: "authorDetails")]
        property author_details : LiveChatMessageAuthorDetails?
      end

      class LiveChatMessageListResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(LiveChatMessage)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "offlineAt")]
        property offline_at : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "pollingIntervalMillis")]
        property polling_interval_millis : Int64?
      end

      # ============================================================
      # LiveChatModerator
      # ============================================================

      class ChannelProfileDetails
        include JSON::Serializable

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        @[JSON::Field(key: "channelUrl")]
        property channel_url : String?

        @[JSON::Field(key: "displayName")]
        property display_name : String?

        @[JSON::Field(key: "profileImageUrl")]
        property profile_image_url : String?
      end

      class LiveChatModeratorSnippet
        include JSON::Serializable

        @[JSON::Field(key: "liveChatId")]
        property live_chat_id : String?

        @[JSON::Field(key: "moderatorDetails")]
        property moderator_details : ChannelProfileDetails?
      end

      class LiveChatModerator
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : LiveChatModeratorSnippet?
      end

      class LiveChatModeratorListResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(LiveChatModerator)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?
      end

      # ============================================================
      # LiveChatBan
      # ============================================================

      class LiveChatBanSnippet
        include JSON::Serializable

        @[JSON::Field(key: "liveChatId")]
        property live_chat_id : String?

        property type : String?

        @[JSON::Field(key: "banDurationSeconds")]
        property ban_duration_seconds : Int64?

        @[JSON::Field(key: "bannedUserDetails")]
        property banned_user_details : ChannelProfileDetails?
      end

      class LiveChatBan
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : LiveChatBanSnippet?
      end

      # ============================================================
      # Member / Membership
      # ============================================================

      class MembershipsDetails
        include JSON::Serializable

        @[JSON::Field(key: "highestAccessibleLevel")]
        property highest_accessible_level : String?

        @[JSON::Field(key: "highestAccessibleLevelDisplayName")]
        property highest_accessible_level_display_name : String?

        @[JSON::Field(key: "membershipsDuration")]
        property memberships_duration : JSON::Any?
      end

      class MemberSnippet
        include JSON::Serializable

        @[JSON::Field(key: "creatorChannelId")]
        property creator_channel_id : String?

        @[JSON::Field(key: "memberDetails")]
        property member_details : ChannelProfileDetails?

        @[JSON::Field(key: "membershipsDetails")]
        property memberships_details : MembershipsDetails?
      end

      class Member
        include JSON::Serializable

        property etag : String?
        property kind : String?
        property snippet : MemberSnippet?
      end

      class MemberListResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(Member)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?
      end

      class LevelDetails
        include JSON::Serializable

        @[JSON::Field(key: "displayName")]
        property display_name : String?
      end

      class MembershipsLevelSnippet
        include JSON::Serializable

        @[JSON::Field(key: "creatorChannelId")]
        property creator_channel_id : String?

        @[JSON::Field(key: "levelDetails")]
        property level_details : LevelDetails?
      end

      class MembershipsLevel
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : MembershipsLevelSnippet?
      end

      class MembershipsLevelListResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(MembershipsLevel)?
        property kind : String?
      end

      # ============================================================
      # SuperChatEvent
      # ============================================================

      class SuperChatEventSnippet
        include JSON::Serializable

        @[JSON::Field(key: "channelId")]
        property channel_id : String?

        @[JSON::Field(key: "commentText")]
        property comment_text : String?

        @[JSON::Field(key: "createdAt")]
        property created_at : String?

        property currency : String?

        @[JSON::Field(key: "displayString")]
        property display_string : String?

        @[JSON::Field(key: "amountMicros")]
        property amount_micros : Int64?

        @[JSON::Field(key: "messageType")]
        property message_type : Int32?

        @[JSON::Field(key: "isSuperStickerEvent")]
        property is_super_sticker_event : Bool?

        @[JSON::Field(key: "supporterDetails")]
        property supporter_details : ChannelProfileDetails?
      end

      class SuperChatEvent
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : SuperChatEventSnippet?
      end

      class SuperChatEventListResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(SuperChatEvent)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?
      end

      # ============================================================
      # Thumbnail set response
      # ============================================================

      class SetThumbnailResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(ThumbnailDetails)?
        property kind : String?
      end

      # ============================================================
      # InvideoBranding (Watermark)
      # ============================================================

      class InvideoPosition
        include JSON::Serializable

        @[JSON::Field(key: "cornerPosition")]
        property corner_position : String?

        property type : String?
      end

      class InvideoTiming
        include JSON::Serializable

        @[JSON::Field(key: "durationMs")]
        property duration_ms : Int64?

        @[JSON::Field(key: "offsetMs")]
        property offset_ms : Int64?

        property type : String?
      end

      class InvideoBranding
        include JSON::Serializable

        @[JSON::Field(key: "imageBytes")]
        property image_bytes : String?

        @[JSON::Field(key: "imageUrl")]
        property image_url : String?

        property position : InvideoPosition?

        @[JSON::Field(key: "targetChannelId")]
        property target_channel_id : String?

        property timing : InvideoTiming?
      end

      # ============================================================
      # VideoAbuseReport
      # ============================================================

      class VideoAbuseReport
        include JSON::Serializable

        property comments : String?
        property language : String?

        @[JSON::Field(key: "reasonId")]
        property reason_id : String?

        @[JSON::Field(key: "secondaryReasonId")]
        property secondary_reason_id : String?

        @[JSON::Field(key: "videoId")]
        property video_id : String?
      end

      class VideoAbuseReportSecondaryReason
        include JSON::Serializable

        property id : String?
        property label : String?
      end

      class VideoAbuseReportReasonSnippet
        include JSON::Serializable

        property label : String?

        @[JSON::Field(key: "secondaryReasons")]
        property secondary_reasons : Array(VideoAbuseReportSecondaryReason)?
      end

      class VideoAbuseReportReason
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
        property snippet : VideoAbuseReportReasonSnippet?
      end

      class ListVideoAbuseReportReasonResponse
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "eventId")]
        property event_id : String?

        property items : Array(VideoAbuseReportReason)?
        property kind : String?
      end

      # ============================================================
      # ThirdPartyLink
      # ============================================================

      class ChannelToStoreLinkDetails
        include JSON::Serializable

        @[JSON::Field(key: "billingDetails")]
        property billing_details : JSON::Any?

        @[JSON::Field(key: "merchantName")]
        property merchant_name : String?

        @[JSON::Field(key: "storeName")]
        property store_name : String?

        @[JSON::Field(key: "storeUrl")]
        property store_url : String?
      end

      class ThirdPartyLinkSnippet
        include JSON::Serializable

        @[JSON::Field(key: "channelToStoreLink")]
        property channel_to_store_link : ChannelToStoreLinkDetails?

        property type : String?
      end

      class ThirdPartyLinkStatus
        include JSON::Serializable

        @[JSON::Field(key: "linkStatus")]
        property link_status : String?
      end

      class ThirdPartyLink
        include JSON::Serializable

        property etag : String?
        property kind : String?

        @[JSON::Field(key: "linkingToken")]
        property linking_token : String?

        property snippet : ThirdPartyLinkSnippet?
        property status : ThirdPartyLinkStatus?
      end

      class ThirdPartyLinkListResponse
        include JSON::Serializable

        property etag : String?
        property items : Array(ThirdPartyLink)?
        property kind : String?
      end

      # ============================================================
      # PlaylistImage
      # ============================================================

      class PlaylistImageSnippet
        include JSON::Serializable

        property height : Int32?

        @[JSON::Field(key: "playlistId")]
        property playlist_id : String?

        property type : String?
        property width : Int32?
      end

      class PlaylistImage
        include JSON::Serializable

        property id : String?
        property kind : String?
        property snippet : PlaylistImageSnippet?
      end

      class PlaylistImageListResponse
        include JSON::Serializable

        property items : Array(PlaylistImage)?
        property kind : String?

        @[JSON::Field(key: "nextPageToken")]
        property next_page_token : String?

        @[JSON::Field(key: "pageInfo")]
        property page_info : PageInfo?

        @[JSON::Field(key: "prevPageToken")]
        property prev_page_token : String?
      end

      # ============================================================
      # Cuepoint
      # ============================================================

      class Cuepoint
        include JSON::Serializable

        @[JSON::Field(key: "cueType")]
        property cue_type : String?

        @[JSON::Field(key: "durationSecs")]
        property duration_secs : Int64?

        property etag : String?
        property id : String?

        @[JSON::Field(key: "insertionOffsetTimeMs")]
        property insertion_offset_time_ms : Int64?

        @[JSON::Field(key: "walltimeMs")]
        property walltime_ms : Int64?
      end

      # ============================================================
      # ChannelBannerResource
      # ============================================================

      class ChannelBannerResource
        include JSON::Serializable

        property etag : String?
        property kind : String?
        property url : String?
      end

      # ============================================================
      # TestItem
      # ============================================================

      class TestItemTestItemSnippet
        include JSON::Serializable
      end

      class TestItem
        include JSON::Serializable

        property etag : String?

        @[JSON::Field(key: "featuredPart")]
        property featured_part : Bool?

        property gaia : Int64?
        property id : String?
        property snippet : TestItemTestItemSnippet?
      end

      # ============================================================
      # VideoTrainability
      # ============================================================

      class VideoTrainability
        include JSON::Serializable

        property etag : String?
        property id : String?
        property kind : String?
      end
    end
  end
end
