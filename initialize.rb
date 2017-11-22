$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'actors' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'actors/exchanges' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'lib' ) )

require 'dotenv/load'
require 'celluloid/current'
require 'celluloid/io'
require 'bitfinex_actor'
require 'book_actor'
require 'book_display_actor'
require 'colorize'
require 'symbols'
