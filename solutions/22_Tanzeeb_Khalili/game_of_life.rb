class GameOfLife
  attr_accessor :state, :height, :width, :rules

  def initialize n, options={}  # edited by ashbb for shoes visualization
    self.rules = options[:rules] || [ [0,0,0,1,0,0,0,0,0], [0,0,1,1,0,0,0,0,0] ]
    
    self.height = options[:size] || options[:height] || 20 # edited by ashbb for shoes visualization
    self.width = options[:size] || options[:width] || 20 # edited by ashbb for shoes visualization
    
    self.state = options[:seed] || grid { rand(2) } 
  end

  def evolve
    @state = grid { |row, col| evaluate(row, col) }
  end

  def state= array
    self.height = array.size
    self.width = array.map(&:size).min
    @state = array
  end
  
  def cell row, col
    state[ row % height ][ col % width ]
  end

  def evaluate row, col
    rules[ cell(row, col) ][ neighbours(row, col) ]
  end

  def grid rows=height.times, cols=width.times, &block
    block ||= method(:cell)
    rows.map { |row| cols.map { |col| block.call(row,col) } }
  end

  def neighbours row, col
    grid( row-1..row+1, col-1..col+1 ).join.count('1') - cell(row, col)
  end
end
