# Ruby Programming Challenge For Newbiews #11 - Game Of Life
#
# game_of_life.rb
#
# Author: Sam Johnson <samuel.johnson@gmail.com>
# Date: July 8, 2010

class GameOfLife

  attr_accessor :size, :state

  def initialize(size)
    debug '12' if $DEBUG # added for debug by ashbb
    @size = size

    @state = Array.new(@size, Array.new(@size))
    @state = @state.map { |row| row.map { |col| 0 } }
    (20 + rand(100)).times{@state[rand size][rand size] = 1} # added this line for shoes visualization by ashbb
  end

  def evolve
    next_state = Array.new(@size, Array.new(@size))
    next_state = next_state.map { |row| row.map { |col| 0 }}
 
    0.upto(@size-1) { |r|
      0.upto(@size-1) { |c|
        case self.neighbors(r,c) 
          when 0..1; next_state[r][c] = 0
          when 2;    next_state[r][c] = @state[r][c]
          when 3;    next_state[r][c] = 1
          when 4..8; next_state[r][c] = 0
        end
      }
    }
    
    @state = Array.new(next_state)
  end

  def neighbors(row,col)
    above = @state[row == 0 ? (@size - 1) : row - 1][col]
    below = @state[row == (@size - 1) ? 0 : row + 1][col]
    right = @state[row][col == @size -1 ? 0 : col + 1]
    left  = @state[row][col == 0 ? (@size - 1) : (col - 1)]

    above_right = @state[row == 0        ? @size - 1 : row - 1][col == @size - 1 ? 0         : col + 1]
    above_left  = @state[row == 0        ? @size - 1 : row - 1][col == 0         ? @size - 1 : col - 1]
    below_right = @state[row == @size -1 ? 0         : row + 1][col == @size -1  ? 0         : col + 1]
    below_left  = @state[row == @size -1 ? 0         : row + 1][col == 0         ? @size - 1 : col - 1]

    above + below + right + left + above_right + above_left + below_right + below_left
  end

end
