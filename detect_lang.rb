require "bundler"
Bundler.require(:default)

require "json"

$stdin.each do |line|
  tweet = JSON.parse(line)
  lang = CLD.detect_language(tweet["text"])
  tweet["lang"] = lang
  puts tweet.to_json
end
