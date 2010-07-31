class GameOfLife

  attr_accessor :state

  DEAD = 0
  ALIVE = 1

  def initialize(width, height = width, wrapped = true)
    @wrapped = wrapped
    randomize_game_state(width, height)
  end

  def evolve
    # Copy game state
    new_state = Marshal.load(Marshal.dump(@state))
    
    0.upto(@width - 1) do |x| 
      0.upto(@height - 1) do |y|
        neighbours = count_neighbours(x, y)
        if is_alive(x, y) and neighbours < 2
          new_state[x][y] = DEAD
        elsif is_alive(x, y) and neighbours > 3
          new_state[x][y] = DEAD
        elsif !is_alive(x, y) and neighbours == 3
          new_state[x][y] = ALIVE
        end  
      end 
    end

    @state = new_state
  end
  
  def randomize_game_state(width, height)
    @width = width
    @height = height
    @state = Array.new(@width) { Array.new(@height) { rand(2) } }
  end

  def is_alive(x, y, rel_x = 0, rel_y = 0)
    cx = x + rel_x
    cy = y + rel_y
    if @wrapped
      cx %= @width
      cy %= @height
    else 
      # return if out of range
      return false if cx >= @width  or cx <  0 or
                      cy >= @height or cy <  0
    end
    state[cx][cy] == ALIVE
  end

  def count_neighbours(x, y)
    neighbours = 0
    neighbours += 1 if is_alive(x, y, 1, 0)   # East
    neighbours += 1 if is_alive(x, y, 1, 1)   # North East
    neighbours += 1 if is_alive(x, y, 0, 1)   # North
    neighbours += 1 if is_alive(x, y, -1, 1)  # North West
    neighbours += 1 if is_alive(x, y, -1, 0)  # West
    neighbours += 1 if is_alive(x, y, -1, -1) # South West
    neighbours += 1 if is_alive(x, y, 0, -1)  # South
    neighbours += 1 if is_alive(x, y, 1, -1)  # South East
    neighbours
  end

  def update_dimensions
    width = @state.length
    height = @state[0].length
    # Find minimum height
    1.upto(width - 1) do |x|
      height = @state[x].length if height > @state[x].length
    end
    @width = width
    @height = height
  end

end
