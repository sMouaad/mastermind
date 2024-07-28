require 'colorize'
require_relative 'human'
require_relative 'computer'
require_relative 'code'

class Game
  include Code

  COLORS = %i[yellow blue red green white black].freeze
  ROWS = 12
  ARROW = '⇩'.freeze
  BOARD_HEADER = ' _______________'.freeze
  BOARD_FOOTER = '|___|___|___|___|'.freeze
  def initialize(peg, role)
    @player = Human.new(role)
    @computer = Computer.new(:codemaker)
    @play_count = 0
    @peg = peg
    @code = Array.new(4) { COLORS.sample } # Randomly select 4 colors
    @board = Array.new(12) { { guesses: Array.new(4, nil), correct_place: 0, correct_color: 0 } }
  end

  def print_board
    print_board_header
    print_rows
    print_board_footer
    print_input_instructions
  end

  private

  def print_pegs
    COLORS.each { |color| print "#{@peg.colorize(color)} " }
    puts
  end

  def print_input_instructions
    print_pegs
    6.times { |index| print '⇩  '.colorize(COLORS[index]) }
    puts
    6.times { |index| print "#{index + 1}  ".colorize(COLORS[index]) }
    puts "  Make your guess ! #{@play_count.zero? ? "(e.g : #{generate_random_code.join})" : ''}"
  end

  def print_board_header
    puts BOARD_HEADER
  end

  def print_board_footer
    puts BOARD_FOOTER
  end

  def print_rows
    ROWS.times do |row|
      puts "|#{get_peg(row, 0)}|#{get_peg(row, 1)}|#{get_peg(row, 2)}|#{get_peg(row, 3)}|#{get_correct_places(row)}  #{get_correct_colors(row)}" # rubocop:disable Layout/LineLength
    end
  end

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

game = Game.new('➊ ', :guesser)
game.print_board
