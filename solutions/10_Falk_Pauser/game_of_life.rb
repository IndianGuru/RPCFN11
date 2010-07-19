class GameOfLife

  attr_reader :width, :height, :cells

  def initialize(width = 5, height = 20, seed = 20) # edited default values for shoes visualization by ashbb
    debug '10' if $DEBUG # added for debug by ashbb
    raise ArgumentError.new "Seed must be < than width x height!" if seed >= width * height
    @width, @height = width, height
    @cells = Array.new(width * height, 0)
    @cells[rand(cells.size)] = 1 while cells.select{|c| c == 1}.size < seed
  end

  def state
    rows = []
    cells.each_with_index do |cell, index|
      rows << [] if index % width == 0
      rows.last << cell
    end
    rows
  end

  def state=(rows)
    raise ArgumentError.new "Rows must be an array of rows" unless rows.is_a?(Array) and rows.select{|r| r.is_a?(Array)}.size == rows.size
    raise ArgumentError.new "All rows must be of equal size!" unless rows.map{|r| r.size}.uniq.size == 1
    raise ArgumentError.new "Row-values must be 0 or 1" unless (rows.flatten.uniq - [0,1]).empty?
    @cells, @width, @height = rows.flatten, rows.first.size, rows.size
  end

  def evolve
    evolved = Array.new( cells.size, 0 )

    cells.each_with_index do |cell, index|
      nb = neighbours(index)
      living_nb = nb.select{|p| cells[p] == 1}.size
      case
        when cell == 1 && living_nb  < 2; evolved[index] = 0; nb.each{ |p| evolved[p] = 0 } 
        when cell == 1 && living_nb  > 3; evolved[index] = 0; nb.each{ |p| evolved[p] = 0 }
        when cell == 1 && living_nb == 2; evolved[index] = 1;
        when cell == 1 && living_nb == 3; evolved[index] = 1;
        when cell == 0 && living_nb == 3; evolved[index] = 1; nb.each{ |p| evolved[p] = 1 }
      end
    end

    @cells = evolved
    state
  end

  def neighbours(pos)
    [north(pos), north_east(pos),
     east(pos),  south_east(pos),
     south(pos), south_west(pos),
     west(pos),  north_west(pos)]
  end

  def north(pos)
    p = pos - width
    p < 0 ? p + cells.size : p
  end

  def south(pos)
    p = pos + width
    p >= cells.size ? p - cells.size : p
  end

  def east(pos)
    p = pos + 1
    p % width == 0 ? pos / width * width : p
  end

  def west(pos)
    p = pos - 1
    pos == pos / width * width ? pos + width - 1 : p
  end

  def north_east(pos); north east(pos); end
  def south_east(pos); south east(pos); end
  def north_west(pos); north west(pos); end
  def south_west(pos); south west(pos); end

end
