module Code
  def code_valid?(code)
    code.match?(/^\d{4}$/) && code.chars.all? { |element| element.to_i.between?(1, 6) }
  end

  def generate_random_code
    Array.new(4) { (1..6).to_a.sample }
  end
end
