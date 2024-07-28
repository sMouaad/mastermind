require_relative 'player'

class Computer < Player
  def play
    generate_random_code
  end
end
