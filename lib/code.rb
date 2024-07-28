require_relative 'game'

module Code
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
end
