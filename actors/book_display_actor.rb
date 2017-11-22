class BookDisplayActor
  include Celluloid

  def initialize(book_actors = [])
    @book_actors = []

    book_actors.each do |book_actor|
      @book_actors << Celluloid::Actor[book_actor]
    end

    print!
  end

  def print!
    @timer = every(1) {
      @book_actors.each do |b|
        system 'clear'
        puts "Exchange: #{b.exchange} :: Pair: #{b.pair}".blue
        puts "Current Ask: #{b.current_ask} from #{b.time_since_ask} seconds ago".red
        puts "Current Bid: #{b.current_bid} from #{b.time_since_bid} seconds ago".green
      end
    }
  end
end
