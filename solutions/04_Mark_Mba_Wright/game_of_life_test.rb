# This is a test file that uses the period-4 glider as a starting life form
require 'game_of_life.rb'
gol = GameOfLife.new
		
@state = Array.new(21) {|row| Array.new(21) {|cell| 0}}
@state[8][4] = 1
@state[9][5] = 1
@state[10][3] = 1
@state[10][4] = 1		
@state[10][5] = 1

gol.state = @state
(1..10).each do
	r = gol.evolve
end