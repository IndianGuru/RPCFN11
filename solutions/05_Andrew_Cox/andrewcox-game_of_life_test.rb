# game_of_life_test.rb for Ruby Challenge - http://rubylearning.com/blog/2010/06/28/rpcfn-the-game-of-life-11/
# Andrew Cox
# 3coxy4@gmail.com

require File.join(File.dirname(__FILE__), 'game_of_life')
require 'rubygems'
require 'test/unit'

class GameOfLifeTest < Test::Unit::TestCase

  def setup
    @game = GameOfLife.new(3)
  end
  
  def test_should_default_size_to_5x5
    new_game = GameOfLife.new
    assert_equal 5, new_game.size	
  end
  
  def test_should_generate_random_state_on_init
    new_game = GameOfLife.new(20)
    assert_not_nil new_game.cells
    assert_equal 400, new_game.cells.size
  end
 
  def test_should_return_state
    @game.state = [[0,0,0],[0,1,0],[0,0,0]]
    assert_equal 1, @game.cells[4].state
  end
  
  def test_should_all_have_8_neighbours
    @game.state = [[1,0,0],[0,0,0],[0,0,0]]
    @game.cells.each do |cell|
      assert_equal 8, cell.neighbours.size
    end
  end
  
  def test_should_calculate_live_neighbours
    @game.state = [[1,0,0],[0,0,0],[0,0,0]]
    assert_equal 0, @game.cells[0].live_neighbours
    @game.state = [[1,0,1],[0,0,0],[0,0,0]]
    assert_equal 1, @game.cells[0].live_neighbours
    @game.state = [[1,0,1],[0,0,0],[0,0,1]]
    assert_equal 2, @game.cells[0].live_neighbours
    @game.state = [[1,0,1],[0,0,0],[1,0,1]]
    assert_equal 3, @game.cells[0].live_neighbours
    @game.state = [[1,1,1],[0,0,0],[1,0,1]]
    assert_equal 4, @game.cells[0].live_neighbours
    @game.state = [[1,1,1],[1,0,0],[1,0,1]]
    assert_equal 5, @game.cells[0].live_neighbours
    @game.state = [[1,1,1],[1,1,0],[1,0,1]]
    assert_equal 6, @game.cells[0].live_neighbours
    @game.state = [[1,1,1],[1,1,1],[1,0,1]]
    assert_equal 7, @game.cells[0].live_neighbours
    @game.state = [[1,1,1],[1,1,1],[1,1,1]]
    assert_equal 8, @game.cells[0].live_neighbours
  end

  def test_should_kill_with_no_neighbours
    @game.state = [[1,0,0],[0,0,0],[0,0,0]]
    after = @game.evolve
    assert_equal 0, after[0][0]
  end

  def test_should_kill_with_just_one_neighbour
    @game.state = [[0,0,0],[1,0,0],[1,0,0]]
    after = @game.evolve
    assert_equal 0, after[1][0]
    assert_equal 0, after[2][0]
  end

  def test_should_kill_with_more_than_3_neighbours
    @game.state = [[1,1,1],[1,1,1],[1,1,1]]
    after = @game.evolve
    assert_equal [[0,0,0],[0,0,0],[0,0,0]], after
  end

  def test_should_give_birth_if_3_neighbours
    @game.state = [[1,0,0],[1,1,0],[0,0,0]]
    after = @game.evolve
    assert_equal [[1,1,1],[1,1,1],[1,1,1]], after
  end

end