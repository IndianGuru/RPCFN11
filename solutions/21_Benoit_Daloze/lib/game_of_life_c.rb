# This is mainly a C extension based on game_of_life_fast code
# The speed up is made by neighbors and evolve, other methods are translated for learning
# The data is wrapped in Ruby instance variables

require File.expand_path('../../ext/game_of_life_c', __FILE__)
