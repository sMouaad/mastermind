require_relative 'game'
require_relative 'code'
require_relative 'clear_screen'

# Board module to handle printing board logic
module Board
  include Code
  include ClearScreen

  ARROW = ' ▼ '.freeze
  BOARD_HEADER = ' _______________'.freeze
  BOARD_FOOTER = '|___|___|___|___|'.freeze

  def print_pegs
    Game.colors.each { |color| print Game.peg.colorize(color) }
    puts
  end

  def print_board
    ClearScreen.clear_screen
    print_board_header
    print_rows
    print_board_footer
    print_input_instructions
    print_guess_example
  end

  def print_input_instructions
    puts
    print_pegs
    puts ARROW.colorize(color: :grey, mode: :bold) * 6
    6.times { |index| print " #{index + 1} ".colorize(color: Game.colors[index], mode: :bold) }
  end

  def print_guess_example
    puts "  Make your guess ! #{Game.play_count.zero? ? "(e.g : #{code_to_s(generate_random_code)})" : ''}"
  end

  def print_board_header
    puts BOARD_HEADER
  end

  def print_board_footer
    puts BOARD_FOOTER
  end

  def print_rows
    Game.rows.times do |row|
      puts "|#{get_peg(row, 0)}|#{get_peg(row, 1)}|#{get_peg(row, 2)}|#{get_peg(row, 3)}|#{get_correct_places(row)}  #{get_correct_colors(row)}" # rubocop:disable Layout/LineLength
    end
  end

  def get_peg(row, column)
    color_number = Game.board[row][:guesses][column]
    if color_number.nil?
      ' ○ '.colorize(color: :grey,
                     mode: :bold)
    else
      Game.peg.colorize(
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
