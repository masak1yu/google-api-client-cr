require "../src/google-api-client-cr"

youtube = Google::Apis::YoutubeV3::YouTubeService.new

# Activities for a channel
puts "=== Activities (Google Developers) ==="
activities = youtube.list_activities("snippet", channel_id: "UC_x5XG1OV2P6uZZ5FSM9Ttw", max_results: 3)
activities.items.try &.each do |act|
  puts "#{act.snippet.try &.type}: #{act.snippet.try &.title}"
  puts "  #{act.snippet.try &.published_at}"
end

# Channel sections
puts "\n=== Channel Sections (Google Developers) ==="
sections = youtube.list_channel_sections("snippet,contentDetails", channel_id: "UC_x5XG1OV2P6uZZ5FSM9Ttw")
sections.items.try &.first(3).each do |section|
  puts "#{section.snippet.try &.type}: #{section.snippet.try &.title}"
  playlists = section.content_details.try &.playlists
  puts "  Playlists: #{playlists.try &.first(2).join(", ")}" if playlists
end

# Captions for a video
puts "\n=== Captions ==="
begin
  captions = youtube.list_captions("snippet", "DxFP-Wjqtsc")
  captions.items.try &.each do |cap|
    puts "#{cap.snippet.try &.language}: #{cap.snippet.try &.name} (#{cap.snippet.try &.track_kind})"
  end
rescue e : Google::Apis::Error
  puts "Captions require OAuth2: #{e.message.try &.[0..60]}"
end

puts "\nPhase 3 tests complete!"
