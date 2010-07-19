# Ruby Programming Challenge For Newbiews #11 - Game Of Life
#
# test_game_of_life.rb
#
# Author: Sam Johnson <samuel.johnson@gmail.com>
# Date: July 8, 2010

# Rules 
#   each cell 2 possible states, life of death 
#   8 neighbours 
#    - any life cell < 2 neighbours dies 
#    - any life cell > 3 neighbours dies
#    - any live cell with 2 or 3 neighbours lives to next generation
#    - any dead cell with exactly 3 live neighbours becomes a live cell
# first generation: apply pattern
# 

require File.join(File.dirname(__FILE__), '../lib/game_of_life')
require 'rubygems'
require 'test/unit'

class GameOfLifeTest < Test::Unit::TestCase

  def setup
    @game = GameOfLife.new(3)
  end

  def test_should_instance_game
    assert_equal @game.size, 3
  end

  def test_state_should_start_at_zero
    assert_equal @game.state, 
      [ [0,0,0],
        [0,0,0],
        [0,0,0]]
  end

  def test_neightbors_sum_starts_at_zero
    assert_equal @game.neighbors(0,0), 0
  end

  def test_neightbors
    @game.state = [[1,1,1],[1,1,1],[1,1,1]]
    assert_equal @game.neighbors(1,1), 8 
    assert_equal @game.neighbors(2,2), 8
    assert_equal @game.neighbors(1,2), 8
    assert_equal @game.neighbors(2,0), 8
  end

  def test_neighbors_above
    @game.state[0][1] = 1
    assert_equal @game.neighbors(1,1), 1
  end

  def test_neighbors_below
    @game.state[2][1] = 1
    assert_equal @game.neighbors(1,1), 1
  end

  def test_neighbors_right
    @game.state[1][2] = 1
    assert_equal @game.neighbors(1,1), 1
  end

  def test_neighbors_left
    @game.state[1][0] = 1
    assert_equal @game.neighbors(1,1), 1
  end

  def test_neighbors_above_right
    @game.state[0][2] = 1
    assert_equal @game.neighbors(1,1), 1
  end

  def test_neighbors_above_left
    @game.state[0][0] = 1
    assert_equal @game.neighbors(1,1), 1
  end

  def test_neighbors_below_right
    @game.state[2][2] = 1
    assert_equal @game.neighbors(1,1), 1
  end

  def test_neighbors_below_left
    @game.state[2][0] = 1
    assert_equal @game.neighbors(1,1), 1
  end

  def test_should_kill_with_no_neighbours
    @game.state = [[1,0,0],[0,0,0],[0,0,0]]
    after = @game.evolve
    assert_equal after[0][0], 0
  end

  def test_should_kill_with_just_one_neighbour
    @game.state = [[0,0,0],[1,0,0],[1,0,0]]
    after = @game.evolve
    assert_equal after[1][0], 0
    assert_equal after[2][0], 0
  end

  def test_should_kill_with_more_than_3_neighbours
    @game.state = [[1,1,1],[1,1,1],[1,1,1]]
    after = @game.evolve
    assert_equal after, [[0,0,0],[0,0,0],[0,0,0]]
  end

 def test_should_give_birth_if_3_neighbours
    @game.state = [[1,0,0],[1,1,0],[0,0,0]]
    after = @game.evolve
    assert_equal after, [[1,1,1],[1,1,1],[1,1,1]]
  end

 def test_full
  #[0,0,0]     [0,0,0]
  #[0,1,1] ==> [0,1,1]
  #[0,1,1]     [0,1,1]

  @game.state = [[0,0,0],[0,1,1],[0,1,1]]
  assert_equal @game.neighbors(0,1), 4
  assert_equal @game.neighbors(0,2), 4

  after = @game.evolve

  assert_equal after[0][1], 0
  assert_equal after[0][2], 0

  assert_equal after, [[0,0,0],[0,1,1],[0,1,1]]
 end

end
