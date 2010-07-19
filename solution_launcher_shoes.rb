# solution_launcher_shoes.rb

Shoes.app title: 'The Game of Life', width: 300, height: 350 do
  background greenyellow..deeppink, angle: 45
  style Link, fill: nil, underline: nil, stroke: saddlebrown
  style LinkHover, fill: nil, underline: nil, weight: 'bold'
  
  ::GameOfLife = ''
  $DEBUG = true
  
  tagline 'RPCFN#11 all solutions!', align: 'center', stroke: crimson
  
  stack height: 300, scroll: true do
    Dir.glob('solutions/*').each do |folder|
      name = File.basename folder
      para link(name.gsub('_', ' ')){
        Dir.chdir(folder){
          Object.send :remove_const, :GameOfLife
          $SOLUTION = name
          load '../../life_shoes.rb'
        }
      }
    end
  end
end
