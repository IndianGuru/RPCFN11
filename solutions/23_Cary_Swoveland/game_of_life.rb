#!/usr/bin/ruby
# Ruby 1.8.7
# Cary Swoveland

require 'set'

MIN_ROWS = 20 # edited for shoes visualization by ashbb
MAX_ROWS = 20
MIN_COLS = 20 # edited for shoes visualization by ashbb
MAX_COLS = 20

AVG_DENSITY = 0.6
RANDOM_NUMBER_SEED = 123
USE_STARTING_SEED = false # Set to true for repeatability.

# Add helpers to Array
class Array
  def row() self[0] end # for cell [r,c]
  def col() self[1] end # for cell [r,c]
end

class GameOfLife
  # Public methods are evolve() and display().

  attr_accessor :state # Needed for challenge testing only

  def initialize(n, topology = :TORUS) # added dummy argument n for shoes visualization by ashbb
    # Determine @nrows, @ncols, @living
    initial_random_state(topology)        

    # @topo provides rules for the topology of the grid on which the game
    # is played; specifically, the topology determines which cells are
    # adjacent to cells located along the four boundaries of the grid.
    @topo = create_topo(topology)

    @state = [] # For challenge testing only
    update_state_for_challenge() # Required only for challenge testing
  end

  def evolve(iterations = 1)
    # Assume challenge testing changed @state since evolve() last messaged
    update_size_and_living_for_challenge()
    evolve_once() while (iterations -= 1) >= 0
    update_state_for_challenge()
    @state # for challenge
  end

  def display(comment = '')
    puts; puts comment
    # Construct grid with living ('X') and dead ('.') cells
    grid = array_of_strings(@nrows, @ncols, '.') # Default all cells dead
    # Each cell [r,c] in @living is represented by 'X' in row r, column c 
    # of the pic it displays. First identify the living cells.
    @living.each {|cell| grid[cell[0]][cell[1]] = 'X'}

    # Add a vertical bar at beginning and end of each row.
    grid.map! {|row| '|' << row << '|'}

    # Make a horizontal border and add it to the bottom.
    grid << (border = '+' + '-' * @ncols + '+')

    # Add the border to the top.
    (grid.reverse! << border).reverse!
    puts grid
  end

  private

  #++++++++ private for initialize() +++++++++

  def initial_random_state(topology)
    srand RANDOM_NUMBER_SEED if USE_STARTING_SEED
    @living = []
    @nrows = random_in_range(MIN_ROWS, MAX_ROWS)
    # Grid must be square for :SPHERE topology
    @ncols = (topology == :SPHERE) ? @nrows : random_in_range(MIN_COLS, MAX_COLS)  
    @nrows.times {|r| @ncols.times {|c| @living << [r,c] if rand() < AVG_DENSITY}}
  end

  def random_in_range(min, max) min + rand(max-min+1) end

  def create_topo(topology)
    return topo = case(topology)
      when :OASIS then Oasis.new @nrows, @ncols
      when :CYLINDER then  Cylinder.new @nrows, @ncols # Rows wrap
      when :TORUS then Torus.new @nrows, @ncols # < Cylinder & cols wrap
      when :MOBIUS then Mobius.new @nrows, @ncols # Rows wrap with twist
      when :KLEIN then Klein.new @nrows, @ncols # Mobius + cols wrap
      when :PROJECTIVE then Projective.new @nrows, @ncols # < Mobius + cols wrap with twist
      when :SPHERE then Sphere.new @nrows, @ncols # See class Topology
      else raise "#{topology} is unknown topology"
    end
  end

  #++++++++ private for evolve() +++++++++

  def evolve_once
    living_after_evolve = []
    @nrows.times do |r|
      @ncols.times {|c| living_after_evolve << [r,c] if alive_after_evolve?([r,c])}
    end
    @living = living_after_evolve
  end  
    
  def alive_after_evolve?(cell)
    n = nliving_neighbors(cell)
    alive?(cell) ? (n==2||n==3) : n==3
  end
  
  def nliving_neighbors(cell) 
    neighbors = @topo.neighbors(cell) # Array
    (neighbors.select {|cell| alive?(cell)}).size
  end

  def alive?(cell) @living.include?(cell) end

  def two_dim_array(nrows, ncols, init_val = 0)
    Array.new(nrows).map! {Array.new(ncols, init_val)}
  end
    
  # *** Required only for Challenge Testing *** 
  def update_size_and_living_for_challenge()
    @nrows = @state.size; @ncols = @state[0].size
    state_to_living()
    @topo.save_grid_size(@nrows, @ncols)
  end  

  def state_to_living()
    @living = []
    @nrows.times {|r| @ncols.times {|c| @living << [r,c] if @state[r][c] == 1}}
  end

  def update_state_for_challenge()
    @state = two_dim_array(@nrows, @ncols, 0)
    @living.each {|cell| @state[cell[0]][cell[1]] = 1}
  end
  # *******************************************

  #++++++++ private for display() +++++++++
  def array_of_strings(a_size, s_size, char = '')
    s = ""; s_size.times {s << char}
    Array.new(a_size).map! {s.dup}
  end

end # GameOfLife 

#----- (class divider) -----

class Topology

# neighbors() is only public method.

=begin
Topology descendants:
                       Topology
  ________________________|__________________________
  |               |                |               |
Oasis          Cylinder          Mobius          Sphere
                  |       _________|________                  
                Torus     |               |
                        Klein         Projective               
=end

  def initialize(nrows, ncols) save_grid_size(nrows, ncols) end
        
  # save_grid_size() called by initialize() and update_before_for_challenge().
  def save_grid_size(nrows, ncols) @last_row = nrows-1; @last_col = ncols-1  end

  def neighbors(cell)
    ne = Set.new
    ne << left(cell) if left(cell)
    ne << right(cell) if right(cell)
    ne << up(cell) if up(cell)
    ne << down(cell) if down(cell)
    # Note: for some topologies and boundary cells (e.g. Projective corner cells),
    # left(up(cell)) != up(left(cell)). This applies for all methods below.
    ne << left_up(cell) if left_up(cell)
    ne << right_up(cell) if right_up(cell)
    ne << left_down(cell) if left_down(cell)
    ne << right_down(cell) if right_down(cell)
    ne.to_a.sort
  end

  private
  
  # Boundary default is cannot go up from the last row, down from the
  # first row, left from the first column or right from the last column
  def up(cell) cell.row < @last_row ? [cell.row+1, cell.col] : nil end
  def down(cell) cell.row > 0 ? [cell.row-1, cell.col] : nil end
  def left(cell) cell.col > 0 ? [cell.row, cell.col-1] : nil end
  def right(cell) cell.col < @last_col ? [cell.row, cell.col+1] : nil end
  def left_up(cell) (c = up(cell)) ? left(c): nil end
  def right_up(cell) (c = up(cell)) ? right(c): nil end
  def left_down(cell) (c = down(cell)) ? left(c): nil end
  def right_down(cell) (c = down(cell)) ? right(c): nil end

  # Following two methods messaged from Torus and Klein classes.
  def wrap_up_same_col(cell) [0, cell.col] end
  def wrap_down_same_col(cell) [@last_row, cell.col] end

end # class Topology

#---------------------------
# Oasis: An alias for Topology

class Oasis < Topology
end

#---------------------------
# Cylinder: cannot move beyond first and last rows, wraps over
# first and last columns, row i to row i.

class Cylinder < Topology
  def left(cell) cell.col == 0 ? [cell.row, @last_col] : super(cell) end
  def right(cell) cell.col == @last_col ? [cell.row, 0] : super(cell) end
end

#---------------------------
# Torus: same as cylinder except also wraps over first and last
# rows, column j to column j.

class Torus < Cylinder
  # Override up() and down() in Topology
  def up(cell) cell.row == @last_row ? wrap_up_same_col(cell) : super(cell) end
  def down(cell) cell.row == 0 ? wrap_down_same_col(cell) : super(cell) end
end

#---------------------------
# Mobius: cannot move beyond first and last rows, wraps over first
# and last columns, from row i to row @last_row-i (inverted rows).

class Mobius < Topology
  def left(cell) cell.col == 0 ? [@last_row-cell.row, @last_col] : super(cell) end
  def right(cell) cell.col == @last_col ? [@last_row-cell.row, 0] : super(cell) end
end

#---------------------------
# Projective: same as Mobius except also wraps over first and last
# rows, column j to column @last_col-j (inverted rows and columns). 

class Projective < Mobius
  # Override up() and down() in Topology
  def up(cell) cell.row == @last_row ? [0, @last_col-cell.col] : super(cell) end
  def down(cell) cell.row == 0 ? [@last_row, @last_col-cell.col] : super(cell) end
end

#---------------------------
# Klein: same as Mobius except also wraps over first and last rows
# like Torus, column j to column j.  Note could descend instead
# from Torus and override left() and right().

class Klein < Mobius
  # Override up() and down() in Topology
  def up(cell) cell.row == @last_row ? wrap_up_same_col(cell) : super(cell) end
  def down(cell) cell.row == 0 ? wrap_down_same_col(cell) : super(cell) end
end

#---------------------------
# Sphere: for square grids only, wraps over top row, column k,
# to row k of first column, and vice-versa, and wraps over row k,
# last column, to column k of first_row, and vice-versa.

class Sphere < Topology
  # Override left(), right(), up() and down() in Topology
  def left(cell) cell.col == 0 ? [@last_row, @last_col-cell.row] : super(cell) end
  def right(cell) cell.col == @last_col ? [0, @last_col-cell.row] : super(cell) end
  def up(cell) cell.row == @last_row ? [@last_row, @last_row-cell.row] : super(cell) end
  def down(cell) cell.row == 0 ? [@last_col-cell.col, @last_col] : super(cell) end
end

=begin
g = GameOfLife.new()
#g = GameOfLife.new(:OASIS)
#g = GameOfLife.new(:CYLINDER)
#g = GameOfLife.new(:TORUS)
#g = GameOfLife.new(:MOBIUS)
#g = GameOfLife.new(:KLEIN)
#g = GameOfLife.new(:PROJECTIVE)
#g = GameOfLife.new(:SPHERE)
g.display("Initial state")
#g.change_state ######
state = g.evolve()
# rows = state.size; cols = state[0].size
# rows.times {|r| row = ""; cols.times{|c| row << "#{state[r][c].to_s} "}; puts row}
#g.evolve(20)
g.display("After evolved 1 time")
=end