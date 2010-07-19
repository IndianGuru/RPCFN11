require File.join(File.dirname(__FILE__), 'game_of_life')
require 'rubygems'
require 'test/unit'

class GameOfLifeTest < Test::Unit::TestCase

  def setup
    @game = GameOfLife.new(3)
  end
  
  def test_should_kill_with_no_neighbours
    @game.state     = [[1,0,0],[0,0,0],[0,0,0]]
    @game.tmp_state = [[1,0,0],[0,0,0],[0,0,0]]
    after = @game.evolve
    assert_equal after[0][0], 0
  end
  
 def test_should_kill_with_just_one_neighbour
    @game.state     = [[0,0,0],[1,0,0],[1,0,0]]
    @game.tmp_state = [[0,0,0],[1,0,0],[1,0,0]]
    after = @game.evolve
    assert_equal after[1][0], 0
    assert_equal after[2][0], 0
  end
  
  def test_should_kill_with_more_than_3_neighbours
    @game.state     = [[1,1,1],[1,1,1],[1,1,1]]
    @game.tmp_state = [[1,1,1],[1,1,1],[1,1,1]]
    after = @game.evolve
    assert_equal after, [[0,0,0],[0,0,0],[0,0,0]]
  end
  
  def test_should_give_birth_if_3_neighbours
    @game.state     = [[1,0,0],[1,1,0],[0,0,0]]
    @game.tmp_state = [[1,0,0],[1,1,0],[0,0,0]]
    after = @game.evolve
    assert_equal after, [[1,1,1],[1,1,1],[1,1,1]]
  end
  
  def test_should_keep_alive_if_2_neighbours
    @game2 = GameOfLife.new(4)
    @game2.state     = [[0,0,0,0],[0,0,1,0],[0,1,1,0],[0,0,0,0]]
    @game2.tmp_state = [[0,0,0,0],[0,0,1,0],[0,1,1,0],[0,0,0,0]]
    after = @game2.evolve
    assert_equal after[1][2], 1
    assert_equal after[2][1], 1
    assert_equal after[2][2], 1
    assert_equal after, [[0, 0, 0, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 0, 0, 0]]
  end
  
  def test_should_initiate_with_rand_numbers_0_or_1
    group1 = @game.state.clone
    @game  = GameOfLife.new(3) 
    group2 = @game.state.clone
    assert_not_equal group1, group2
  end
  
end