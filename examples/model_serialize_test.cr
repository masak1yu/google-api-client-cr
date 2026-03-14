require "../src/google-api-client-cr"

# Test: Build model objects and serialize to JSON (for POST/PUT requests)

# Video object
video = Google::Apis::YoutubeV3::Video.from_json(%(
  {
    "snippet": {
      "title": "Test Video",
      "description": "A test video description",
      "categoryId": "22",
      "tags": ["test", "crystal"]
    },
    "status": {
      "privacyStatus": "private"
    }
  }
))

puts "=== Video JSON ==="
puts video.to_pretty_json
puts "Title: #{video.snippet.try &.title}"
puts "Tags: #{video.snippet.try &.tags}"

# Playlist object
playlist = Google::Apis::YoutubeV3::Playlist.from_json(%(
  {
    "snippet": {
      "title": "My Crystal Playlist",
      "description": "Created with Crystal API client"
    },
    "status": {
      "privacyStatus": "private"
    }
  }
))

puts "\n=== Playlist JSON ==="
puts playlist.to_pretty_json

# PlaylistItem
item = Google::Apis::YoutubeV3::PlaylistItem.from_json(%(
  {
    "snippet": {
      "playlistId": "PLxxxxxx",
      "resourceId": {
        "kind": "youtube#video",
        "videoId": "DxFP-Wjqtsc"
      }
    }
  }
))

puts "\n=== PlaylistItem JSON ==="
puts item.to_pretty_json
puts "Video ID: #{item.snippet.try &.resource_id.try &.video_id}"

# Round-trip test: parse API response -> modify -> serialize
puts "\n=== Round-trip Test ==="
api_response = %({"etag":"abc","items":[{"id":"vid1","snippet":{"title":"Original"}}],"kind":"youtube#videoListResponse","pageInfo":{"totalResults":1,"resultsPerPage":5}})
parsed = Google::Apis::YoutubeV3::ListVideosResponse.from_json(api_response)
puts "Parsed #{parsed.items.try &.size} video(s): #{parsed.items.try &.first.try &.snippet.try &.title}"
puts "Page info: #{parsed.page_info.try &.total_results} total"

puts "\nAll serialization tests passed!"
