# Rules
#   each cell 2 possible states, life of death
#   8 neighbours
#    - any life cell < 2 neighbours dies
#    - any life cell > 3 neighbours dies
#    - any live cell with 2 or 3 neighbours lives to next generation
#    - any dead cell with exactly 3 live neighbours becomes a live cell
# first generation: apply pattern
# 

class GameOfLife
  def initialize(n=5)
    @state = State.new(n)
  end

  def state=(array)
    @state.array = array
  end

  def evolve
    @new_state = @state.dup
    @new_state.evolve(@state)
    @state = @new_state
    @state.array
  end
end

class State
  attr_accessor :array
  def initialize(n=5)
    @size = n
    @array = []
    (0..@size-1).each do |row|
      row = []
      (0..@size-1).each do |col|
         row << rand(2)
      end
      @array << row
    end         
  end

  # previous state used to calculate current state
  def evolve(previous)
    neighbour_matrix = []
    (0..@size-1).each do |row|
      (0..@size-1).each do |col|
        neighbours = previous.live_neighbours(row,col)
        neighbour_matrix[row] ||= []
        neighbour_matrix[row][col] = neighbours
      end
    end
    (0..@size-1).each do |row|
      (0..@size-1).each do |col|
        kill_less_than_2_neighbours(row,col,neighbour_matrix[row][col])
        kill_more_than_3_neighbours(row,col,neighbour_matrix[row][col])
        give_birth_if_3_neighbours(row,col,neighbour_matrix[row][col])
      end
    end
  end

  def kill_less_than_2_neighbours(row,col,neighbours)
    @array[row][col] = 0 if neighbours < 2
  end

  def kill_more_than_3_neighbours(row,col,neighbours)
    @array[row][col] = 0 if neighbours > 3
  end

  def give_birth_if_3_neighbours(row,col,neighbours)
    @array[row][col] = 1 if neighbours == 3
  end

  def live_neighbours(rownum,column)
    row_upper = (rownum == @size - 1) ? 0 : (rownum+1) # cycle
    col_upper = (column == @size - 1) ? 0 : (column+1) # cycle
    # neighbour: sum of all surrounding
    number = @array.values_at(rownum-1,rownum,row_upper).inject(0) do |memo,row|
      row.values_at(column-1,column,col_upper).inject(memo) {|m,e| m += e }
    end
    number - @array[rownum][column] # value excepted
  end

end
