class BookActor
  include Celluloid

  attr_reader :book
  attr_reader :pair

  def initialize(pair)
    @book = {
      bids:  {},
      asks:  {},
      psnap: {},
    }

    @pair = pair
  end

  def add_bid()
  end


end
