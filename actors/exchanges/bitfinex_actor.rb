module Exchanges
  class BitfinexActor
    include Celluloid
    require 'bitfinex-api-rb'

    URL      = 'wss://api.bitfinex.com/ws/2'.freeze

    attr_reader :channel_id

    def initialize(pair = Symbols::Bitfinex::IOTAUSD, book_actor = nil)

      @message_count = 0
      @book_actor    = Celluloid::Actor[book_actor]
      @pair          = pair

      Bitfinex::Client.configure do |conf|
        conf.api_key = ENV["BFX_KEY"]
        conf.secret  = ENV["BFX_SECRET"]
        conf.websocket_api_endpoint = URL
        conf.use_api_v2
      end

      @client = Bitfinex::Client.new

      @client.listen_book(@pair) do |message|
        process_message message
      end

      puts "Now Listening for #{pair} orders.".green
      @client.listen!
    end

    private
    def process_message(message)
        if @message_count == 0
          @channel_id = message[0]
          message[1].each do |book_update|
            process_book_update book_update
          end
        else
          process_book_update message[1]
        end
        @message_count += 1
    end

    def process_book_update(book_update)
      price  = book_update[0]
      count  = book_update[1]
      volume = book_update[2]

      side   = volume >= 0 ? Symbols::BIDS : Symbols::ASKS
      volume = volume.abs

      if count == 0
        @book_actor.delete! price: price, side: side
      else
        if side == Symbols::BIDS
          @book_actor.add_bid! price: price, volume: volume
        elsif side == Symbols::ASKS
          @book_actor.add_ask! price: price, volume: volume
        end
      end
    end

  end
end
