require 'game_of_life.rb'

class GameBoard < Processing::App
	def setup
		# Setup processing's board
		size 800, 800
		background 0
		no_stroke
		smooth
		@rotation = 0	
		@GOL = GameOfLife.new(5,5)
		generic_case
		@cell_size = 750/(@GOL.state.length)
	end
	
	def draw
		@GOL.state.each_with_index do |row, row_index|
			row.each_with_index do |cell, cell_index|
				if cell == 0 then fill(250) else fill(0,250,0) end
				rect( 5+row_index * (@cell_size+5), 5+cell_index * (@cell_size+5), @cell_size, @cell_size)
			end
		end
	end
	
	def mouse_pressed
		@GOL.evolve
	end
	
	def generic_case
		@GOL.state = Array.new(21) {|row| Array.new(21) {|cell| 0}}
		@GOL.state[8][4] = 1
		@GOL.state[9][5] = 1
		@GOL.state[10][3] = 1
		@GOL.state[10][4] = 1		
		@GOL.state[10][5] = 1
	end
end

GameBoard.new :title => "Game of Life - Click to evolve..."