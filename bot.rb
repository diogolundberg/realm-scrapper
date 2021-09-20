# frozen_string_literal: true

require 'discordrb'
require_relative 'realms'

bot = Discordrb::Commands::CommandBot.new(token: ENV['token'], channels: ['realm-closing'], prefix: 'scrapper ')

messages = []
def scrap()
  Realms::scrap.first(10).join("\n")
end

bot.command :start do |event|
  messages |= [bot.send_message(event.channel.id, scrap)]
  'I have been woken!'
end

bot.command :stop do |event|
  event.channel.delete_messages(event.channel.history(100))
  'Finally, I shall rest now.'
end

bot.run(true)

loop do
  sleep 3
  messages.each { |message| message.edit scrap }
end