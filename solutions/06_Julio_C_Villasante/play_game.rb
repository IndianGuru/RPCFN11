require File.join(File.dirname(__FILE__), 'seed_data')
require File.join(File.dirname(__FILE__), 'game_of_life')

class Array
  def second; self[1]; end
  def third; self[2]; end
end

class PlayGame
  include SeedData
  
  def initialize
    model = ask_model
    seed = ask_seed

    @game = GameOfLife.new(:rows => seed.first, 
      :columns => seed.second, :seed => seed.third, :model => model)
  end
  
  def play
    print_title
    puts @game
    iterations = ask_number('Enter number of iterations: ')
    iterations.times do |iteration|
      clear_screen
      @game.evolve
      print_title(iteration.succ)
      puts @game
      sleep 1
    end
  end
  
  private
    def print_title(iteration = 0)
      if iteration == 0
        puts "Game of Life: (Initial Seed)(#{@game.rows - 2}x#{@game.columns - 2} board)"\
          "(#{@game.model} model)"
      else
        puts "Game of Life: (Generation #{iteration})"\
          "(#{@game.rows - 2}x#{@game.columns - 2} board)(#{@game.model} model)"
      end
    end
    
    def ask(question)
      print question
      $stdout.flush
      answer = gets
      exit if answer == nil
      answer.chomp
    end
  
    def ask_number(question)
      answer = ask(question)
      Integer(answer)
    rescue
      puts "#{answer} is not a valid integer value"
      ask_number(question)
    end
    
    def ask_seed
      answer = ask('Enter seed (filename or random for random seed): ')
      if File.file?(answer)
        seed = SeedData.read(answer)
        [seed.shift, seed.shift, seed]
      elsif answer =~ /^random/
        w = ask_number('Enter number of rows: ')
        h = ask_number('Enter number of columns: ')
        [w, h, nil]
      else
        puts "#{answer} is not a valid seed"
        ask_seed
      end
    end
    
    def ask_model
      answer = ask('Enter model name (box or torus): ').to_sym
      if not [:box, :torus].include?(answer)
        puts "#{answer} is not a valid model"
        ask_model
      else
        answer
      end
    end
    
    def clear_screen
      if (RUBY_PLATFORM =~ /win/)
        system('cls')
      else
        system('clear')
      end
    end
end