# Monkey patch to add .x/.y shorthand and wrapping positive indices to Array
class Array
	# Lets me reference arrays as <array>.x/<array>.y for readability.
	def x; self[0]; end
	def y; self[1]; end
	
	# Replace Array#[] with a version that wraps positive indices
	alias :old_get :[]
	
	def [](a,b=nil)
		a = a - self.size if a.respond_to?(:>=) and a >= self.size
		self.send( :old_get, *(b.nil? ? [a] : [a,b]) )
	end
end

# Implements Conway's Game of Life
class GameOfLife
	attr_writer :state
	
	# List of offset tuples describing where to find a point's neighbors
	Neighbors = [-1,0,1].map { |x| [-1,0,1].zip Array.new(3,x) }.flatten(1).reject { |x| x == [0,0] }
	
	# Create a new GoL with the width & height of size, setting each cell 
	# alive/dead according to a probability (0.0 = no live cells; 1.0 = all live cells)
	def initialize(size,probability=rand)
                debug '02' if $DEBUG # added for debug by ashbb
		# Create an empty world with dimensions +size+
		# and set cells according to +probability+
		self.state = (1..(size)).map { |r| Array.new(size,0).map { |y| (rand+probability).to_i } }
	end
	
	def evolve
		# Make next generation world
		nextgen = (0..(@state.size-1)).map { |r| @state[r].dup }

		# Set next generation world according to GoL rules
		(0..(@state.size-1)).each do |y|
			(0..(@state[0].size-1)).each do |x|
				# Count how many of this cell's neighbors are alive
				neighborhood = Neighbors.inject(0) { |s,offset| s += @state[y+offset.y][x+offset.x] }
				alive = @state[y][x] == 1
				
				nextgen[y][x] = 0 if alive and (neighborhood < 2 or neighborhood > 3)
				nextgen[y][x] = 1 if not alive and neighborhood == 3
			end
		end
		
		# Update the world with the next generation
		@state = nextgen
	end
end