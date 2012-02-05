require 'bundler'
Bundler.require(:default)

require 'json'
require 'yajl'
require 'em-http/middleware/oauth'

tweets = {}

$stdout.sync = true

trap("INT") do
  $stderr.puts "Captured #{tweets.size} tweets"
  EM.stop
end

parser = Yajl::Parser.new #(:symbolize_keys => true)
parser.on_parse_complete = lambda do |tweet|
  if tweet["delete"]
    deleted_id = tweet["delete"]["status"]["id"]
    if deleted_tweet = tweets[deleted_id]
      #puts deleted_tweet.to_json
    end
  else
    tweet_id = tweet["id"]
    tweets[tweet_id] = tweet
    puts tweet.to_json
  end
  if tweets.size >= 100
    #EM.stop
  end
end

EM.run do
  # sign the request with OAuth credentials
  conn = EventMachine::HttpRequest.new('https://stream.twitter.com/1/statuses/sample.json')

  oauth_opts = YAML.load_file("config/oauth.yml").inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  conn.use EventMachine::Middleware::OAuth, oauth_opts

  http = conn.get
  http.stream do |chunk|
    parser << chunk
  end

  http.errback do
    puts "Failed retrieving user stream."
    pp http.response
    EM.stop
  end
end
