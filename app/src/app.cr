require "kemal"
require "dotenv"

Dotenv.load

require "./initializers/**"
require "./models/**"
require "./api/*"


add_handler TravelStopsHandler.new

puts "Kemal app is up and running!"
Kemal.run
