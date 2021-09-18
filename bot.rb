# frozen_string_literal: true

require 'discordrb'
require 'uri'
require 'net/http'
require "ostruct"
require_relative 'scrap.rb'

bot = Discordrb::Bot.new(token: ENV['token'])
puts "invite URL is #{bot.invite_url}"

bot.message(content: 'where is oryx?') do |event|
  message = realms.map do |realm|
    events = realm.events_left > 0 ? "`#{realm.events_left} remaining`" : "`closed`"
    queue = realm.queue > 0 ? "+ #{realm.queue}" : ""
    "#{events} - Server: **#{realm.server}**  Realm: **#{realm.name}**(#{realm.players}/85) #{queue}"
  end.join("\n")

  event.respond message
end

bot.run