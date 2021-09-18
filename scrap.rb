require 'uri'
require 'net/http'
require "ostruct"

def realms()
  response = Net::HTTP.get(URI('https://realmstock.network/Public/EventHistory'))
  realms = response.split("\n").map do |line|
    data = line.split("|")
    player_count = data[3].to_i
    players = player_count > 85 ? 85 : player_count
    queue = player_count > 85 ? player_count - 85 : 0
    OpenStruct.new(name: data[1], server: data[2], players: players, queue: queue, events_left: data[4].to_i)
  end
  realms.uniq(&:name).sort_by(&:events_left)
end