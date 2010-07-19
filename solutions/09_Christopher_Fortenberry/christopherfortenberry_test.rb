######################################
# RCPFN 11: Game of Life #
# 
# Christopher Fortenberry
# 
# http://twitter.com/cpfortenberry
# http://github.com/CPFB
#
#
# NOTES
#
#   I refactored the evolve tests,
# leaving fragments of the old tests
# to explain how they work.
######################################

require File.join(File.dirname(__FILE__), 'game_of_life')
require 'rubygems'
require 'test/unit'

class GameOfLifeTest < Test::Unit::TestCase

  def setup
    @game = GameOfLife.new(6, 5)
  end

  def test_should_find_neighbors_with_no_fold_over 
    assert_equal @game.get_neighbors(3, 3), [ [2,2], [2,3], [2,4],
                                              [3,2],        [3,4],
                                              [4,2], [4,3], [4,4]
                                            ]
  end
  
  def test_should_find_neighbors_with_north_fold_over
    assert_equal @game.get_neighbors(0, 3), [ [5,2], [5,3], [5,4],
                                              [0,2],        [0,4],
                                              [1,2], [1,3], [1,4]
                                            ]
  end
  
  def test_should_find_neighbors_with_south_fold_over
    assert_equal @game.get_neighbors(5, 3), [ [4,2], [4,3], [4,4],
                                              [5,2],        [5,4],
                                              [0,2], [0,3], [0,4]
                                            ]
  end
  
  def test_should_find_neighbors_with_west_fold_over
    assert_equal @game.get_neighbors(3, 0), [ [2,4], [2,0], [2,1],
                                              [3,4],        [3,1],
                                              [4,4], [4,0], [4,1]
                                            ]
  end
  
  def test_should_find_neighbors_with_east_fold_over
    assert_equal @game.get_neighbors(3, 4), [ [2,3], [2,4], [2,0],
                                              [3,3],        [3,0],
                                              [4,3], [4,4], [4,0]
                                            ]
  end
  
  def test_should_find_neighbors_with_northwest_fold_over
    assert_equal @game.get_neighbors(0, 0), [ [5,4], [5,0], [5,1],
                                              [0,4],        [0,1],
                                              [1,4], [1,0], [1,1]
                                            ]
  end
  
  def test_should_find_neighbors_with_northeast_fold_over
    assert_equal @game.get_neighbors(0, 4), [ [5,3], [5,4], [5,0],
                                              [0,3],        [0,0],
                                              [1,3], [1,4], [1,0]
                                            ]
  end
  
  def test_should_find_neighbors_with_southwest_fold_over
    assert_equal @game.get_neighbors(5, 0), [ [4,4], [4,0], [4,1],
                                              [5,4],        [5,1],
                                              [0,4], [0,0], [0,1]
                                            ]
  end
  
  def test_should_find_neighbors_with_southeast_fold_over
    assert_equal @game.get_neighbors(5, 4), [ [4,3], [4,4], [4,0],
                                              [5,3],        [5,0],
                                              [0,3], [0,4], [0,0]
                                            ]
  end
  
  def test_should_have_no_living_neighbors
    @game.state = [ [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0]
                  ]
    assert_equal @game.number_of_living_cells(1, 3), 0
  end
  
  def test_should_have_one_living_neighbor
    @game.state = [ [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0],
                    [0, 0, 1, 0, 0],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0]
                  ]
    assert_equal @game.number_of_living_cells(1, 3), 1
  end
  
  def test_should_have_two_living_neighbors
    @game.state = [ [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0],
                    [0, 0, 1, 1, 0],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0]
                  ]
    assert_equal @game.number_of_living_cells(1, 3), 2
  end
  
  def test_should_have_three_living_neighbors
    @game.state = [ [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0],
                    [0, 0, 1, 1, 1],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0]
                  ]
    assert_equal @game.number_of_living_cells(1, 3), 3
  end
  
  def test_should_have_four_living_neighbors
    @game.state = [ [0, 0, 0, 0, 0],
                    [0, 0, 1, 0, 0],
                    [0, 0, 1, 1, 1],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0]
                  ]
    assert_equal @game.number_of_living_cells(1, 3), 4
  end
  
  def test_should_have_five_living_neighbors
    @game.state = [ [0, 0, 0, 0, 0],
                    [0, 0, 1, 0, 1],
                    [0, 0, 1, 1, 1],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0]
                  ]
    assert_equal @game.number_of_living_cells(1, 3), 5
  end
  
  def test_should_have_six_living_neighbors
    @game.state = [ [0, 0, 1, 0, 0],
                    [0, 0, 1, 0, 1],
                    [0, 0, 1, 1, 1],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0]
                  ]
    assert_equal @game.number_of_living_cells(1, 3), 6
  end
  
  def test_should_have_seven_living_neighbors
    @game.state = [ [0, 0, 1, 1, 0],
                    [0, 0, 1, 0, 1],
                    [0, 0, 1, 1, 1],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0]
                  ]
    assert_equal @game.number_of_living_cells(1, 3), 7
  end
  
  def test_should_have_eight_living_neighbors
    @game.state = [ [0, 0, 1, 1, 1],
                    [0, 0, 1, 0, 1],
                    [0, 0, 1, 1, 1],
                    [0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0]
                  ]
    assert_equal @game.number_of_living_cells(1, 3), 8
  end
  
  def evolve_base(x_coord, y_coord, cell_status, living_neighbors, expected)
    # initialize state of array
    state = [ [0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0]
            ]
    # sets the dimensions of the grid
    @game.state = state
    
    state[x_coord][y_coord] = cell_status
    
    # shuffling mechanism to randomize the order of the neighbors to check for inconsistencies in testing
    coord_array = @game.get_neighbors(x_coord, y_coord)
    # CAN BE COMMENTED OUT FOR FASTER TESTING
    coord_array = coord_array.sort_by { rand }
    
    # populates state with appropriate number of living neighbors
    0.upto(living_neighbors-1) do |index|
      coords = coord_array[index]
      state[coords[0]][coords[1]] = 1
    end
    
    # do the test
    @game.state = state
    after = @game.evolve
    assert_equal after[x_coord][y_coord], expected
  end
  
  def test_living_cell_with_no_fold_over_neighbors_should_die_with_no_living_neighbors
    evolve_base(1, 3, 1, 0, 0)
    # @game.state = [ [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 1, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0]
    #               ]
    # after = @game.evolve
    # assert_equal after[1][3], 0
  end
  
  def test_living_cell_with_no_fold_over_neighbors_should_die_with_one_living_neighbor
    evolve_base(1, 3, 1, 1, 0)
  end

  def test_living_cell_with_no_fold_over_neighbors_should_live_with_two_living_neighbors
    evolve_base(1, 3, 1, 2, 1)
  end
  
  def test_living_cell_with_no_fold_over_neighbors_should_live_with_three_living_neighbors
    evolve_base(1, 3, 1, 3, 1)
  end
  
  def test_living_cell_with_no_fold_over_neighbors_should_die_with_four_living_neighbors
    evolve_base(1, 3, 1, 4, 0)
  end
  
  def test_living_cell_with_no_fold_over_neighbors_should_die_with_five_living_neighbors
    evolve_base(1, 3, 1, 5, 0)
  end
  
  def test_living_cell_with_no_fold_over_neighbors_should_die_with_six_living_neighbors
    evolve_base(1, 3, 1, 6, 0)
  end
  
  def test_living_cell_with_no_fold_over_neighbors_should_die_with_seven_living_neighbors
    evolve_base(1, 3, 1, 7, 0)
  end
  
  def test_living_cell_with_no_fold_over_neighbors_should_die_with_eight_living_neighbors
    evolve_base(1, 3, 1, 8, 0)
  end
  
  def test_dead_cell_with_no_fold_over_neighbors_should_stay_dead_with_no_living_neighbors
    evolve_base(1, 3, 0, 0, 0)
    # @game.state = [ [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0]
    #               ]
    # after = @game.evolve
    # assert_equal after[1][3], 0
  end
  
  def test_dead_cell_with_no_fold_over_neighbors_should_stay_dead_with_one_living_neighbor
    evolve_base(1, 3, 0, 1, 0)
  end
  
  def test_dead_cell_with_no_fold_over_neighbors_should_stay_dead_with_two_living_neighbors
    evolve_base(1, 3, 0, 2, 0)
  end
  
  def test_dead_cell_with_no_fold_over_neighbors_should_regenerate_with_three_living_neighbors
    evolve_base(1, 3, 0, 3, 1)
  end
  
  def test_dead_cell_with_no_fold_over_neighbors_should_stay_dead_with_four_living_neighbors
    evolve_base(1, 3, 0, 4, 0)
  end
  
  def test_dead_cell_with_no_fold_over_neighbors_should_stay_dead_with_five_living_neighbors
    evolve_base(1, 3, 0, 5, 0)
  end
  
  def test_dead_cell_with_no_fold_over_neighbors_should_stay_dead_with_six_living_neighbors
    evolve_base(1, 3, 0, 6, 0)
  end
  
  def test_dead_cell_with_no_fold_over_neighbors_should_stay_dead_with_seven_living_neighbors
    evolve_base(1, 3, 0, 7, 0)
  end
  
  def test_dead_cell_with_no_fold_over_neighbors_should_stay_dead_with_eight_living_neighbors
    evolve_base(1, 3, 0, 8, 0)
  end
  
  def test_living_cell_with_north_fold_over_should_die_with_no_living_neighbors
    evolve_base(0, 1, 1, 0, 0)
    # @game.state = [ [0, 1, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0]
    #               ]
    # after = @game.evolve
    # assert_equal after[0][1], 0
  end
  
  def test_living_cell_with_north_fold_over_should_die_with_one_living_neighbor
    evolve_base(0, 1, 1, 1, 0)
  end
  
  def test_living_cell_with_north_fold_over_should_stay_living_with_two_living_neighbors
    evolve_base(0, 1, 1, 2, 1)
  end
  
  def test_living_cell_with_north_fold_over_should_stay_living_with_three_living_neighbors
    evolve_base(0, 1, 1, 3, 1)
  end
  
  def test_living_cell_with_north_fold_over_should_die_with_four_living_neighbors
    evolve_base(0, 1, 1, 4, 0)
  end

  def test_living_cell_with_north_fold_over_should_die_with_five_living_neighbors
    evolve_base(0, 1, 1, 5, 0)
  end

  def test_living_cell_with_north_fold_over_should_die_with_six_living_neighbors
    evolve_base(0, 1, 1, 6, 0)
  end

  def test_living_cell_with_north_fold_over_should_die_with_seven_living_neighbors
    evolve_base(0, 1, 1, 7, 0)
  end

  def test_living_cell_with_north_fold_over_should_die_with_eight_living_neighbors
    evolve_base(0, 1, 1, 8, 0)
  end

  def test_dead_cell_with_north_fold_over_stays_dead_with_no_living_neighbors
    evolve_base(0, 1, 0, 0, 0)
    # @game.state = [ [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0]
    #               ]
    # after = @game.evolve
    # assert_equal after[0][1], 0
  end
  
  def test_dead_cell_with_north_fold_over_stays_dead_with_one_living_neighbor
    evolve_base(0, 1, 0, 1, 0)
  end
  
  def test_dead_cell_with_north_fold_over_stays_dead_with_two_living_neighbors
    evolve_base(0, 1, 0, 2, 0)
  end
  
  def test_dead_cell_with_north_fold_over_regenerates_with_three_living_neighbors
    evolve_base(0, 1, 0, 3, 1)
  end
  
  def test_dead_cell_with_north_fold_over_stays_dead_with_four_living_neighbors
    evolve_base(0, 1, 0, 4, 0)
  end
  
  def test_dead_cell_with_north_fold_over_stays_dead_with_five_living_neighbors
    evolve_base(0, 1, 0, 5, 0)
  end
  
  def test_dead_cell_with_north_fold_over_stays_dead_with_six_living_neighbors
    evolve_base(0, 1, 0, 6, 0)
  end
  
  def test_dead_cell_with_north_fold_over_stays_dead_with_seven_living_neighbors
    evolve_base(0, 1, 0, 7, 0)
  end
  
  def test_dead_cell_with_north_fold_over_stays_dead_with_eight_living_neighbors
    evolve_base(0, 1, 0, 8, 0)
  end
  
  def test_living_cell_with_west_fold_over_dies_with_no_living_neighbors
    evolve_base(1, 0, 1, 0, 0)
    # @game.state = [ [0, 0, 0, 0, 0],
    #                 [1, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0]
    #               ]
    # after = @game.evolve
    # assert_equal after[1][0], 0
  end
  
  def test_living_cell_with_west_fold_over_dies_with_one_living_neighbor
    evolve_base(1, 0, 1, 1, 0)
  end
  
  def test_living_cell_with_west_fold_over_dies_with_two_living_neighbors
    evolve_base(1, 0, 1, 2, 1)
  end
  
  def test_living_cell_with_west_fold_over_dies_with_three_living_neighbors
    evolve_base(1, 0, 1, 3, 1)
  end
  
  def test_living_cell_with_west_fold_over_dies_with_four_living_neighbors
    evolve_base(1, 0, 1, 4, 0)
  end
  
  def test_living_cell_with_west_fold_over_dies_with_five_living_neighbors
    evolve_base(1, 0, 1, 5, 0)
  end
  
  def test_living_cell_with_west_fold_over_dies_with_six_living_neighbors
    evolve_base(1, 0, 1, 6, 0)
  end
  
  def test_living_cell_with_west_fold_over_dies_with_seven_living_neighbors
    evolve_base(1, 0, 1, 7, 0)
  end
  
  def test_living_cell_with_west_fold_over_dies_with_eight_living_neighbors
    evolve_base(1, 0, 1, 8, 0)
  end
  
  def test_dead_cell_with_west_fold_over_stays_dead_with_no_neighbors
    evolve_base(1, 0, 0, 0, 0)
    # @game.state = [ [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0]
    #               ]
    # after = @game.evolve
    # assert_equal after[1][0], 0
  end
  
  def test_dead_cell_with_west_fold_over_stays_dead_with_one_neighbor
    evolve_base(1, 0, 0, 1, 0)
  end
  
  def test_dead_cell_with_west_fold_over_stays_dead_with_two_neighbors
    evolve_base(1, 0, 0, 2, 0)
  end
  
  def test_dead_cell_with_west_fold_over_regenerates_with_three_neighbors
    evolve_base(1, 0, 0, 3, 1)
  end
  
  def test_dead_cell_with_west_fold_over_stays_dead_with_four_neighbors
    evolve_base(1, 0, 0, 4, 0)
  end
  
  def test_dead_cell_with_west_fold_over_stays_dead_with_five_neighbors
    evolve_base(1, 0, 0, 5, 0)
  end
  
  def test_dead_cell_with_west_fold_over_stays_dead_with_six_neighbors
    evolve_base(1, 0, 0, 6, 0)
  end
  
  def test_dead_cell_with_west_fold_over_stays_dead_with_seven_neighbors
    evolve_base(1, 0, 0, 7, 0)
  end
  
  def test_dead_cell_with_west_fold_over_stays_dead_with_eight_neighbors
    evolve_base(1, 0, 0, 8, 0)
  end
  
  def test_living_cell_with_northwest_fold_over_dies_with_no_neighbors
    evolve_base(0, 0, 1, 0, 0)
    # @game.state = [ [1, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0]
    #               ]
    # after = @game.evolve
    # assert_equal after[0][0], 0
  end
  
  def test_living_cell_with_northwest_fold_over_dies_with_one_neighbor
    evolve_base(0, 0, 1, 1, 0)
  end
  
  def test_living_cell_with_northwest_fold_over_stays_living_with_two_neighbors
    evolve_base(0, 0, 1, 2, 1)
  end
  
  def test_living_cell_with_northwest_fold_over_stays_living_with_three_neighbors
    evolve_base(0, 0, 1, 3, 1)
  end
  
  def test_living_cell_with_northwest_fold_over_dies_with_four_neighbors
    evolve_base(0, 0, 1, 4, 0)
  end
  
  def test_living_cell_with_northwest_fold_over_dies_with_five_neighbors
    evolve_base(0, 0, 1, 5, 0)
  end
  
  def test_living_cell_with_northwest_fold_over_dies_with_six_neighbors
    evolve_base(0, 0, 1, 6, 0)
  end
  
  def test_living_cell_with_northwest_fold_over_dies_with_seven_neighbors
    evolve_base(0, 0, 1, 7, 0)
  end
  
  def test_living_cell_with_northwest_fold_over_dies_with_eight_neighbors
    evolve_base(0, 0, 1, 8, 0)
  end
  
  def test_dead_cell_with_northwest_fold_over_stays_dead_with_no_neighbors
    evolve_base(0, 0, 0, 0, 0)
    # @game.state = [ [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0],
    #                 [0, 0, 0, 0, 0]
    #               ]
    # after = @game.evolve
    # assert_equal after[0][0], 0
  end
  
  def test_dead_cell_with_northwest_fold_over_stays_dead_with_one_neighbor
    evolve_base(0, 0, 0, 1, 0)
  end
  
  def test_dead_cell_with_northwest_fold_over_stays_dead_with_two_neighbors
    evolve_base(0, 0, 0, 2, 0)
  end
  
  def test_dead_cell_with_northwest_fold_over_regenerates_with_three_neighbors
    evolve_base(0, 0, 0, 3, 1)
  end
  
  def test_dead_cell_with_northwest_fold_over_stays_dead_with_four_neighbors
    evolve_base(0, 0, 0, 4, 0)
  end
  
  def test_dead_cell_with_northwest_fold_over_stays_dead_with_five_neighbors
    evolve_base(0, 0, 0, 5, 0)
  end
  
  def test_dead_cell_with_northwest_fold_over_stays_dead_with_six_neighbors
    evolve_base(0, 0, 0, 6, 0)
  end
  
  def test_dead_cell_with_northwest_fold_over_stays_dead_with_seven_neighbors
    evolve_base(0, 0, 0, 7, 0)
  end
  
  def test_living_cell_with_northwest_fold_over_stays_dead_with_eight_neighbors
    evolve_base(0, 0, 0, 8, 0)
  end    
  
  
  
  
  
  def test_state_should_update_rows_and_columns
    @game.state = [ [0, 0, 0, 0, 0, 0, 0],
                    [0, 1, 1, 1, 0, 0, 0],
                    [0, 1, 0, 1, 0, 0, 0],
                    [0, 1, 1, 1, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0]
                  ]
    assert_equal @game.rows, 5
    assert_equal @game.columns, 7
  end
  


end
