#!/usr/bin/env ruby

require 'test/unit'
require 'stevehindmarch'

#
# Coding a game of life solution to ruby challenge:
# http://rubylearning.com/blog/2010/06/28/rpcfn-the-game-of-life-11/
#
# Author:: Stephen J Hindmarch
# Copyright:: British Telecommunications PLC (c) 2010
# License:: Distributed under the terms of the challenge
#
# - $URL: https://svn.coolworld.bt.co.uk/svn/sjh/trunk/ruby/test_game_of_life.rb $
# - $Author: sjh $
# - $Date: 2010-07-29 10:19:44 +0100 (Thu, 29 Jul 2010) $
# - $Revision: 253 $
#
# Unit testing class for GameOfLife.
# Unit tests begin by ensuring a well formed universe can be created, set
# saved, loaded and examined.
#
# The algorithm was deliberately broken down so that each step could be tested
# in isolation and without the need to create a universe. The evolutionary
# cycle is tested as a whole using the test cases supplied in the challenge.
#
# There are a set of test cases that check edge conditions, such as using
# a trivial or badly formed universe.
#

class GameTest < Test::Unit::TestCase
  def setup
    @game = GameOfLife.new(3)
  end

  def measure_universe state,width,height
    assert_equal height,state.length
    state.each do |row|
      assert_equal width,row.length
    end
  end

  def weigh_universe state
    weight=0
    state.each do |row|
      row.each do |x|
	weight+=x
      end
    end
    return weight
  end

  def test_create
    state=@game.state
    measure_universe state,3,3
  end

  def test_set_state
    state=[[0,0,1],[0,1,1],[1,1,1]]
    @game.state=state
    assert_equal state,@game.state
  end

  # Test the save and load features
  def test_serialize
    first=[[0,0,0],[0,0,0],[0,0,0]]
    f1='test_first.sav'

    second=[[0,1,0],[1,0,1],[0,1,0]]
    f2='test_second.sav'

    @game.state=first
    @game.save f1
    @game.state=second
    @game.save f2

    @game.load f1
    assert_equal first,@game.state

    @game.load f2
    assert_equal second,@game.state

    File.delete('test_first.sav')
    File.delete('test_second.sav')
  end

  # Test that you can create non-square universes
  def test_create_rectangle
    game=GameOfLife.new(4,6)
    measure_universe game.state,4,6

    game.populate(7,5)
    measure_universe game.state,7,5
  end

  # Test that the density value gives expected results
  def test_density
    game=GameOfLife.new(3,3,100)
    assert_equal 9,weigh_universe(game.state)

    game.populate(3,3,0)
    assert_equal 0,weigh_universe(game.state)

    # This test will fail just through randomness 2 in 2^100 times
    game.populate(10,10,50)
    weight=weigh_universe(game.state)
    assert weight<100
    assert weight>0
  end

  # Test that setting seed produces predictable universes
  def test_seed
    @game.populate(3,3,50,0)
    zero=@game.state

    @game.populate(3,3,50,1)
    assert_not_equal zero,@game.state

    @game.populate(3,3,50,0)
    assert_equal zero,@game.state
  end

  # Check the rules for what happens in the next generation.
  def test_life_algorithm
    assert_equal 0,@game.next_life_state(0,0)
    assert_equal 0,@game.next_life_state(1,0)
    assert_equal 0,@game.next_life_state(2,0)

    assert_equal 0,@game.next_life_state(0,2)
    assert_equal 1,@game.next_life_state(1,2)
    assert_equal 0,@game.next_life_state(2,2)

    assert_equal 1,@game.next_life_state(0,3)
    assert_equal 1,@game.next_life_state(1,3)
    assert_equal 0,@game.next_life_state(2,3)

    assert_equal 0,@game.next_life_state(0,4)
    assert_equal 0,@game.next_life_state(1,4)
    assert_equal 0,@game.next_life_state(2,4)
  end

  # Check the method for counting up a cell's neighbours. Especially check
  # that edge wrapping works as expected.
  def test_neighbour_count
    # Empty
    @game.state=[[0,0,0],[0,0,0],[0,0,0]]
    assert_equal 0,@game.neighbour_count(0,0)
    assert_equal 0,@game.neighbour_count(1,1)

    # One cell, check all neighbours, check proper edge wrapping
    @game.state=[[0,0,0],[0,1,0],[0,0,0]]
    assert_equal 1,@game.neighbour_count(0,2),'0,2'
    assert_equal 1,@game.neighbour_count(0,0),'0,0'
    assert_equal 1,@game.neighbour_count(0,1),'0,1'
    assert_equal 1,@game.neighbour_count(1,0),'1,0'
    assert_equal 0,@game.neighbour_count(1,1),'1,1' # Don't count self
    assert_equal 1,@game.neighbour_count(1,2),'1,2'
    assert_equal 1,@game.neighbour_count(2,0),'2,0'
    assert_equal 1,@game.neighbour_count(2,1),'2,1'
    assert_equal 1,@game.neighbour_count(2,2),'2,2'

    # Eight cells, check all neighbours, check proper edge wrapping
    @game.state=[[1,1,1],[1,0,1],[1,1,1]]
    assert_equal 7,@game.neighbour_count(0,2),'0,2'
    assert_equal 7,@game.neighbour_count(0,0),'0,0'
    assert_equal 7,@game.neighbour_count(0,1),'0,1'
    assert_equal 7,@game.neighbour_count(1,0),'1,0'
    assert_equal 8,@game.neighbour_count(1,1),'1,1' # Only cell with 8
    assert_equal 7,@game.neighbour_count(1,2),'1,2'
    assert_equal 7,@game.neighbour_count(2,0),'2,0'
    assert_equal 7,@game.neighbour_count(2,1),'2,1'
    assert_equal 7,@game.neighbour_count(2,2),'2,2'
  end

  #Evolve test taken from original challenge code
  def test_should_kill_with_no_neighbours
    @game.state = [[1,0,0],[0,0,0],[0,0,0]]
    after = @game.evolve
    assert_equal 0,after[0][0]
  end

  #Evolve test taken from original challenge code
  def test_should_kill_with_just_one_neighbour
    @game.state = [[0,0,0],[1,0,0],[1,0,0]]
    after = @game.evolve
    assert_equal 0,after[1][0]
    assert_equal 0,after[2][0]
  end

  #Evolve test taken from original challenge code
  def test_should_kill_with_more_than_3_neighbours
    @game.state = [[1,1,1],[1,1,1],[1,1,1]]
    after = @game.evolve
    assert_equal [[0,0,0],[0,0,0],[0,0,0]],after
  end

  #Evolve test taken from original challenge code
  def test_should_give_birth_if_3_neighbours
    @game.state = [[1,0,0],[1,1,0],[0,0,0]]
    after = @game.evolve
    assert_equal [[1,1,1],[1,1,1],[1,1,1]],after
  end

  # Test that a rectangular matrix works
  def test_rectangle
    # A simple rectangle with more rows than columns
    @game.state = [[0,0],[0,0],[0,0]]
    after = @game.evolve
    assert_equal [[0,0],[0,0],[0,0]],after

    # A bigger rectangle with more columns than rows
    # and some life
    @game.state = [[0,0,0,0],[1,1,0,0],[0,0,0,1]]
    after = @game.evolve
    assert_equal [[1,0,0,0],[1,0,0,0],[1,0,0,0]],after
  end

  # Test trivial games of size 0 and 1
  def test_trivial
    @game.state=[]
    assert_equal [],@game.evolve
    @game.state=[[0]]
    assert_equal [[0]],@game.evolve
  end

  # Test robustness to badly formed games
  def test_robust
    # expected result
    expected=[[0,0,0],[0,0,0],[0,0,0]]

    # A non-rectangular game
    @game.state=[[0,0,0],[0,0],[0,0,0]]
    assert_equal expected,@game.evolve

    # A game with illegal values
    @game.state=[[0,0,'fred'],[0,nil,0],[0,43,0]]
    assert_equal expected,@game.evolve
  end

end
