# This implementation is based on NArray (http://narray.rubyforge.org)
# There is already a demo: Life game (demo/lifegame.html.en)
# This intend to manage the sides & edges, which the demo ignore
# It also show some (over)use of Array methods like #permutation and #repeated_permutation
# And finaly, it proves we can have both beautiful syntax and speed !

require 'narray'

class GameOfLife
  def self.implementation
    NArray
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
    @state.to_a
  end
  def state= state
    @state = NArray.byte(@width = state.first.size, @height = state.size)
    state.each_with_index { |row, y|
      row.each_with_index { |e, x|
        @state[x,y] = e
      }
    }
  end

  def evolve
    # We need to copy the external rows/columns for easier computing (to simulate pavement)
    s = NArray.byte(*@state.shape.map { |v| v+2 })
    s[1..-2,1..-2] = @state
    [0,-1].permutation { |a,b|
      s[1..-2,a] = @state[true,b]
      s[a,1..-2] = @state[b,true]
    }
    corners = [0,-1].repeated_permutation(2).to_a
    corners.each_index { |i|
      s[*corners[i]] = @state[*corners[-1-i]]
    }
    neighbors =
      s[0..-3,0..-3] + s[0..-3,1..-2] + s[0..-3,2..-1] +
      s[1..-2,0..-3] +                  s[1..-2,2..-1] +
      s[2..-1,0..-3] + s[2..-1,1..-2] + s[2..-1,2..-1]
    @state = (neighbors.eq 3) | ((neighbors.eq 2) & @state)
    state
  end

  def [](x, y)
    @state[x % @width,y % @height]
  end

  def to_s
    state.map { |row| row.map { |i| i == 1 ? '#' : ' ' }.join }.join("\n")
  end
end
