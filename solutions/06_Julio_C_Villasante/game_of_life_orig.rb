class GameOfLife
  attr_reader :rows, :columns, :model
  
  def initialize(args)
    w = args[:rows]    || 5
    h = args[:columns] || 5
    s = args[:seed]    || random_seed(w, h)
    m = args[:model]   || :torus
    
    @rows, @columns = w + 2, h + 2
    @model = m
    @board = new_board
    s.each { |first, second| @board[first + 1][second + 1] = true }
  end
  
  def evolve
    board = new_board
    fold_board if @model == :torus
    @rows.times do |row|
      next if row == 0 or row == @rows - 1
      @columns.times do |col|
        next if col == 0 or col == @columns - 1
        neighbours = neighbours_number(row, col)
        board[row][col] = 
          if ((neighbours < 2 || neighbours > 3) and (@board[row][col] == true))
            false
          elsif ((neighbours == 3) and (@board[row][col] == false))
            true
          else
            @board[row][col]
          end
      end
    end
    @board = board
  end
  
  def to_s
    result = ''
    @board[1..-2].each do |row|
      row[1..-2].each do |value|
        result << (value ? ' #' : ' .')
      end
      result << "\n"
    end
    result
  end
  
  private
    def new_board
      Array.new(@rows) { Array.new(@columns, false) }
    end
  
    def random_seed(rows, columns)
      seed = []
      rows.times do |i|
        columns.times do |j|
          seed << [i, j]
        end
      end
      seed.shuffle[0, rand(rows * columns)]
    end
    
    def neighbours_number(row, col)
      count = 0
      Range.new(row - 1, row + 1).each do |i|
        Range.new(col - 1, col + 1).each do |j|
          count = count.succ if ((i != row || j != col) and (@board[i][j] == true))
        end
      end
      count
    end
    
    def fold_board
      @rows.times do |row|
        next if row == 0 or row == @rows - 1
        @board[row][0] = @board[row][-2]
        @board[row][-1] = @board[row][1]
      end
      @columns.times do |col|
        next if col == 0 or col == @columns - 1
        @board[0][col] = @board[-2][col]
        @board[-1][col] = @board[1][col]
      end
      @board[0][0] = @board[-2][-2]
      @board[0][-1] = @board[-2][1]
      @board[-1][0] = @board[1][-2]
      @board[-1][-1] = @board[1][1]
    end
end


