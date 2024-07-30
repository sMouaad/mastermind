require 'colorize'
require_relative 'human'
require_relative 'computer'
require_relative 'code'
require_relative 'clear_screen'

class Game
  include Code
  include ClearScreen
  ROLES = %i[guesser codemaker].freeze
  ROWS = 12
  ARROW = ' ▼ '.freeze
  BOARD_HEADER = ' _______________'.freeze
  BOARD_FOOTER = '|___|___|___|___|'.freeze
  @peg_list = [' ☻ ', ' • ', ' ➊ '].freeze
  @colors = %i[yellow blue red green white black].freeze
  @play_count = nil
  @board = nil

  class << self
    attr_accessor :play_count, :board
    attr_reader :peg_list, :colors
  end

  # Returns the last guess
  def self.last_guess
    return nil if Game.play_count.zero?

    Game.board[Game.play_count - 1]
  end

  def initialize(peg, role) # rubocop:disable Metrics/AbcSize
    Game.play_count = 0
    Game.board = Array.new(12) { { guesses: Array.new(4, nil), correct_guesses: 0, correct_colors: 0 } }
    @guesser = (role.zero? ? Human.new(ROLES[0]) : Computer.new(ROLES[0]))
    @codemaker = (role.zero? ? Computer.new(ROLES[1]) : Human.new(ROLES[1]))
    @code_combo = nil
    @peg = Game.peg_list[peg]
  end

  def start_game
    @code_combo = @codemaker.play
    loop do
      print_board
      # If all rows are full, game over
      return if rows_full?

      # else, continue game
      user_combo = @guesser.play

      update_board(user_combo)
      return if check_win?(user_combo)

      Game.play_count += 1
    end
  end

  def rows_full?
    if Game.play_count == 12
      puts "You lose! the code was #{code_to_pegs(@code_combo, @peg)}"
      return true
    end
    false
  end

  def check_win?(user_combo)
    if @code_combo.eql? user_combo
      print_board
      puts 'You won, you are a true mastermind!'
      puts "The code was : #{code_to_pegs(@code_combo, @peg)}"
      return true
    end
    false
  end

  def update_board(user_combo)
    Game.board[Game.play_count][:guesses] = user_combo
    # to filter out correct guesses
    correct_guesses_and_colors = calculate_correct_guesses_and_colors(user_combo, @code_combo)
    Game.board[Game.play_count][:correct_guesses] = correct_guesses_and_colors[0]
    Game.board[Game.play_count][:correct_colors] = correct_guesses_and_colors[1]
  end

  # Printing Logic
  def print_board
    clear_screen
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
    puts ARROW.colorize(color: :grey, mode: :bold) * 6
    6.times { |index| print " #{index + 1} ".colorize(color: Game.colors[index], mode: :bold) }
    puts "  Make your guess ! #{Game.play_count.zero? ? "(e.g : #{code_to_s(generate_random_code)})" : ''}"
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
    color_number = Game.board[row][:guesses][column]
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
    ('✔ ' * Game.board[row][:correct_guesses].to_i).colorize(:red)
  end

  def get_correct_colors(row)
    ('✘ ' * Game.board[row][:correct_colors].to_i).colorize(:white)
  end
end
