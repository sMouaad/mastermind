require_relative 'player'
class Human < Player
  def play
    puts "Make your code ! (e.g: #{code_to_s(generate_random_code)})" if @role == :codemaker
    loop do
      code_combo = gets.chomp
      return code_combo.chars.map(&:to_i) if code_valid?(code_combo)

      puts 'Wrong choice, try again...'
    end
  end
end
