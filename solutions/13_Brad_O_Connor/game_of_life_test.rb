# Rules
# each cell 2 possible states, life of death
# 8 neighbours
# - any life cell < 2 neighbours dies
# - any life cell > 3 neighbours dies
# - any live cell with 2 or 3 neighbours lives to next generation
# - any dead cell with exactly 3 live neighbours becomes a live cell
# first generation: apply pattern
#

### EXAMPLE ##########################################################################################################
# WRITE YOUR OWN TESTS, OF COURSE
# test-driven development is the best, this is just to show you how it should work (if it's not clear from rules)
# Plus varying parameters on initialization allows you to do cooler things, like play with different sizes, seeds, etc.
#######################################################################################################################


require File.join(File.dirname(__FILE__), 'game_of_life')
require 'rubygems'
require 'test/unit'

class GameOfLifeTest < Test::Unit::TestCase

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
  
  def test_single_integer_parameter_creates_square_grid_of_that_size
    grid = GameOfLife.new(10)
    assert_equal grid.state.length, 10
    assert_equal grid.state.all? {|row| row.length == 10}, true
  end
  
  def test_two_integer_parameters_creates_rectangular_grid_of_those_sizes
    grid = GameOfLife.new(6,8)
    assert_equal grid.state.length, 8
    assert_equal grid.state.all? {|row| row.length == 6}, true
  end
  
  def test_passing_an_array_of_arrays_creates_that_grid
    grid = GameOfLife.new([1,0,1,0],[0,1,0,1],[1,0,1,0],[0,1,0,1])
    assert_equal grid.state, [[1,0,1,0],[0,1,0,1],[1,0,1,0],[0,1,0,1]]
  end
  
  def test_r_pentomino
    grid = GameOfLife.new([0,0,0,0,0],[0,0,1,1,0],[0,1,1,0,0],[0,0,1,0,0],[0,0,0,0,0])
    assert_equal grid.evolve, [[0,0,0,0,0],[0,1,1,1,0],[0,1,0,0,0],[0,1,1,0,0],[0,0,0,0,0]]
  end

end