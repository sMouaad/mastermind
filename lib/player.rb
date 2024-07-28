require_relative 'code'

class Player
  attr_reader :role

  include Code

  def initialize(role)
    @role = role
  end

  def play; end
end
