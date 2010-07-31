#!/usr/bin/env ruby

# ==Synopsis
# run_game_of_life: Run the game of life in the ncurses client.
#
# == Usage
# run_game_of_life [options]
#
# -?, --help::
#  Show help
#
# -s <s>, --size <s>::
#  Set the width and height of the universe to <s>. Overrides -x and -y.
#
# -w <x>, --width <x>::
#  Set the width of the universe to <x>. Overrides -s. Default is 20
#
# -h <y>, --height <y>::
#  Set the height of the universe to <y>. Overrides -s. Default is 20
#
# -l <file>, --load <file>::
#  Load the universe from a serialized array. Overrides any sizing.
#
# -d <d>, --density <d>::
#  Set the density factor of the universe to <d>. Density is a number between
#  between 0 and 100 describing how densely populated on average the new
#  universe will be: 0 - unpopulated, 100 - fully populated. Default is 50.
#
# -e <s>, --seed <s>::
#  Set the seed for the population randomizer.
#
# -x, --show::
#  Do not run the program, simply show the initial universe.
#

# Require getoptlong to parse command line arguments
require 'getoptlong'

# Reguire rdoc/usage to display help
require 'rdoc/usage'

# Require the game of life class and the ncurses visual client
require File.join(File.dirname(__FILE__), 'stevehindmarch')
require File.join(File.dirname(__FILE__), 'life_ncurses')

#
# Coding a game of life solution to ruby challenge:
# http://rubylearning.com/blog/2010/06/28/rpcfn-the-game-of-life-11/
#
# Author:: Stephen J Hindmarch
# Copyright:: British Telecommunications PLC (c) 2010
# License:: Distributed under the terms of the challenge
#
# - $URL: https://svn.coolworld.bt.co.uk/svn/sjh/trunk/ruby/run_game_of_life.rb $
# - $Author: sjh $
# - $Date: 2010-07-28 17:33:55 +0100 (Wed, 28 Jul 2010) $
# - $Revision: 251 $
#
# Run the game of life in a visual client - the ncurses client supplied
# by the challenge.
#

class GameRunner

  def initialize
    @opts=GetoptLong.new(['--help','-?',GetoptLong::NO_ARGUMENT],
			 ['--size','-s',GetoptLong::REQUIRED_ARGUMENT],
			 ['--height','-h',GetoptLong::REQUIRED_ARGUMENT],
			 ['--width','-w',GetoptLong::REQUIRED_ARGUMENT],
			 ['--load','-l',GetoptLong::REQUIRED_ARGUMENT],
			 ['--density','-d',GetoptLong::REQUIRED_ARGUMENT],
			 ['--seed','-e',GetoptLong::REQUIRED_ARGUMENT],
			 ['--show','-x',GetoptLong::NO_ARGUMENT]
			)
  end

  # Print the current state of the game to screen
  def show game
    game.state.each do |row| 
      row.each do |col|
	print col
      end
      puts
    end
  end

  # Parse the command line options and run the game.
  def run
    #Defaults
    matrix=nil
    run=true
    x=20
    y=20
    d=50
    s=nil

    @opts.each do |opt,arg|
      case opt
      when '--help'
	RDoc::usage
      when '--size'
	size=arg.to_i
	x=size
	y=size
      when '--width'
	x=arg.to_i
      when '--height'
	y=arg.to_i
      when '--seed'
	s=arg.to_i
      when '--density'
	d=arg.to_i
      when '--load'
	matrix=File.open(arg,'r') do |f|
	  Marshal.load(f)
	end
      when '--show'
	run=false
      end
    end

    game=GameOfLife.new(x,y,d,s)
    if matrix
      game.state=matrix 
    end
    if run  
      LifeNcurses.new(game)
    else
      show game
    end
  end

end

GameRunner.new.run
