# Provides a Game Of Life playfield. Initialize with the desired size
# and call +evolve+ to advance the game. You can always access the +state+
# attribute to set or get the current game state.
class GameOfLife

  # The current game state.
  attr_accessor :state

  # Initializes a playfield of the given size.
  def initialize(width, height = width)
    debug '14' if $DEBUG # added for debug by ashbb
    @state = Array.new(height) { Array.new(width){0} } # added initial value for shoes visualization by ashbb
    (20 + rand(100)).times{@state[rand width][rand height] = 1} # added this line for shoes visualization by ashbb
  end

  # Performs an evolution step on the playfield, applying the game rules:
  #   live cell has 2 neighbours -> stays alive
  #   dead cell has 3 neighbours -> a new cell gets born
  #   all other cases            -> the cell dies or stays dead
  def evolve
    new_state = []
    
    state.each_with_index do |line, y|
      new_line = []
      line.each_with_index do |current, x|

        new_line << case neighbours(x, y)
        when 2 # no change to alive state
          current
        when 3 # a new cell gets born
          1
        else   # too little or too many neighbours -> the cell dies
          0
        end

      end
      new_state << new_line
    end

    @state = new_state
  end

  # Returns the number of alive neighbors for a given cell.
  def neighbours(x, y)
    result = -state[y][x] # the current cell is not to be counted as a neighbour

    # now sum up all the alive cells in the patch
    (y-1..y+1).each do |py|
      line = state[py % state.size]

      (x-1..x+1).each do |px|
        result += line[px % line.size]  # just add the alive state
      end

    end

    result
  end

end
