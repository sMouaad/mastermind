require_relative 'lib/game'
require_relative 'lib/clear_screen'

def set_peg # rubocop:disable Metrics/MethodLength
  puts '__________Customization__________'
  puts ''
  puts 'Choose one of the pegs below :'
  puts '1. ☻'
  puts '2. •'
  puts '3. ➊'
  puts '_________________________________'
  loop do
    peg_choice = gets.to_i
    return peg_choice - 1 if peg_choice.between?(1, Game.peg_list.size)

    puts 'Wrong choice, choose again : '
  end
end

def set_role # rubocop:disable Metrics/MethodLength
  ClearScreen.clear_screen
  puts '___________Role Choice___________'
  puts ''
  puts 'Choose one of the roles below :'
  puts '1. Guesser'
  puts '2. Codemaker'
  puts '_________________________________'
  loop do
    role_choice = gets.to_i
    return role_choice - 1 if role_choice.between?(1, 2)

    puts 'Wrong choice, choose again : '
  end
end

game = Game.new(set_peg, set_role)
game.start_game
