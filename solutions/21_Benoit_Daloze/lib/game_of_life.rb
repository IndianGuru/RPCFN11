if RUBY_VERSION < "1.9.2"
  # Using a local copy of `backports` as Shoes can not access rubygems
  $: << File.expand_path("../backports-1.18.1/lib", __FILE__)
  require "backports/1.9.2"

  if Array === [].map
    class Array
      def map
        return to_enum(:map) unless block_given?
        super
      end
    end
  end
end

unless defined? GameOfLife
  require File.expand_path("../game_of_life_" + "boolean", __FILE__)
end

class GameOfLife
  def self.load_pattern(pattern)
    unless File.file? pattern
      pattern = File.expand_path("../../patterns/#{pattern}.txt", __FILE__)
    end
    ary = IO.read(pattern).lines.drop_while { |line|
      line.chars.first == '!'
    }.map { |line|
      line.chomp.tr('xXO .', '11100').chars.map(&:to_i)
    }
    width = ary.map(&:size).max
    GameOfLife.new ary.map { |row| row + [0]*(width-row.size) }
  end

  def height
    state.size
  end

  def width
    state.first.size
  end

  def enlarge(x, y, width, height)
    w, h = self.width, self.height
    GameOfLife.new Array.new([height,h+y].max) { |i|
      Array.new([width,w+x].max) { |j|
        if (0...h).include?(i-y) and (0...w).include?(j-x)
          state[i-y][j-x] rescue 0
        else
          0
        end
      }
    }
  end

  def surround(by = 1)
    enlarge(by, by, width+2*by, height+2*by)
  end
end

if __FILE__ == $0
  game = GameOfLife.load_pattern('patterns/Gosper_glider_gun.txt')
  100.times {
    game.evolve
    puts game
    sleep(0.3)
  }
end
