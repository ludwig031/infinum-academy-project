# frozen_string_literal: true

module WorldCup
  # WorldCup::Event class creates single instance of world cup event
  class Event
    attr_accessor :event_hash

    def initialize(event_hash)
      @event_hash = event_hash
    end

    def id
      event_hash['id']
    end

    def type
      event_hash['type']
    end

    def player
      event_hash['player']
    end

    def time
      event_hash['time']
    end

    def to_s
      # #id: type@time - player
      "##{id}: #{type}@#{time} - #{player}"
    end
  end
end
