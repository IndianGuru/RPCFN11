class GameEvolutionRule
  def calculate_status(opts)
    status = opts[:status]
    neighbours = opts[:neighbours]
    send('calculate_for_' + status.to_s, neighbours)    
  end
  
  def calculate_for_live(neighbours)
    (2..3).include?(neighbours) ? :live : :dead
  end
  
  def calculate_for_dead(neighbours)
    neighbours == 3 ? :live : :dead
  end
end
