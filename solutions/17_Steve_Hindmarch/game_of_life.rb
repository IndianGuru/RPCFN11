#!/usr/bin/env ruby
#
# Coding a game of life solution to ruby challenge:
# http://rubylearning.com/blog/2010/06/28/rpcfn-the-game-of-life-11/
#
# Author:: Stephen J Hindmarch
# Copyright:: British Telecommunications PLC (c) 2010
# License:: Distributed under the terms of the challenge
#
# - $URL: https://svn.coolworld.bt.co.uk/svn/sjh/trunk/ruby/game_of_life.rb $
# - $Author: sjh $
# - $Date: 2010-07-28 17:33:55 +0100 (Wed, 28 Jul 2010) $
# - $Revision: 251 $
#
# This class a takes optional size parameters and creates a rectangular
# universe, randomly populated with cells. If you only supply one size you
# get a square universe.
# The cells live and die according to the well known rules of The Game Of Life.
#
# The current state of the universe is encoded in a 2 dimensional array of
# integers, where +0+ means an empty cell and +1+ is a living cell. You can
# supply the universe with your own array.
#
# In this solution I have concentrated on giving the game a robust algorithm
# and allowed it to cope with badly formed universes. A universe that is badly
# formed in one iteration, such as containing illegal values, or being
# non-rectangular, will evolve into a well formed universe in the next
# iteration.

class GameOfLife

  @current_state
  @next_state

  # Create initial universe and randomly populate it with life.
  # +width+:: the width of the universe in cells.
  # +height+:: the height of the universe in cells.
  # +density+:: average population density, as a percentage.
  # +seed+::randon number seed.
  # Raises +ArgumentError+ if the size is <0
  def initialize width=3,height=width,density=50,seed=nil
    if width<0 or height<0
      raise ArgumentError.new('Size must be >= 0')
    end
    populate width,height,density,seed
  end

  # Reset the game by populating it with a new universe.
  # +width+::number of columns.
  # +height+::number of rows.
  # +density+::density value, between 0 and 100.
  # +seed+::randon number seed.
  def populate width=20,height=20,density=50,seed=nil
    if seed
      srand seed
    end

    @current_state=Array.new(height){Array.new(width){
	(rand(100)<density)?1:0
      }
    }
  end

  # Take the universe through one iteration of life. Returns the new
  # state of the universe as 2D array.
  def evolve
    # Prepare new next_state matrix same shape as current matrix
    @next_state=Array.new(@current_state.length){
      Array.new(@current_state[0].length){0}
    }

    # Run through algorithm
    @current_state.each_index{|row| 
      @current_state[row].each_index{|col| calc_next_state(row,col)}}

    # Make next stage of life the current stage
    @current_state=@next_state
  end

  # Set the universe with your own 2D array.
  def state=matrix
    @current_state=matrix
  end

  # Returns the current state of the universe as a 2D array.
  def state
    @current_state
  end

  # Calculate the future for a single cell. Returns the value this cell will 
  # take after the next evolve cycle.
  def calc_next_state row,col
    neighbours=neighbour_count row,col
    @next_state[row][col]=next_life_state @current_state[row][col],neighbours
  end

  # Count the number of live neighbours a cell has.
  def neighbour_count row,col
    neighbours=0
    
    # iterate around the neighbours
    (-1..1).each do |i|
      (-1..1).each do |j|
	# Wrap lower right edge of matrix back to 0
	nrow=(row==@current_state.length-i) ? 0 : row+i
	ncol=(col==@current_state[row].length-j) ? 0 : col+j
	# Do not count current cell
	# Treat illegal values as 0
	if (nrow!=row or ncol!=col) and @current_state[nrow][ncol]==1
	  neighbours += 1
	end
      end
    end
    return neighbours
  end

  # Work out next life state for a cell, given its current state and 
  # that of its neighbours.
  # +current_state+:: 
  #  <tt>0</tt> or <tt>1</tt> depending on whether the cell is alive or dead.
  # +neighbours+:: number of live neighbours - integer in range <tt>0..8</tt>.
  def next_life_state current_state,neighbours
    case current_state
    when 1 then 
      (2..3) === neighbours ? 1 : 0
    when 0 then 
      3 === neighbours ? 1 : 0
    else
      0
    end
  end

  # Save a game pattern by serializing it to a file.
  def save file='GOL.sav'
    File.open(file,'w') do |f|
      Marshal.dump(state,f)
    end
  end

  # Load a game pattern by deserializing it from a file.
  def load file='GOL.sav'
    self.state=File.open(file,'r') do |f|
      Marshal.load(f)
    end
  end

end
