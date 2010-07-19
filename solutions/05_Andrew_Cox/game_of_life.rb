# game_of_life.rb for Ruby Challenge - http://rubylearning.com/blog/2010/06/28/rpcfn-the-game-of-life-11/
# Andrew Cox
# 3coxy4@gmail.com

DEFAULT_SIZE = 5

class GameOfLife
	
  attr_reader :size

# init and randomize state
  def initialize(size = DEFAULT_SIZE)
    debug '05' if $DEBUG # added for debug by ashbb
    @size = size
    randomize_state
  end
  
# generate random state
  def randomize_state
    @cells = ([[0]*@size]*@size).map do |x|
      x.map{ Cell.new(rand.round) }
    end
    set_neighbours
  end
  
# set to specific state  
  def state=(state)
    @cells = state.map do |x| 
      x.map do |y|
        Cell.new(y) 
      end
    end
    set_neighbours
  end

# flatten cell array - useful for iterating through all cells
  def cells
    @cells.flatten
  end

# iterate through each cell with their x,y co-ordinates
  def each_cell_with_index(&block)
    @cells.each_with_index do |x,i| 
      x.each_with_index do |y,j|
        block.call(y,i,j)
      end
    end
  end
 
# evolve cells based on specific rules of the game 
  def evolve
    cells.each do |cell|
    # any life cell < 2 neighbours dies 
      cell.dead! if cell.alive? and cell.live_neighbours < 2
    # any life cell > 3 neighbours dies
      cell.dead! if cell.alive? and cell.live_neighbours > 3
    # any live cell with 2 or 3 neighbours lives to next generation
      # no action needed
    # any dead cell with exactly 3 live neighbours becomes a live cell
      cell.alive! if cell.dead? and cell.live_neighbours == 3
    end

  # propigate changes
    cells.each{|cell| cell.save_state! }
    state_as_int_array 
  end
    
  private
 
# calls 'state' method on each Cell 
  def state_as_int_array
    @cells.map{|r| r.map{|c| c.state } }
  end
  
  def maximum_index
    @size - 1
  end

# joins edges together so that the board folds onto itself
  def no_edges(n)
    n < 0 ? maximum_index : (n > maximum_index ? 0 : n)
  end

# works out all neighbours of a given point on the board
  def neighbours_of(x,y)
    [[x-1,y-1], [x,y-1], [x+1,y-1],
     [x-1,y ],           [x+1,y  ],
     [x-1,y+1], [x,y+1], [x+1,y+1]].map do |n| 
       @cells[no_edges(n[0])][no_edges(n[1])]
     end
  end

# loop through each Cell and set it's neighbours
  def set_neighbours
    each_cell_with_index do |cell,x,y|
      cell.neighbours = neighbours_of(x,y)
    end
  end

end

# Represents each 'cell' on the board
class Cell

  attr_accessor :state, :neighbours

  def initialize(state)
    @state = state
    @neighbours = []
  end

  def alive?
    @state == 1
  end

  def dead?
    @state == 0
  end

  def alive!
    @nextstate = 1
  end

  def dead!
    @nextstate = 0
  end

# update this Cell's current state with the next state after an evolution
  def save_state!
    @state = @nextstate || @state
  end
  
# counts all neighbours that are currently 'alive' - i.e. have a state of '1'
  def live_neighbours
    @neighbours.map{|c| c.state }.inject{|a,b| a + b }
  end

end