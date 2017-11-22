require './initialize.rb'

class MainContainer < Celluloid::Supervision::Container
  # The bitfinex actor blocks for now. We will have to convert the
  # api from EM to Celluloid
  supervise type: BookActor, as: :bitfinex_ethusd_book, args: ['IOTUSD', 'bitfinex']
  supervise type: BookDisplayActor, as: :book_display, args: [[:bitfinex_ethusd_book]]

  supervise type: Exchanges::BitfinexActor, as: :bitfinex, args: ['IOTUSD', :bitfinex_ethusd_book]
end


MainContainer.run
