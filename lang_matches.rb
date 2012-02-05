require "bundler"
Bundler.require(:default)

require "json"

count = 0
matches = 0

$stdin.each do |line|
  tweet = JSON.parse(line)
  if tweet["lang"]["reliable"] or true
    match = tweet["user"]["lang"] == tweet["lang"]["code"]
    matches += 1 if match
    count += 1
  end
  puts "%d / %d" % [matches, count]
end
