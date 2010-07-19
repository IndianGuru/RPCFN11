class GameOfLife < Array
  def initialize(*args)
    debug '03' if $DEBUG # added for debug by ashbb
    width, height, seeds = if args.last.is_a? Hash
      [args.last[:size] || args.last[:width] || args[0..-2][0] || 5,
        args.last[:size] || args.last[:height] || args[0..-2][1] || args[0..-2][0] || 5,
        args.last[:seeds] || args[0..-2][2] || 10]
    else
      [args[0] || 5, args[1] || args[0] || 5, args[2] || 100] # replaced from 10 to 100 for 20x20 cells visualization by ashbb
    end
    width = width.to_i <= 0 ? 5 : width.to_i
    height = height.to_i <= 0 ? 5 : height.to_i
    seeds = seeds.to_i <= 0 ? 10 : seeds.to_i
    if seeds >= width * height
      super height do |index|
        Array.new width, 1
      end
    else
      super height do |index|
        Array.new width, 0
      end
      seeds.times do |i|
        x = y = nil
        begin
          x = rand(width)
          y = rand(height)
        end while self[y][x] == 1
        self[y][x] = 1
      end
    end
  end
  
  def state=(arr)
    replace arr
  end
  
  def dup
    Array.new length do |index|
      self[index].dup
    end
  end
  
  def evolve
    future = dup
    each_with_index do |arr, y|
      arr.each_with_index do |e, x|
        sum = -e
        (-1..1).each do |dy|
          (-1..1).each do |dx|
            row = self[y + dy] || self[0]
            sum += row[x + dx] || row[0]
          end
        end
        case sum
          when 2..3
            future[y][x] = 1 if e == 0 && sum == 3
          else
            future[y][x] = 0
        end
      end
    end
    replace future
  end
end