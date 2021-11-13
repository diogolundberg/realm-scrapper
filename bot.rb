# frozen_string_literal: true

require 'discordrb'
require 'json'
require_relative 'realms'

bot = Discordrb::Commands::CommandBot.new(token: ENV['token'], channels: ['realm-closing'], prefix: 'scrapper ')

messages = []
def scrap()
  realms = Realms::scrap
  return 'NOTIFIER OFFLINE!' if realms.empty?
  realms.first(10).join("\n")
end

def error(e)
  message = JSON.parse(e.response.body)
  "Error while sending message to discord: `#{message}`"
end

bot.command :start do |event|
  messages |= [bot.send_message(event.channel.id, scrap)]
  'I have been woken!'
rescue RestClient::BadRequest => e
  error e
end

bot.command :stop do |event|
  event.channel.delete_messages(event.channel.history(100))
  'Finally, I shall rest now.'
rescue RestClient::BadRequest => e
  error e
end

bot.command :ping do |event|
  'pong'
rescue RestClient::BadRequest => e
  error e
end

bot.run(true)

loop do
  sleep 3
  messages.each { |message| message.edit scrap }
end