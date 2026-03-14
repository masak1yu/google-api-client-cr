require "../src/google-api-client-cr"

# OAuth2 authorization example
#
# Prerequisites:
#   1. Go to Google Cloud Console > APIs & Services > Credentials
#   2. Create an OAuth 2.0 Client ID (Desktop application)
#   3. Set CLIENT_ID and CLIENT_SECRET environment variables
#
# Usage:
#   CLIENT_ID="xxx" CLIENT_SECRET="yyy" crystal run examples/oauth2_example.cr

client_id = ENV["CLIENT_ID"]? || abort("Set CLIENT_ID environment variable")
client_secret = ENV["CLIENT_SECRET"]? || abort("Set CLIENT_SECRET environment variable")

oauth = Google::Auth::OAuth2Client.new(client_id, client_secret)

# Generate authorization URL
url = oauth.authorization_url(
  scope: Google::Auth::Scopes::YOUTUBE,
  redirect_uri: "urn:ietf:wg:oauth:2.0:oob"
)

puts "Open this URL in your browser:"
puts url
puts
print "Enter the authorization code: "
code = gets.try(&.strip)
abort("No code provided") unless code && !code.empty?

# Exchange code for token
token = oauth.authorize(code)
puts "Access token obtained: #{token[0..20]}..."

# Use with YouTube service
youtube = Google::Apis::YoutubeV3::YouTubeService.new
youtube.authorize(oauth)

# Now you can use authenticated endpoints
# Example: list your own channels
channels = youtube.list_channels("snippet", mine: true)
channels.items.try &.each do |channel|
  puts "Your channel: #{channel.snippet.try &.title}"
end
