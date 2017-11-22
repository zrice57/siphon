class BookActor
  include Celluloid

  attr_reader :book
  attr_reader :sorted_prices
  attr_reader :pair

  def initialize(pair)
    @book = {
      bids:  {},
      asks:  {},
    }

    @sorted_prices = {
      bids: [],
      asks: [],
    }

    @pair = pair
  end

  def add_bid!(price:, volume:)
    @book[:bids][price] = volume
    sort_bids!
  end

  def add_ask!(price:, volume:)
    @book[price] = volume
    sort_asks!
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
