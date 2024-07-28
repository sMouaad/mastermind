require_relative 'lib/game'

PEGS = ['☻', '•', '➊'].freeze

puts '__________Customization__________'
puts ''
puts 'Choose one of the pegs below :'
puts '1. ☻'
puts '2. •'
puts '3. ➊'
puts '_________________________________'

game = Game.new(PEGS[gets.chomp.to_i - 1])
game.print_board
