####################################
# RCPFN 11: Game of Life 
# 
# Christopher Fortenberry
# 
# http://twitter.com/cpfortenberry
# http://github.com/CPFB
#
#
# NOTES
#
#   I went a little overboard with
# the tests. I'm hoping that I
# didn't overlook anything.
####################################

class GameOfLife
  attr_accessor :grid, :step
  attr_reader :rows, :columns
	
  def initialize(rows, columns = 20, seeds = 0) # added columns' default value for shoes visualization by ashbb
    debug '09' if $DEBUG # added for debug by ashbb
    # establish which cells get seeds (defaults to 1/4 the number of cells in the grid)
    number_of_cells = (rows * columns)
    seeds = (number_of_cells - (number_of_cells % 4)) / 4 if seeds == 0
    # build and shuffle seed_array
    seed_array = []
    seeds.times { seed_array << 1 }
    (number_of_cells - seeds).times { seed_array << 0 }
    seed_array = seed_array.sort_by { rand }
        
    # build grid for GameOfLife
    grid = []
    rows.times do
      row = []
      columns.times { row << seed_array.pop }
      grid << row
    end
    @grid = grid
    @step = 0
    @rows = rows
    @columns = columns
  end
	
  def evolve
    # evolved_array will store the new array after evolution
    evolved_array = []
	  
    # the upto loops grab the coordinates for each cell
    0.upto(@rows-1) do |x|
      new_row = []
      0.upto(@columns-1) do |y|
	# checks to see if the grabbed cell should evolve to living or dead
	living_cells = self.number_of_living_cells(x, y)
	if @grid[x][y] == 1
	  (living_cells == 2 || living_cells == 3) ? new_row << 1 : new_row << 0
        else
          living_cells == 3 ? new_row << 1 : new_row << 0
        end
      end
      evolved_array << new_row
    end	  
    @step += 1	  
    @grid = evolved_array
  end
  
  def state=(arrays)
    new_num_rows = arrays.size
    new_num_columns = arrays[0].size
    
    # check to make sure that the arrays given are in a rectangular shape
    arrays.each { |a| raise ArgumentError, "Game state must be in rectangular form" if a.size != new_num_columns }
    
    # set the variables
    @grid = arrays
    @step = 0
    @columns = new_num_columns
    @rows = new_num_rows
  end
 	
  # parameters are the coordinates for the cell
  def get_neighbors(row, col)
    # [ 
    #   [NW], [N], [NE],
    #   [W],       [E],
    #   [SW], [S], [SE]
    # ]
    [ 
      [x_coord(row-1),y_coord(col-1)], [x_coord(row-1),y_coord(col)], [x_coord(row-1),y_coord(col+1)],
      [x_coord(row),y_coord(col-1)],                                  [x_coord(row),y_coord(col+1)],
      [x_coord(row+1),y_coord(col-1)], [x_coord(row+1),y_coord(col)], [x_coord(row+1),y_coord(col+1)]
    ]
  end

  # makes sure that the coordinate is correct when adding or subtracting from the original
  def get_coordinate(value, array_size)
    return (array_size - 1) if value < 0
    return 0 if value >= array_size
    return value
  end
  
  # grabs x-coordinate
  def x_coord(value)
    get_coordinate(value, @rows)
  end
  
  # grabs y-coordinate
  def y_coord(value)
    get_coordinate(value, @columns)
  end
  
  # counts the number of living cells by finding the neighbors and counting them
  def number_of_living_cells(row, column)
    living_cells = 0
    get_neighbors(row, column).each { |x,y| living_cells += @grid[x][y] }
    return living_cells
  end

end
