raise "Need Ruby 1.9 because it depends on Fiber" if RUBY_VERSION < '1.9'

# RSpec or Fiber produce segfault, fake error (can't yield from root fiber) or "incorrect checksum for freed object"
# or even "undefined method `[]' for  :Cell"
# or :O "undefined method `[]' for #<RubyVM::Env:0x00000100846498>"
GC.disable

# This is largely inspired by Daniel Moore's solution to his own "Game of Life" Ruby Quiz
# The solution (ab)use of Fiber, and is really interesting (but do not expect it to be fast)
# I commented it a little, because Fiber is not so easy to understand
require 'fiber'
class Cell < Fiber
  ALIVE, DEAD = '#', ' '

  def living? # alive? could mess with Fiber#alive?
    @alive
  end

  def initialize(alive)
    alive = (alive == 1) if alive.is_a? Integer

    super() { # So this is Fiber.new { }
      loop {
        # First Fiber.yield: wait for caller to give neighbors
        # Here the caller has to give the number of alive neighbors as an argument to #resume
        neighbors = Fiber.yield(alive)

        alive = (neighbors == 3) || (neighbors == 2 and living?)
        # Second Fiber.yield: update @alive
        # This simply update `@alive` to `alive`, and is #resume in #evolve
        Fiber.yield(alive)
      }
    }

    # We go until the first Fiber.yield
    # The return value is `alive`, which is what we want for `@alive`
    @alive = resume
  end

  alias :neighbors= :resume

  def evolve
    @alive = resume
  end

  def == other
    (Cell === other and other.living? == @alive) or self.to_i == other
  end

  def to_i
    @alive ? 1 : 0
  end

  def to_s
    @alive ? '#' : ' '
  end
end

class GameOfLife
  def self.implementation
    Fiber
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
    @state = state.map { |row| row.map { |i| Cell.new(i) } }
  end

  NEIGHBORS = [[1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1], [0,-1], [1,-1]]
  def alive_neighbors x, y
    NEIGHBORS.count { |dx, dy| @state[(y+dy) % @height][(x+dx) % @width].living? }
  end

  def evolve
    # in border_spec, for glider, seems a proc is there from nowhere
    #p @state # [... #<Proc:0x0000010084db30@~/EREGONMS/Ruby/Quiz/RPCFN/11GameOfLife/game_of_life/lib/game_of_life_fiber.rb:19>, ...]
    @state.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell.neighbors = alive_neighbors(x, y)
      end
    end
    @state.each { |row| row.each { |cell| cell.evolve } }
  end

  def [](x, y)
    @state[y % @height][x % @width]
  end

  def to_s
    @state.map(&:join).join("\n")
  end
end
