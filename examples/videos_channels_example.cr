require "../src/google-api-client-cr"

youtube = Google::Apis::YoutubeV3::YouTubeService.new

# Get video details
puts "=== Video Details ==="
videos = youtube.list_videos("snippet,statistics,contentDetails", id: "DxFP-Wjqtsc")
videos.items.try &.each do |video|
  puts "Title: #{video.snippet.try &.title}"
  puts "Channel: #{video.snippet.try &.channel_title}"
  puts "Views: #{video.statistics.try &.view_count}"
  puts "Likes: #{video.statistics.try &.like_count}"
  puts "Duration: #{video.content_details.try &.duration}"
  puts "Tags: #{video.snippet.try &.tags.try &.first(3).join(", ")}"
end

# Get channel details
puts "\n=== Channel Details ==="
channels = youtube.list_channels("snippet,statistics", for_username: "GoogleDevelopers")
channels.items.try &.each do |channel|
  puts "Title: #{channel.snippet.try &.title}"
  puts "Description: #{channel.snippet.try(&.description).try &.[0..80]}"
  puts "Subscribers: #{channel.statistics.try &.subscriber_count}"
  puts "Videos: #{channel.statistics.try &.video_count}"
  puts "Views: #{channel.statistics.try &.view_count}"
end

# List video categories
puts "\n=== Video Categories (JP) ==="
categories = youtube.list_video_categories("snippet", region_code: "JP")
categories.items.try &.first(5).each do |cat|
  puts "#{cat.id}: #{cat.snippet.try &.title}"
end
