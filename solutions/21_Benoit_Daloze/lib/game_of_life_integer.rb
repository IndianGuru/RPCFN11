class Integer
  def evolve(neighbors)
    evolution = if self == 1
      (2..3).include? neighbors
    else
      neighbors == 3
    end
    evolution ? 1 : 0
  end
end

class GameOfLife
  def self.implementation
    Integer
  end

  def initialize(width, height = width)
    self.state = case width
    when Array
      width
    else
      Array.new(height) { Array.new(width) { rand(2) } }
    end
  end

  attr_reader :state
  def state= state
    @height, @width = state.size, state.first.size
    @state = state
  end

  NEIGHBORS = [[1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1], [0,-1], [1,-1]]
  def neighbors x, y
    NEIGHBORS.count { |dx, dy| self[x+dx, y+dy] == 1 }
  end

  def evolve
    @state = @state.map.with_index do |row, y|
      row.map.with_index do |cell, x|
        cell.evolve( neighbors(x,y) )
      end
    end
  end

  def [](x, y)
    @state[y % @height][x % @width]
  end

  def to_s
    @state.map { |row| row.map { |i| i == 1 ? '#' : ' ' }.join }.join("\n")
  end
end
