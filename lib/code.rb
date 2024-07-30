require_relative 'game'

module Code
  @code_set = (1..6).to_a.repeated_permutation(4).to_a.map(&:join)
  def self.set
    @code_set
  end

  def self.set=(new_set)
    @code_set = new_set
  end

  def code_valid?(code)
    code.match?(/^[1-6]{4}$/)
  end

  def generate_random_code
    Array.new(4) { (1..6).to_a.sample }
  end

  def number_to_color(number)
    Game.colors[number - 1]
  end

  def code_to_pegs(number, peg)
    Array.new(4) { |index| peg.colorize(number_to_color(number[index])) }.join
  end

  def code_to_s(code)
    code.join
  end

  def s_to_code(string)
    string.chars.map(&:to_i)
  end

  def filter_correct_guesses(code_to_filter, code_filter)
    code_to_filter.filter_map.with_index do |element, index|
      element if code_to_filter[index] != code_filter[index]
    end
  end

  # returns [correct_guesses, correct_colors]
  def calculate_correct_guesses_and_colors(user_code, game_code)
    filtered_user = filter_correct_guesses(user_code, game_code)
    filtered_code = filter_correct_guesses(game_code, user_code)

    # I don't know how to explain this, but I came up with this by trying combinations and looking for a pattern
    correct_colors = filtered_user.uniq.sum do |value|
      ([filtered_code.count(value),
        filtered_user.count(value)].min % ([filtered_code.count(value), filtered_user.count(value)].max + 1))
    end
    [4 - filtered_user.size, correct_colors]
  end
end
