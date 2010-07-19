#I have included in this file the GameOfLife class as well as the supplied
#(but slightly modified) LifeNcurses class. See end of file for example of
#running a curses demonstration of my GameOfLife class.
#Thanks for running this challenge!

class GameOfLife
  
  attr_accessor :state, :width, :height
  
  def initialize(*size)
    debug '13' if $DEBUG # added for debug by ashbb
    if (size.length == 2 && size[0].class == Fixnum && size[1].class == Fixnum)
      #if passed 2 numbers, create a grid with those sizes
      @width, @height = size[0], size[1]
    elsif (size.length == 1 && size[0].class == Fixnum)
      #if passed 1 number, create a square grid of that size
      @width = @height = size[0]
    elsif (size.all? {|i| i.class == Array} && size.map{|i| i.length}.uniq.length == 1)
      #if passed a grid as an array, create that grid
      #checks that all elements of size are arrays and are all of the same length
      @state, @height, @width = size, size.length, size[0].length
      return
    else
      #otherwise, create a 'standard' 5x5 grid
      @width = 5
      @height = 5
    end
    #Code to create grid array
    @state = []
    @height.times do
      arr = []
      @width.times {arr << rand(2)}
      @state << arr
    end
  end
  
  def evolve
    #return the next generation of the game of life (via evolve_internal method)
    evolve_internal
  end
  
  def evolve # changed method name for shoes visualization by ashbb
    #return next generation and update state to next generation
    @state = evolve_internal
  end
  
  protected
  
  def evolve_internal
    #generates new 2-dimensional array of dimensions @width x @height
    #that is set to values of next generation of game of life
    #by checking through existing state of game via cellcheck method
    arr = []
    @height.times do |row|
      row_array = []
      @width.times {|col| row_array << cellcheck(row,col)}
      arr << row_array
    end
    arr
  end
  
  def cellcheck(row,col)
    #For a cell at row,col checks each of the eight cells surrounding it and counts all of the live cells
    #Uses check_for_border method to look across the edges of the game board
    count = 0
    (-1..1).each do |row_offset|
      (-1..1).each do |col_offset|
        unless (row_offset == 0 && col_offset == 0)
          row_to_check = check_for_border(row + row_offset,@height)
          col_to_check = check_for_border(col + col_offset,@width)
          count += 1 if (@state[row_to_check][col_to_check]) == 1
        end
      end
    end
    return 0 if @state[row][col] == 1 && (count < 2 || count > 3)
    return 1 if @state[row][col] == 1 && (count == 2 || count == 3)
    return 1 if @state[row][col] == 0 && count == 3
    0
  end
  
  def check_for_border(position,size)
    position = size - 1 if position == -1
    position = 0 if position == size
    position
  end
  
end

# commented out the following for shoes visualization by ashbb

=begin
require 'rubygems'
require 'ffi-ncurses'

class LifeNcurses

  # spaces from the border of the terminal
  MARGIN = 2
  include FFI::NCurses

  def initialize(game_of_life,iterations=100)
    @stdscr = initscr
    cbreak
    (1..iterations).each do |generation|
      clear
      display_title(generation)
      show game_of_life.evolve! #modified to use evolve! method rather than evolve
    end
  ensure
    endwin
  end

  def show(state)
    state.each_with_index do |row,row_index|
      row.each_with_index do |col, col_index|
        mvwaddstr @stdscr, row_index+MARGIN, col_index+MARGIN, '#' if state[row_index][col_index] == 1
      end
    end
    refresh
    sleep 1
  end

  def display_title(generation)
    mvwaddstr @stdscr, 0, 1, "Game of life: Generation #{generation}"
  end

end

#Uncomment line below and run 'ruby game_of_life.rb' to see curses demonstration

#LifeNcurses.new(GameOfLife.new(50,10),20)
=end
