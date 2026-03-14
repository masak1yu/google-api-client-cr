require "../src/google-api-client-cr"

youtube = Google::Apis::YoutubeV3::YouTubeService.new

# Video abuse report reasons (requires OAuth2)
puts "=== Video Abuse Report Reasons ==="
begin
  reasons = youtube.list_video_abuse_report_reasons("snippet", hl: "ja")
  reasons.items.try &.first(3).each do |reason|
    puts "#{reason.id}: #{reason.snippet.try &.label}"
  end
rescue e : Google::Apis::AuthorizationError
  puts "Correctly caught AuthorizationError (OAuth2 required)"
end

# Search still works with API key
puts "\n=== Search ==="
results = youtube.list_searches("snippet", q: "Crystal lang", max_results: 1, type: "video")
results.items.try &.each do |item|
  puts "#{item.snippet.try &.title}"
end

# Activities
puts "\n=== Activities ==="
activities = youtube.list_activities("snippet", channel_id: "UC_x5XG1OV2P6uZZ5FSM9Ttw", max_results: 2)
activities.items.try &.each do |act|
  puts "#{act.snippet.try &.type}: #{act.snippet.try &.title}"
end

# Channel sections
puts "\n=== Channel Sections ==="
sections = youtube.list_channel_sections("snippet", channel_id: "UC_x5XG1OV2P6uZZ5FSM9Ttw")
puts "#{sections.items.try &.size} sections found"

# Model serialization for new types
puts "\n=== New Model Serialization ==="
cuepoint = Google::Apis::YoutubeV3::Cuepoint.from_json(%({ "cueType": "cueTypeAd", "durationSecs": 30 }))
puts "Cuepoint: #{cuepoint.cue_type}, #{cuepoint.duration_secs}s"

tpl = Google::Apis::YoutubeV3::ThirdPartyLink.from_json(%({ "kind": "youtube#thirdPartyLink", "linkingToken": "abc123" }))
puts "ThirdPartyLink: #{tpl.kind}, token=#{tpl.linking_token}"

abuse = Google::Apis::YoutubeV3::VideoAbuseReport.from_json(%({ "videoId": "xxx", "reasonId": "R1", "comments": "test" }))
puts "AbuseReport JSON: #{abuse.to_json}"

puts "\nAll tests passed!"
