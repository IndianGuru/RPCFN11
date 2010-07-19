require 'rubygems'

class GameOfLife
    attr_accessor :state, :tmp_state 
        
    def initialize(size)
      debug '08' if $DEBUG # added for debug by ashbb
      @size  = size
      @state = Array.new(@size){ Array.new @size }
      @size.times{ |row| @size.times{ |column| @state[row][column] = rand(2) } }
      @tmp_state = @state.clone
    end
	
   def evolve
     @state.each_index do |x| 
       @state[x].each_index do |y|
         minus_x = x - 1
     	 minus_y = y - 1
       	 plus_x  = x + 1
       	 plus_y  = y + 1
       	 plus_y  = 0 if plus_y >= @size
       	 plus_x  = 0 if plus_x >= @size
       	 live_neighbours = 0

	 live_neighbours += 1 if @state[minus_x][minus_y] == 1 
	 live_neighbours += 1 if @state[minus_x][y] == 1
	 live_neighbours += 1 if @state[minus_x][plus_y] == 1
	   			  
	 live_neighbours += 1 if @state[x][minus_y] == 1
	 live_neighbours += 1 if @state[x][plus_y] == 1
 
	 live_neighbours += 1 if @state[plus_x][minus_y] == 1
	 live_neighbours += 1 if @state[plus_x][y] == 1
	 live_neighbours += 1 if @state[plus_x][plus_y] == 1
 			 
	 case live_neighbours
       	   when 0..1  then @tmp_state[x][y] = 0
       	   when 3     then @tmp_state[x][y] = 1
	   when 4..90 then @tmp_state[x][y] = 0
       	 end
       end
     end
     @state = @tmp_state.clone
   end
end