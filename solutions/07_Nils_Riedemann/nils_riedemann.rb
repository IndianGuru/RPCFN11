# game_of_life.rb
# GameOfLife in less then 40 rows (excluding comments)
# by Nils Riedemann
class GameOfLife
  attr_accessor :size, :state, :temp_state

  def initialize size=5
    @size = size
    @state = Array.new(size) { Array.new(size) { rand(2) } }
  end

  def evolve
    @temp_state = Array.new(@size) { Array.new(@size) } # create empty array
    @state.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        @temp_state[x][y] = case count_neighbors(x,y)
          when 0..1 then 0 
          when 2 then @state[x][y] 
          when 3 then 1
          else 0
        end
      end
    end
    @state = @temp_state
  end

  def count_neighbors x, y
    neighbors = 0
    # go around cell and check for life
    for _x in (x-1)..(x+1) do
      for _y in (y-1)..(y+1) do
        next if _x == x and _y == y # skip if current cell
        _x = 0 if _x == @size # Edge to the right
        _y = 0 if _y == @size # Edge to the bottom
        _x = @state.length-1 if _x==-1 # Edge to the left
        _y = @state[_x].length-1 if _y==-1 # Edge to the top
        neighbors+=1 if @state[_x][_y] == 1 # YAY! Life was found. 
      end
    end
    return neighbors 
  end
end


# game_of_life_specs.rb
##
# Bear with me… my first specs ever.
#
# require "game_of_life"

describe GameOfLife do
  it "should initialize with 3" do
    @game = GameOfLife.new(3)
    @game.state.length.should eql(3)
    @game.state[0].length.should eql(3)
  end

  it "should initializw with 1000" do
    @game = GameOfLife.new(1000)
    @game.state.length.should eql(1000)
    @game.state[0].length.should eql(1000)
  end
end

describe GameOfLife do 
  before do
    @game = GameOfLife.new 3
  end

  it "should count 3 neighbors" do
    @game.state = [ [1,0,1], [0,1,0], [0,0,1] ]
    @game.count_neighbors(1,1).should eql(3)
  end

  it "should count 4 neighbors with 1 over the edge" do
    @game.state = [ [1,0,1], [0,1,0], [0,0,1]]
    @game.count_neighbors(2,1).should eql(4)
  end

  it "should count 2 neighbors over the edge" do
    @game.state = [[0,1,1],[0,0,0],[0,0,0]]
    @game.count_neighbors(0,0).should eql(2)
  end
  
  it "should count 4 neighbors" do
    @game.state = [[0,1,0],[1,1,1],[0,1,0]]
    @game.count_neighbors(1,1).should eql 4
  end
  
  it "should count 3 neighbors" do
    @game.state = [[0,0,0],[1,0,1],[0,1,0]]
    @game.count_neighbors(1,1).should eql 3
  end

  describe "any cell" do
    it "should gie birth if 3 neighbors" do
      @game.state = [[1,0,0],[1,1,0],[0,0,0]]
      @game.evolve
      @game.state.should eql [[1,1,1],[1,1,1],[1,1,1]]
    end

    it "should not die with 3 neighbors" do
      @game.state = [[0,0,0],[1,1,1],[0,1,0]]
      @game.evolve
      @game.state[1][1].should eql(1)
    end

    it "should not die with 2 neighbors" do 
      @game.state = [[0,0,0],[1,1,1],[0,0,0]]
      @game.evolve
      @game.state[1][1].should eql(1)
    end

    it "should die with less than 2 neighbors" do
      @game.state = [[0,0,0],[0,1,1],[0,0,0]]
      @game.evolve
      @game.state[1][1].should eql(0)
    end

    it "should die with more than 3 neighbors" do
      @game.state = [[0,1,0],[1,1,1],[0,1,0]]
      @game.evolve
      @game.state[1][1].should eql(0)
    end

    it "should gain life with exactly 3 neighbors" do
      @game.state = [[0,0,0],[1,0,1],[0,1,0]]
      @game.evolve
      @game.state[1][1].should eql(1)
    end
  end
end
