# This is the proposed solution to the contest: http://rubylearning.com/blog/2010/06/28/rpcfn-the-game-of-life-11/

# This class is a simulation of the game of life board game
class GameOfLife
	# The state describes the current board arrangement using an array of arrays
	attr_accessor :state
	def initialize (rows = 20, cols = 20) # replaced default value from 21 to 20 for shoes visualization by ashbb 
                debug '04' if $DEBUG # added for debug by ashbb
		@state = Array.new(rows) {|row| Array.new(cols) {|cell| 0}}
                (20 + rand(100)).times{@state[rand rows][rand cols] = 1} # added this line for shoes visualization by ashbb
	end
	
	# The evolve method simulates one more turn in the game of life
	def evolve
		# Check that the state is defined and that the first row has at least one cell/column
		unless @state.nil? or @state[0].length == 0
			new_state = Array.new(@state.length) {|row| Array.new(@state[0].length) { |cell| 0}}
		else
			return @state
		end
		
		# Iterate through each cell in the state (board) and determine how many neighbouring cells are alive
		@state.each_with_index do |row, row_index|
			row.each_with_index do |cell, cell_index|
				count = 0
				for i in -1..1
					for j in -1..1
						if row_index + i < 0
							r = @state.length - 1
						elsif row_index + i >= @state.length
							r = 0
						else
							r = row_index + i
						end
						
						if cell_index + j < 0
							c = row.length - 1
						elsif cell_index + j >= row.length
							c = 0
						else
							c = cell_index + j
						end
						
						if @state[r][c] == 1 
							if !(r == row_index and c == cell_index)
								count = count + 1
							end
						end
					end
				end
				
				# Based on the rules for the game of life
				# If a live cell has 2 or 3 live neighbours it lives another day
				# If a dead cell has 3 live neighbours it gets to be born (again)
				if @state[row_index][cell_index] == 1
					if (count < 2 or count > 3)
						new_state[row_index][cell_index] = 0
					else
						new_state[row_index][cell_index] = 1
					end
				else
					if count == 3
						new_state[row_index][cell_index] = 1
					end
				end
			end
		end
		@state = new_state
		return @state
	end
end