require './initialize.rb'

class MainContainer < Celluloid::Supervision::Container
  # The bitfinex actor blocks for now. We will have to convert the
  # api from EM to Celluloid
  supervise type: Exchanges::BitfinexActor, as: :bitfinex

  #supervise type: BookActor, as: :bitfinex_book
end


MainContainer.run

