require_relative 'player'
require_relative 'game'

class Computer < Player
  def play
    if @role == :codemaker
      generate_random_code
    elsif (last_guess = Game.last_guess).nil?
      [1, 1, 2, 2] # First guess
    else
      Code.set = Code.set.select do |code|
        calculate_correct_guesses_and_colors(s_to_code(code),
                                             last_guess[:guesses]) == [last_guess[:correct_guesses],
                                                                       last_guess[:correct_colors]]
      end
      sleep 2
      s_to_code(Code.set[0])
    end
  end
end
