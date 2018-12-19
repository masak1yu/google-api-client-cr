require "json"

module Google
  module Apis
    module YoutubeV3
      class YouTubeService < Google::Apis::Core::BaseService
      	property :key

      	def initialize
          super("www.googleapis.com", "/youtube/v3/")
        end

        def list_searches(part, channel_id = nil, channel_type = nil, event_type = nil, for_content_owner = nil, for_developer = nil, for_mine = nil, location = nil, location_radius = nil, max_results = nil, on_behalf_of_content_owner = nil, order = nil, page_token = nil, published_after = nil, published_before = nil, q = nil, region_code = nil, related_to_video_id = nil, relevance_language = nil, safe_search = nil, topic_id = nil, type = nil, video_caption = nil, video_category_id = nil, video_definition = nil, video_dimension = nil, video_duration = nil, video_embeddable = nil, video_license = nil, video_syndicated = nil, video_type = nil, fields = nil, quota_user = nil, user_ip = nil, options = nil)
          builder.add("part", "id,snippet")
          builder.add("channelId", channel_id) if channel_id
          builder.add("order", order) if order
          builder.add("maxResults", max_results.to_s) if max_results
          builder.add("key", key)
          response = client.get("/youtube/v3/search?#{builder.to_s}")
          JSON.parse(response.body)
        end

      end
    end
  end
end