require 'colorize'
require_relative 'human'
require_relative 'computer'
require_relative 'code'

class Game
  include Code
  ROLES = %i[guesser codemaker].freeze
  ROWS = 12
  ARROW = '⇩'.freeze
  BOARD_HEADER = ' _______________'.freeze
  BOARD_FOOTER = '|___|___|___|___|'.freeze

  @peg_list = [' ☻ ', ' • ', ' ➊ '].freeze
  @colors = %i[yellow blue red green white black].freeze

  class << self
    attr_reader :peg_list
  end

  class << self
    attr_reader :colors
  end

  def initialize(peg, role)
    @guesser = (role.zero? ? Human.new(ROLES[0]) : Computer.new(ROLES[0]))
    @codemaker = (role.zero? ? Computer.new(ROLES[1]) : Human.new(ROLES[1]))
    @play_count = 0
    @peg = Game.peg_list[peg]
    @board = Array.new(12) { { guesses: Array.new(4, nil), correct_place: 0, correct_color: 0 } }
  end

  def start_game
    code_combo = @codemaker.play
    loop do
      print_board
      # If all rows are full, game over
      if @play_count == 12
        puts "You lose! the code was #{code_to_pegs(code_combo, @peg)}"
        return
      end
      # else, continue game
      user_combo = @guesser.play
      return if check_win(code_combo, user_combo)

      update_board(@play_count, user_combo)
      @play_count += 1
    end
  end

  def check_win(code_combo, user_combo)
    return unless code_combo.eql? user_combo

    puts 'You won, you are a true mastermind!'
    puts "The code was : #{code_to_pegs(code_combo, @peg)}"
  end

  def update_board(row, combo)
    @board[row][:guesses] = combo
  end

  # Printing Logic
  def print_board
    print_board_header
    print_rows
    print_board_footer
    print_input_instructions
  end

  private

  def print_pegs
    Game.colors.each { |color| print @peg.colorize(color) }
    puts
  end

  def print_input_instructions
    puts
    print_pegs
    6.times { |index| print ' ⇩ '.colorize(Game.colors[index]) }
    puts
    6.times { |index| print " #{index + 1} ".colorize(Game.colors[index]) }
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
    color_number = @board[row][:guesses][column]
    if color_number.nil?
      ' ○ '.colorize(color: :grey,
                     mode: :bold)
    else
      @peg.colorize(
        color: number_to_color(color_number), mode: :bold
      )
    end
  end

  # Converting it to an integer in case it's nil
  def get_correct_places(row)
    ('✔ ' * @board[row][:correct_place].to_i).colorize(:red)
  end

  def get_correct_colors(row)
    ('✘ ' * @board[row][:correct_color].to_i).colorize(:white)
  end
end
