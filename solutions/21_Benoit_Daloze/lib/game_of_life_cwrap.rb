# This is mainly a C extension based on game_of_life_fast code
# The speed up is made by neighbors and evolve, other methods are translated for learning
# The data is wrapped in C structs

require File.expand_path('../../ext_wrap/game_of_life_cwrap', __FILE__)
