require './lib/game'

describe Game do
  describe '#code_to_s' do
    it 'converts code to a string' do
      game = Game.new(0, 0)
      expect(game.code_to_s([1, 2, 3, 4])).to eql('1234')
    end
  end
  describe '#code_to_pegs' do
    it 'converts code to pegs' do
      game = Game.new(0, 0)
      expect(game.code_to_pegs([1, 2, 3, 4])).to eql([1, 2, 3, 4].map do |element|
                                                       Game.peg.colorize(Game.colors[element - 1])
                                                     end.join)
    end
  end
end
