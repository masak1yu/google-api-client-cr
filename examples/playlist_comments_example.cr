require "../src/google-api-client-cr"

youtube = Google::Apis::YoutubeV3::YouTubeService.new

# List playlists for a channel
puts "=== Playlists (Google Developers) ==="
playlists = youtube.list_playlists("snippet,contentDetails", channel_id: "UC_x5XG1OV2P6uZZ5FSM9Ttw", max_results: 3)
playlists.items.try &.each do |pl|
  puts "#{pl.snippet.try &.title} (#{pl.content_details.try &.item_count} items)"
  puts "  ID: #{pl.id}"
end

# List playlist items
first_playlist_id = playlists.items.try &.first.try &.id
if pid = first_playlist_id
  puts "\n=== Playlist Items ==="
  items = youtube.list_playlist_items("snippet", playlist_id: pid, max_results: 3)
  items.items.try &.each do |item|
    puts "#{item.snippet.try &.position}: #{item.snippet.try &.title}"
    puts "  Video ID: #{item.snippet.try &.resource_id.try &.video_id}"
  end
end

# List comment threads for a video
puts "\n=== Comment Threads ==="
threads = youtube.list_comment_threads("snippet,replies", video_id: "DxFP-Wjqtsc", max_results: 3)
threads.items.try &.each do |thread|
  comment = thread.snippet.try &.top_level_comment.try &.snippet
  puts "#{comment.try &.author_display_name}: #{comment.try(&.text_display).try &.[0..60]}"
  puts "  Likes: #{comment.try &.like_count}, Replies: #{thread.snippet.try &.total_reply_count}"
end

# I18n languages
puts "\n=== I18n Languages (first 5) ==="
langs = youtube.list_i18n_languages("snippet", hl: "ja")
langs.items.try &.first(5).each do |lang|
  puts "#{lang.snippet.try &.hl}: #{lang.snippet.try &.name}"
end
