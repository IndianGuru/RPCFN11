#Game Of Life
#Author: Milan Dobrota

class GameOfLife

  attr_accessor :state

  def width
    state && state[0] ? state[0].size : 0
  end
  
  def height
    state ? state.size : 0
  end

  def initialize(size=5)
    @state = Array.new(size) { (1..size).map{rand(2)}}
  end

  def evolve
    @next_state = Array.new(width) { Array.new(height, 0) }
    (0..height-1).each do |row|
      (0..width-1).each do |col|
	cell_evolve(row, col)
      end
    end
    @state = @next_state
  end

  protected

  def count_live_neighbors(row, col)
    count = 0
    CircularRange.new(row-1, row+1, height).each do |temp_row|
      CircularRange.new(col-1, col+1, width).each do |temp_col|
	count += 1 if alive?(temp_row, temp_col) && (temp_row != row || temp_col != col)
      end
    end
    count
  end

  def alive?(row, col)
    !@state[row][col].zero?
  end

  def cell_evolve(row, col)
    count = count_live_neighbors(row, col)
    if (alive?(row, col) && [2, 3].include?(count)) || (!alive?(row, col) && count == 3)
      @next_state[row][col] = 1
    else
      @next_state[row][col] = 0
    end
  end

end

class CircularRange

  def initialize(first, last, modulo)
    first %= modulo
    last %= modulo
    last += modulo if last < first
    @range = Range.new(first, last).collect{|x| x % modulo}    
  end

  protected

  def method_missing(method, *args, &block)
    @range.send(method, *args, &block)
  end

end
