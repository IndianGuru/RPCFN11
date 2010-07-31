class GameOfLife

  def initialize x=3, y=nil
    y ||= x
    @game_state = []
    x.times do
      @game_state << ( [0] * y ).map { rand.round }
    end
  end
  
  def state= game_state
    @game_state = game_state
  end
  
  def evolve
    new_state = []
    @game_state.each_with_index do |row, i|
      new_state << []
      row.each_with_index do |cell, j|
        new_state[i] << get_new_state(i, j)
      end
    end
    @game_state = new_state
  end
  
  def get_new_state x, y
    npop = neighbor_population(x,y)
    if alive?(x,y)
      (2..3).include?(npop) ? 1 : 0
    else
      npop == 3 ? 1 : 0
    end
  end
  
  def neighbor_population x, y
    count = 0
    ((x-1)..(x+1)).each do |row|
      ((y-1)..(y+1)).each do |col|
        next if row == x and col == y
        count += 1 if @game_state[row%length][col%width] == 1
      end
    end
    count
  end

  def alive?(x,y)
    @game_state[x][y] == 1
  end
   
  def to_s
    @game_state.map{ |x| x.to_s }.join("\n").gsub("0", ".").gsub("1", "#")
  end
  
  def length
    @game_state.length
  end
  
  def width
    @game_state[0].length
  end
  
end