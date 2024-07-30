require 'colorize'
require_relative 'human'
require_relative 'computer'
require_relative 'code'
require_relative 'clear_screen'
require_relative 'board'
# Game class containing game logic
class Game
  include Code
  include ClearScreen
  include Board

  ROLES = %i[guesser codemaker].freeze

  @rows = 12
  @peg_list = [' ☻ ', ' • ', ' ➊ '].freeze
  @peg = @peg_list[1]
  @colors = %i[yellow blue red green white black].freeze
  @play_count = nil
  @board = nil

  class << self
    attr_accessor :play_count, :board, :peg
    attr_reader :peg_list, :colors, :rows
  end

  # Returns the last guess
  def self.last_guess
    return nil if Game.play_count.zero?

    Game.board[Game.play_count - 1]
  end

  def initialize(peg, role) # rubocop:disable Metrics/AbcSize
    Game.play_count = 0
    Game.board = Array.new(12) { { guesses: Array.new(4, nil), correct_guesses: 0, correct_colors: 0 } }
    Game.peg = Game.peg_list[peg]
    @guesser = (role.zero? ? Human.new(ROLES[0]) : Computer.new(ROLES[0]))
    @codemaker = (role.zero? ? Computer.new(ROLES[1]) : Human.new(ROLES[1]))
    @code_combo = nil
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
    if Game.play_count == Game.rows
      puts "You lose! the code was #{code_to_pegs(@code_combo)}"
      return true
    end
    false
  end

  def check_win?(user_combo)
    if @code_combo.eql? user_combo
      print_board
      puts @guesser.is_a?(Human) ? 'You won, you are a true mastermind!' : 'Computer won!'
      puts "The code was : #{code_to_pegs(@code_combo)}"
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
end
