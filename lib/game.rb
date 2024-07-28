require 'colorize'

class Game
  COLORS = %i[yellow blue red green white black].freeze

  def initialize(peg)
    @play_count = 0
    @peg = peg
    @code = Array.new(4) { COLORS.sample } # Randomly select 4 colors
    @board = Array.new(12) { { guesses: Array.new(4, nil), correct_place: 0, correct_color: 0 } }
  end

  def print_board
    puts ' _______________'
    12.times do |row|
      puts "|#{get_peg(row, 0)}|#{get_peg(row, 1)}|#{get_peg(row, 2)}|#{get_peg(row, 3)}|#{get_correct_places(row)}  #{get_correct_colors(row)}" # rubocop:disable Layout/LineLength
    end
    puts '|___|___|___|___|'
  end

  private

  def get_peg(row, column)
    color = @board[row][:guesses][column]
    color.nil? ? ' ○ '.colorize(color: :grey, mode: :bold) : @peg.colorize(color: color, mode: :bold)
  end

  # Converting it to an integer in case it's nil
  def get_correct_places(row)
    ('✔ ' * @board[row][:correct_place].to_i).colorize(:red)
  end

  def get_correct_colors(row)
    ('✘ ' * @board[row][:correct_color].to_i).colorize(:white)
  end
end

game = Game.new('1')
game.print_board
