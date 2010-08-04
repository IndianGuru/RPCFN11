require 'helper'

class TestGameOfLife < Test::Unit::TestCase
  def setup
    @game = GameOfLife.new(3)
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
  
  def test_should_survive_with_two_neighbours
    @game.state = [[0,0,0],[1,1,0],[1,0,0]]
    after = @game.evolve
    assert_equal after[1][1], 1
  end
  
  def test_should_not_give_birth_if_2_neighbours
    @game.state = [[0,0,0],[1,0,1],[0,0,0]]
    after = @game.evolve
    assert_equal after[1][1], 0
  end
  
  def test_should_not_give_birth_if_4_neighbours
    @game.state = [[0,1,0],[1,0,1],[0,1,0]]
    after = @game.evolve
    assert_equal after[1][1], 0
  end
  
  def test_should_survive_with_three_neighbours
    @game.state = [[0,0,0],[1,1,0],[1,1,0]]
    after = @game.evolve
    assert_equal after[1][1], 1
  end

  def test_should_kill_with_more_than_3_neighbours
    @game.state = [[1,1,1],[1,1,1],[1,1,1]]
    after = @game.evolve
    assert_equal after, [[0,0,0],[0,0,0],[0,0,0]]
  end

  def test_should_give_birth_if_3_neighbours
    @game.state = [[1,0,0],
                   [1,1,0],
                   [0,0,0]]
    assert_equal 2,@game.count_live_neighbours_near(1,0)
    after = @game.evolve
    assert_equal after, [[1,1,1],[1,1,1],[1,1,1]]
  end
  
  def test_count_live_neighbours
    @game.state = [[0,0,0],
                   [0,1,0],
                   [0,0,0]]
    assert_equal 1,@game.count_live_neighbours_near(1,0)
    assert_equal 0,@game.count_live_neighbours_near(1,1)
    @game.state = [[1,0,0],
                   [1,1,0],
                   [0,0,0]]
    assert_equal 3,@game.count_live_neighbours_near(0,1)
    assert_equal 2,@game.count_live_neighbours_near(1,0)
  end
end
