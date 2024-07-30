require_relative 'player'
require_relative 'board'

# Class that handles playing logic for humans
class Human < Player
  include Board
  def play
    if @role == :codemaker
      print_input_instructions
      puts "    Make your code ! (e.g: #{code_to_s(generate_random_code)})"
    end
    loop do
      code_combo = gets.chomp
      return s_to_code(code_combo) if code_valid?(code_combo)

      puts 'Wrong choice, try again...'
    end
  end
end
