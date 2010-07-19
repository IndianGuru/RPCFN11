## Ruby Programming Challenge: Game of Life ##

You can read in http://www.math.com/students/wonders/life/life.html about the Game of Life.

Yesterday I posted my first solution to this challenge (https://gist.github.com/f787d117565ed529c8a5)
in wich I didn't take into account a folded board, I didn't actually know how to do that, but after
some reading on this topic I discover that there are actually two main models to this game:

* torus model in which all boundaries have cyclic boundary conditions that wrap the universe back on itself as in a torus.
* box model in which each edges does not contribute any count to the living cell.

Those are the basic models, some variations do exists but this implementation of the game doesn't take them into account.

The important thing to note about this game is that for every cell you have to take into account just the 8 neighborhoods
of it, so, this implementation of the game creates a board that adds 2 more rows and 2 more columns to the initial board.
Example:
Initial seed   visual board   folded board
------------   ------------   ------------
                                0 0 0 0 0
   * . .          1 0 0         0 1 0 0 1
   * * .          1 1 0         0 1 1 0 1
   . . .          0 0 0         0 0 0 0 0
                                0 1 0 0 1
                                
The way going from the visual board to the folded board is as follows:

* copy on the first row of the folded board the last row of the visual board
* copy on the last row of the folded board the first row of the visual board
* copy on the first column of the folded board the last column of the visual board
* copy on the last column of the folded board the first column of the visual board
* copy on the north-left corner of the folded board the south-east corner of the visual board
* copy on the north-right corner of the folded board the south-west corner of the visual board
* copy on the south-west corner of the folded board the north-east corner of the visual board
* copy on the south-east corner of the folded board the north-west corner of the visual board

In this manner, the game is fully specified because for every cell in the visual board (effectively the work board)
there are 8-neighborhoods in the folded board, so we can work our way through the game easily, everytime life evolves
the folded board is updated and the neighborhoods are calculated from there, in this manner we can simulate the cyclic
boundaries condition of the torus model.

Anyway, this implementation gives you the possibility of choosing your model (one of box or torus), the image above
explain how the folded board is constructed in the case of a torus model, for a box model this is not required and in
the implementation I just put 0s in the respective positions of the folded board.

Files of this implementation:
README              => This file you are reading
game_of_life.rb     => This is the implementation of the game of life, is where we construct our boar, calculate
                       neighborhoods and evolve.
play_game.rb        => This is a simple class to play the game, it asks all the data needed (rows, columns, initial seed and model)
                       and starts a new game in the console.
seed_data.rb        => This is a module that PlayGame includes to read seed data from a file. 
                       You can find seed data in http://www.radicaleye.com/lifepage/glossary.html
game_of_life_script => This puts the game in motion

Thanks to rubylearning.com for giving this to the community, had a lot of fun doing this, so, keep up the good work.