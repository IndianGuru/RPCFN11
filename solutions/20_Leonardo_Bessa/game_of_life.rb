class GameOfLife
  
  DEAD  = 0
  ALIVE = 1
  
  attr_accessor :state
  
  def initialize(size=20)
    @size = size
    @state = Array.new(@size){ Array.new(@size){ rand 2 } }
  end
  
  def evolve
    new_state = Array.new(@size){ Array.new(@size) }
    @state.each_with_index do |row, x|
      row.each_with_index do |cell,y|
        new_state[x][y] = case (count_live_neighbours_near(x,y))
        when 2
          alive?(x,y) ? ALIVE : DEAD
        when 3
          ALIVE
        else 
          DEAD
        end
      end
    end
    @state = new_state
  end
  
  def count_live_neighbours_near(x,y)
    neighbours_near(x,y).
    select{ |a,b| alive?(a,b) }.
    length
  end
  
  def alive?(x,y)
    @state[x%@size][y%@size] == ALIVE
  end
  
  def neighbours_near(x,y)
      [
        [x-1,y-1],[x-1,y],[x-1,y+1],
        [ x ,y-1],        [x  ,y+1],
        [x+1,y-1],[x+1,y],[x+1,y+1]
      ]
  end
  
end