module SeedData
  class << self
    def read(file_name)
      raise "#{file_name} is not a file" unless File.file?(file_name)
      raise "#{file_name} is not readable" unless File.readable?(file_name)
      
      lines = IO.readlines(file_name)
      lines = lines.reject { |line| line =~ /^\s+$/ }
      lines.each {|line| line.gsub!(/\s+/, '')}
      
      rows = lines.size
      columns = lines[0].size
      result = [rows, columns]
      rows.times do |i|
        columns.times do |j|
          result << [i, j] if lines[i][j] == '#' or lines[i][j] == '*'
        end
      end
      
      result
    end
  end
end
