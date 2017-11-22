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
        puts b.book
      end
    }
  end
end
