# google-api-client-cr

A Crystal client for the Google YouTube Data API v3, ported from [google-api-ruby-client](https://github.com/googleapis/google-api-ruby-client).

## Features

- YouTube Data API v3 full coverage (83 methods)
- Type-safe response models with `JSON::Serializable` (127 classes)
- API Key and OAuth2 authentication
- File upload (multipart) and download support

### Supported Resources

| Resource | list | insert | update | delete | Other |
|----------|------|--------|--------|--------|-------|
| Search | o | | | | |
| Videos | o | o | o | o | rate, getRating, reportAbuse, getTrainability |
| Channels | o | | o | | insertBanner |
| Playlists | o | o | o | o | |
| PlaylistItems | o | o | o | o | |
| PlaylistImages | o | o | o | o | |
| Comments | o | o | o | o | markAsSpam, setModerationStatus |
| CommentThreads | o | o | o | | |
| Subscriptions | o | o | | o | |
| Captions | o | o | o | o | download |
| ChannelSections | o | o | o | o | |
| Activities | o | | | | |
| LiveBroadcasts | o | o | o | o | bind, transition, insertCuepoint |
| LiveStreams | o | o | o | o | |
| LiveChatMessages | o | o | | o | transition, stream |
| LiveChatModerators | o | o | | o | |
| LiveChatBans | | o | | o | |
| Watermarks | | set | | unset | |
| Thumbnails | | set | | | |
| Members | o | | | | |
| MembershipsLevels | o | | | | |
| SuperChatEvents | o | | | | |
| VideoCategories | o | | | | |
| VideoAbuseReportReasons | o | | | | |
| ThirdPartyLinks | o | o | o | o | |
| AbuseReports | | o | | | |
| I18nLanguages | o | | | | |
| I18nRegions | o | | | | |

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  google-api-client-cr:
    github: masak1yu/google-api-client-cr
```

## Usage

### API Key (read-only public data)

```crystal
require "google-api-client-cr"

youtube = Google::Apis::YoutubeV3::YouTubeService.new
# Set API_KEY environment variable or:
# youtube.key = "YOUR_API_KEY"

# Search
results = youtube.list_searches("snippet", q: "Crystal programming", max_results: 5, type: "video")
results.items.try &.each do |item|
  puts "#{item.snippet.try &.title} (#{item.id.try &.video_id})"
end

# Video details
videos = youtube.list_videos("snippet,statistics", id: "VIDEO_ID")
videos.items.try &.each do |video|
  puts "#{video.snippet.try &.title}: #{video.statistics.try &.view_count} views"
end

# Channel info
channels = youtube.list_channels("snippet,statistics", for_username: "GoogleDevelopers")
channels.items.try &.each do |ch|
  puts "#{ch.snippet.try &.title}: #{ch.statistics.try &.subscriber_count} subscribers"
end

# Playlists
playlists = youtube.list_playlists("snippet", channel_id: "CHANNEL_ID", max_results: 10)
playlists.items.try &.each do |pl|
  puts pl.snippet.try &.title
end

# Comments
threads = youtube.list_comment_threads("snippet", video_id: "VIDEO_ID", max_results: 10)
threads.items.try &.each do |thread|
  comment = thread.snippet.try &.top_level_comment.try &.snippet
  puts "#{comment.try &.author_display_name}: #{comment.try &.text_display}"
end
```

### OAuth2 (authenticated operations)

```crystal
require "google-api-client-cr"

# 1. Create OAuth2 client
oauth = Google::Auth::OAuth2Client.new(
  client_id: ENV["CLIENT_ID"],
  client_secret: ENV["CLIENT_SECRET"]
)

# 2. Get authorization URL
url = oauth.authorization_url(scope: Google::Auth::Scopes::YOUTUBE)
puts "Visit: #{url}"

# 3. Exchange code for token
print "Enter code: "
code = gets.try(&.strip).not_nil!
oauth.authorize(code)

# 4. Use with service
youtube = Google::Apis::YoutubeV3::YouTubeService.new
youtube.authorize(oauth)

# Now you can use write operations
playlist = Google::Apis::YoutubeV3::Playlist.from_json(%({
  "snippet": { "title": "My Playlist", "description": "Created with Crystal" },
  "status": { "privacyStatus": "private" }
}))
created = youtube.insert_playlist("snippet,status", playlist)
puts "Created playlist: #{created.id}"
```

## Requirements

- Crystal >= 1.19.0

## License

MIT

## Contributors

- [masak1yu](https://github.com/masak1yu) - creator, maintainer
