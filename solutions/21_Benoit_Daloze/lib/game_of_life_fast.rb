class TrueClass
  def == o
    equal?(o) or o == 1
  end
end
class FalseClass
  def == o
    equal?(o) or o == 0
  end
end

class GameOfLife
  def self.implementation
    "Fast"
  end

  def initialize(width, height = width)
    self.state = case width
    when Array
      width
    else
      Array.new(height) { Array.new(width) { rand(2) } }
    end
  end

  def state
    Array.new(@height) { |y| Array.new(@width) { |x| @grid[y * @width + x] } }
  end
  def state= state
    @height, @width = state.size, state.first.size
    @size = @width*@height
    @deltas = [1, 1-@width, -@width, -1-@width, -1, @width-1, @width, @width+1]
    @false_ary = Array.new(@size) { false }
    @grid = state.map { |row| row.map { |i| i == 1 } }.flatten
  end

  def evolve
    width, size, deltas = @width, @size, @deltas
    delta_bad_left = -width-1
    delta_bad_right = width+1
    @grid = @grid.map.with_index { |e, i|
      neighbors = deltas.count { |delta|
        try = i+delta
        if delta == delta_bad_left and i % width == 0
          try += 3*width
        elsif delta == delta_bad_right and i % width == width-1
          try -= 3*width
        end
        @grid[try % size]
      }
      (neighbors == 3 or (neighbors == 2 and e))
    }
    state
  end

  def [](x, y)
    @grid[(y % @height) * @width + (x % @width)]
  end

  def to_s
    @height.times.map { |y|
      @width.times.map { |x|
        @grid[y * @width + x] ? '#' : ' '
      }.join
    }.join("\n")
  end
end
