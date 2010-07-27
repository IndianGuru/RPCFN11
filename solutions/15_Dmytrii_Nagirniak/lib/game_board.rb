
class GameBoard

  attr_reader :state  
  
  def initialize(opts =  {})
    width, height = opts[:width], opts[:height]
    state = opts[:state]
    @state = state ? state : Array.new(height) { |i| Array.new(width) }
    # Ensure state is in the canonical form of 0-1
    @state.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        @state[row_index][cell_index] =  cell.nil? || cell == '' || cell == 0 ? 0 : 1
      end
    end
  end
  
  def width
    @state[0].length
  end
  
  def height
    @state.length
  end
  
  def [](x, y)
    @state[y][x] == 0 ? :dead : :live
  end

  def []=(x, y, cell_state)
    @state[y][x] = cell_state == 0 || cell_state == :dead ? 0 : 1
  end
  
  def move_from(cell, diff)
    dx, dy = diff
    [(cell[0] + dx) % width, (cell[1] + dy) % height]
  end
  
  # define east_cell, west_cell ... methods
  { :east => [+1,0], 
    :west => [-1,0], 
    :north => [0,-1], 
    :south => [0,+1],
    :north_west => [-1,-1],
    :north_east => [+1,-1], 
    :south_west => [-1,+1],
    :south_east => [+1,+1]
  }.each_pair do |direction, diff|
    define_method direction.to_s + '_cell' do |cell|
      move_from cell, diff
    end
  end  
  
  def position_from(cell, direction)
    send(direction.to_s + '_cell', cell)
  end
  
  def live_cells
    cells = []
    @state.each_with_index do |row, row_index|
      row.each_index { |cell_index| cells << [cell_index, row_index] if @state[row_index][cell_index] != 0 }
    end
    cells
  end
  
  def neighbours_count_from(cell)
    neighbours = 0
    directions = %w{north south east west north_west north_east south_east south_west}
    directions.each do |direction|
      coords = position_from(cell, direction)
      neighbours += 1 if self[coords[0], coords[1]] == :live
    end
    neighbours
  end
  
  def set_cells(&block)
    @state.each_with_index do |row, row_index|
      row.each_index do |cell_index|
        self[cell_index, row_index] = block.call(cell_index, row_index)
      end
    end
  end
  
  def ==(other)
    @state == other.state
  end
  
  def eql?(other)
    self == other
  end
end

