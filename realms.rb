module Realms
  class Realm
    attr_accessor :name,  :server,  :total_players, :events_left, :updated_at
    
    def initialize(params)
      params.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def to_s()
      "`#{events}` - Server: **#{server}**  Realm: **#{name}**(#{players}/85) #{queue}"
    end

    def players()
      total_players > 85 ? 85 : total_players
    end

    def events()
      events_left > 0 ? "#{events_left} remaining" : "closed"
    end

    def queue()
      @queue ||= total_players > 85 ? total_players - 85 : 0
      @queue > 0 ? "+ #{@queue}" : ""
    end
    
    def updated_at()
      time = Time.now.utc
      Time.utc(time.year, time.month, time.day, @updated_at[0], @updated_at[1], 00)
    end

    def age()
      Time.now.utc - updated_at
    end
  end

  def self.scrap()
    response = Net::HTTP.get(URI('https://realmstock.network/Public/EventHistory'))

    realms = response.split("\n").map do |line|
      data = line.split('|')
      Realm.new(
        name: data[1], 
        server: data[2], 
        total_players: data[3].to_i, 
        events_left: data[4].to_i,
        updated_at: data[5].split(':')
      )
    end

    realms
      .uniq{ |realm| [realm.name, realm.server] }
      .sort_by(&:events_left)
      .select { |realm| realm.events != "closed" }
  end
end