class BookActor
  include Celluloid

  attr_reader :book
  attr_reader :sorted_prices
  attr_reader :pair
  attr_reader :last_bid_update
  attr_reader :last_ask_update

  def initialize(pair)
    @book = {
      bids:  {},
      asks:  {},
    }

    @sorted_prices = {
      bids: [],
      asks: [],
    }

    @last_bid_update = 0
    @last_ask_update = 0

    @pair = pair
  end

  def time_since_ask
    Time.now.to_i - last_ask_update
  end

  def time_since_bid
    Time.now.to_i - last_bid_update
  end

  def current_ask
    @sorted_prices[:asks][0]
  end

  def current_bid
    @sorted_prices[:bids][0]
  end

  def add_bid!(price:, volume:)
    @book[:bids][price] = volume
    sort_bids!
    @last_bid_update = Time.now.to_i
  end

  def add_ask!(price:, volume:)
    @book[price] = volume
    sort_asks!
    @last_ask_update = Time.now.to_i
  end

  def delete!(side:, price:)
    @book[side].delete(price)
    sort! side
  end

  private
  def sort!(side)
    if side == Symbols::BIDS
      sort_bids!
    elsif side == Symbols::ASKS
      sort_asks!
    end
  end

  def sort_bids!
    @sorted_prices[:bids] = @book[:bids].keys.sort
  end

  def sort_asks!
    @sorted_prices[:asks] = @book[:bids].keys.sort.reverse
  end
end
