require 'game_of_life'

describe GameOfLife do
  before(:each) do
    @game = GameOfLife.new(3)
  end

  it "should have a 3 x 3 playfield after initialization" do
    @game.state.size.should == 3
    @game.state.each do |line|
      line.size.should == 3
    end
  end
  
  it "should kill with no neighbours" do
    @game.state = [
      [1,0,0],
      [0,0,0],
      [0,0,0]]
    after = @game.evolve
    after.should == [
      [0,0,0],
      [0,0,0],
      [0,0,0]]
  end

  it "should kill with just one neighbour" do
    @game.state = [
      [0,0,0],
      [1,0,0],
      [1,0,0]]
    after = @game.evolve
    after.should == [
      [0,0,0],
      [0,0,0],
      [0,0,0]]
  end

  it "should kill with more than 3 neighbours" do
    @game.state = [
      [1,1,1],
      [1,1,1],
      [1,1,1]]
    after = @game.evolve
    after.should == [
      [0,0,0],
      [0,0,0],
      [0,0,0]]
  end

  it "should give birth if 3 neighbours" do
    @game.state = [
      [1,0,0],
      [1,1,0],
      [0,0,0]]
    after = @game.evolve
    after.should == [
      [1,1,1],
      [1,1,1],
      [1,1,1]]
  end

  it "should stay dead if 2 neighbours" do
    @game.state = [
      [0,0,0],
      [1,0,1],
      [0,0,0]]
    after = @game.evolve
    after.should == [
      [0,0,0],
      [0,0,0],
      [0,0,0]]
  end

  it "should stay alife if 2 neighbours" do
    @game.state = [
      [0,0,0],
      [1,1,1],
      [0,0,0]]
    after = @game.evolve
    after.should == [
      [1,1,1],
      [1,1,1],
      [1,1,1]]
  end

end
