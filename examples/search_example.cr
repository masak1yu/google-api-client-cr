require "../src/google-api-client-cr"

youtube = Google::Apis::YoutubeV3::YouTubeService.new

# Search for videos
results = youtube.list_searches("snippet", q: "Crystal programming language", max_results: 3, type: "video")

puts "=== Search Results ==="
results.items.try &.each do |item|
  puts "Title: #{item.snippet.try &.title}"
  puts "Channel: #{item.snippet.try &.channel_title}"
  puts "Video ID: #{item.id.try &.video_id}"
  puts "---"
end

puts "\nTotal results: #{results.page_info.try &.total_results}"
