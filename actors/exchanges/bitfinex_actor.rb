module Exchanges
  class BitfinexActor
    include Celluloid
    require 'bitfinex-api-rb'

    URL     = 'wss://api.bitfinex.com/ws/2'.freeze
    IOTAUSD = 'tIOTAUSD'.freeze
    ETHUSD  = 'tETHUSD'.freeze

    attr_reader :channel_id

    def initialize(pair = ETHUSD, book_actor = nil)

      @message_count = 0
      @book_actor    = book_actor

      Bitfinex::Client.configure do |conf|
        conf.api_key = ENV["BFX_KEY"]
        conf.secret  = ENV["BFX_SECRET"]
        conf.websocket_api_endpoint = URL
        conf.use_api_v2
      end

      @client = Bitfinex::Client.new

      @client.listen_book(ETHUSD) do |message|
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

        puts message.inspect.blue
        @message_count += 1
    end

    def process_book_update(book_update)

    end
  end
end
