module Boolean
  def to_i
    self ? 1 : 0
  end

  def == other
    (Boolean === other and self.equal? other) or self.to_i == other
  end

  def evolve(neighbors)
    if self
      (2..3).include? neighbors
    else
      neighbors == 3
    end
  end
end
class TrueClass
  include Boolean
  def to_s
    '#'
  end
end
class FalseClass
  include Boolean
  def to_s
    ' '
  end
end

class GameOfLife
  def self.implementation
    Boolean
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
    @state = state.map { |row| row.map { |i| i == 1 } }
  end

  NEIGHBORS = [[1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1], [0,-1], [1,-1]]
  def neighbors x, y
    NEIGHBORS.count { |dx, dy| self[x+dx, y+dy] }
  end

  def evolve
    @state = @state.map.with_index do |row, y|
      row.map.with_index do |cell, x|
        cell.evolve( neighbors(x,y) )
      end
    end
    @state.collect{|line| line.collect{|e| e ? 1 : 0}} # added this line for shoes visualization by ashbb
  end

  def [](x, y)
    @state[y % @height][x % @width]
  end

  def to_s
    @state.map(&:join).join("\n")
  end
end
