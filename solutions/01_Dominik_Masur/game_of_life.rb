class GameOfLife
  def initialize(size)
    debug '01' if $DEBUG # added for debug by ashbb
    @size = size
    srand 3465
    @universe = Array.new(@size) {Array.new(@size){rand(2)}}
  end
  def state= state
    @universe = state
  end
  def evolve
    # New Array for the next step
    new_universe = Array.new(@size) {Array.new(@size)}
    @universe.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        # Game of Life Rules
        new_universe[row_index][col_index] = case count_neighbours(row_index, col_index)
        when 0 then 0
        when 1 then 0
        when 2 then @universe[row_index][col_index]
        when 3 then 1
        else 0
        end
      end
    end
    @universe = new_universe
    return @universe
  end
  # Count all alive Neighbours
  def count_neighbours(row_index, col_index)
    neighbours = 0
    neighbours += life_in_cell(row_index - 1, col_index - 1)
    neighbours += life_in_cell(row_index, col_index - 1)
    neighbours += life_in_cell(row_index + 1, col_index - 1)
    neighbours += life_in_cell(row_index - 1, col_index)
    neighbours += life_in_cell(row_index + 1, col_index)
    neighbours += life_in_cell(row_index - 1, col_index + 1)
    neighbours += life_in_cell(row_index, col_index + 1)
    neighbours += life_in_cell(row_index + 1, col_index + 1)
    return neighbours
  end
  # Is there life at these coordinates?
  def life_in_cell row_index, col_index
    row_index = 0 if row_index == @size
    col_index = 0 if col_index == @size
    row_index = @size-1 if row_index == -1
    col_index = @size-1 if col_index == -1
    return @universe[row_index][col_index] || 0
  end
end
