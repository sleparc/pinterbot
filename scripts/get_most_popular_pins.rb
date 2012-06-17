require "rubygems"
require "active_support"
require "net/https"
require "uri"

def get_response(url)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)
  json_response =  response.body
end

json_response = get_response("https://api.pinterest.com/v2/popular/")
pins = ActiveSupport::JSON.decode(json_response)["pins"]

# most popular pins
pin_array = []
pins.each do |pin|
  id = pin["id"]
  username = pin["user"]["username"]
  score = pin["counts"]["repins"] * 3 + pin["counts"]["comments"] * 2 + pin["counts"]["likes"]
  img = pin["images"]["closeup"]
  pin_array << {:id => id, :username => username, :score => score, :img => img}
end

pins_sorted = pin_array.sort {|a,b| b[:score] <=> a[:score] }
puts pins_sorted.inspect


# most popular users
# NOT WORKING WELL YET
user_array = []
pins_sorted.each do |pin|
  username = pin[:username]
  json_response = get_response("https://api.pinterest.com/v2/users/#{username}/")
  user = ActiveSupport::JSON.decode(json_response)["user"]
  followers = user["stats"]["followers_count"]
  likes = user["stats"]["likes_count"]
  score = followers * 2 + likes
  user_array << {:username => username, :score => score}
end

users_sorted = user_array.sort {|a,b| b[:score] <=> a[:score] }
puts users_sorted.inspect
