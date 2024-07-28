require_relative 'lib/game'

PEGS = ['☻', '•', '➊'].freeze
ROLES = %i[guesser codemaker].freeze

def print_peg_customization
  puts '__________Customization__________'
  puts ''
  puts 'Choose one of the pegs below :'
  puts '1. ☻'
  puts '2. •'
  puts '3. ➊'
  puts '_________________________________'
end

def print_role_choice
  puts '___________Role Choice___________'
  puts ''
  puts 'Choose one of the roles below :'
  puts '1. Guesser'
  puts '2. Codemaker'
  puts '_________________________________'
end

print_peg_customization
peg_choice = gets.to_i - 1
print_role_choice
game = Game.new(PEGS[peg_choice], ROLES[gets.to_i])
game.print_board
