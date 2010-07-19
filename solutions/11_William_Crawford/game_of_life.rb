class GameOfLife
	attr_reader :state, :width, :height

	def initialize n # added a argument for shoes visualization by ashbb
                debug '11' if $DEBUG # added for debug by ashbb
		@width = n # changed 5 to n for shoes visualization by ashbb
		@height = n # changed 5 to n for shoes visualization by ashbb
		@state = Array.new(@height).map! { Array.new(@width).map! { rand(2) } }
	end

	def evolve
		newstate = self.clone_state
		@state.each_index { |x| 
			@state[x].each_index { |y|
				newstate[x][y] = 0 if (self.neighbors?(x,y) < 2)
				newstate[x][y] = 1 if (self.neighbors?(x,y) == 3)
				newstate[x][y] = 0 if (self.neighbors?(x,y) > 3)
			}
		}

		@state = newstate
	end

	def state= state
		raise Exception, "State must be an array of arrays" unless state.kind_of? Array
		raise Exception, "State must be an array of arrays" unless state[0].kind_of? Array
		raise Exception, "State must have at least 1 column" unless state.size > 0
		raise Exception, "State must have at least 1 row" unless state[0].size > 0
		state.each { |x| 
			raise Exception, "State rows must be same length" unless (x.size == state[0].size)
			x.each { |y|
				raise Exception, "State values must be 0 or 1" unless ( (y==0) or (y==1) )
			}
		}
		@height = state.size
		@width = state[0].size
		@state = state
	end

	def neighbors? x, y
		top = x-1
		middle = x
		bottom = x+1
		left = y-1
		center = y
		right = y+1

		top += @height if (top < 0)
		bottom -= @height if (bottom >=@height)
		left += @width if (left < 0)
		right -= @width if (right >=@width)

		return 	state[top][left] +
				state[top][center] +
				state[top][right] +
				state[middle][left] +
				state[middle][right] +
				state[bottom][left] +
				state[bottom][center] +
				state[bottom][right]
	end

	def clone_state
		newstate = state.map { |x| x.map { |y| y } }
		return newstate
	end
end
