require "game_of_life"

describe GameOfLife do
  before :each do
    @width, @height, @seed = 10, 8, 5
    @gol = GameOfLife.new(@width, @height, @seed)
  end

  it "should initialize correctly" do
    @gol.width.should == @width
    @gol.height.should == @height
    @gol.cells.size.should == @width * @height
    @gol.state.flatten.select{|c| c == 1}.size.should == @seed
  end

  it "should be possible to set a state" do
    state = [[1,0,0,1],[0,0,1,1],[1,1,0,1]]
    @gol.state = state
    @gol.state.should == state
    @gol.width.should == 4
    @gol.height.should == 3
  end

  it "should determine north correctly" do
    @gol.state = [[0,0,0],[0,0,0],[0,0,0]]
    pos_check = {0 => 6, 1 => 7, 2 => 8,
                 3 => 0, 4 => 1, 5 => 2,
                 6 => 3, 7 => 4, 8 => 5}
    pos_check.keys.each { |p| @gol.north(p).should == pos_check[p] }
  end

  it "should determine east correctly" do
    @gol.state = [[0,0,0],[0,0,0],[0,0,0]]
    pos_check = {0 => 1, 1 => 2, 2 => 0,
                 3 => 4, 4 => 5, 5 => 3,
                 6 => 7, 7 => 8, 8 => 6}
    pos_check.keys.each { |p| @gol.east(p).should == pos_check[p] }
  end

  it "should determine south correctly" do
    @gol.state = [[0,0,0],[0,0,0],[0,0,0]]
    pos_check = {0 => 3, 1 => 4, 2 => 5,
                 3 => 6, 4 => 7, 5 => 8,
                 6 => 0, 7 => 1, 8 => 2}
    pos_check.keys.each { |p| @gol.south(p).should == pos_check[p] }
  end

  it "should determine west correctly" do
    @gol.state = [[0,0,0],[0,0,0],[0,0,0]]
    pos_check = {0 => 2, 1 => 0, 2 => 1,
                 3 => 5, 4 => 3, 5 => 4,
                 6 => 8, 7 => 6, 8 => 7}
    pos_check.keys.each { |p| @gol.west(p).should == pos_check[p] }
  end

  it "should determine north-east correctly" do
    @gol.state = [[0,0,0],[0,0,0],[0,0,0]]
    pos_check = {0 => 7, 1 => 8, 2 => 6,
                 3 => 1, 4 => 2, 5 => 0,
                 6 => 4, 7 => 5, 8 => 3}
    pos_check.keys.each { |p| @gol.north_east(p).should == pos_check[p] }
  end

  it "should determine south-east correctly" do
    @gol.state = [[0,0,0],[0,0,0],[0,0,0]]
    pos_check = {0 => 4, 1 => 5, 2 => 3,
                 3 => 7, 4 => 8, 5 => 6,
                 6 => 1, 7 => 2, 8 => 0}
    pos_check.keys.each { |p| @gol.south_east(p).should == pos_check[p] }
  end  

  it "should determine north-west correctly" do
    @gol.state = [[0,0,0],[0,0,0],[0,0,0]]
    pos_check = {0 => 8, 1 => 6, 2 => 7,
                 3 => 2, 4 => 0, 5 => 1,
                 6 => 5, 7 => 3, 8 => 4}
    pos_check.keys.each { |p| @gol.north_west(p).should == pos_check[p] }
  end  

  it "should determine south-west correctly" do
    @gol.state = [[0,0,0],[0,0,0],[0,0,0]]
    pos_check = {0 => 5, 1 => 3, 2 => 4,
                 3 => 8, 4 => 6, 5 => 7,
                 6 => 2, 7 => 0, 8 => 1}
    pos_check.keys.each { |p| @gol.south_west(p).should == pos_check[p] }
  end  

  it "should kill with just one neighbour" do
    @gol.state = [[0,0,0],[1,0,0],[1,0,0]]
    after = @gol.evolve
    after.should == [[0,0,0],[0,0,0],[0,0,0]]
  end

  it "should kill with more than 3 neighbours" do
    @gol.state = [[1,1,1],[1,1,1],[1,1,1]]
    after = @gol.evolve
    after.should == [[0,0,0],[0,0,0],[0,0,0]]
  end  

  it "should give birth if 3 neighbours" do
    @gol.state = [[1,0,0],[1,1,0],[0,0,0]]
    after = @gol.evolve
    after.should == [[1,1,1],[1,1,1],[1,1,1]]
  end

end
