# frozen_string_literal: true

require 'discordrb'
require_relative 'realms'

bot = Discordrb::Commands::CommandBot.new(token: ENV['token'], channels: ['realm-closing'], prefix: '!')

messages = []

bot.command :start do |event|
  messages |= [bot.send_message(event.channel.id, Realms::scrap().join("\n"))]
  'I have been woken!'
end

bot.command :stop do |event|
  event.channel.delete_messages(event.channel.history(100))
  'Finally, I shall rest now.'
end

bot.run(true)

loop do
  messages.each do |message| 
    message.edit(Realms::scrap.join("\n"))
  end
  sleep 3
end