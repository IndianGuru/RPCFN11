require 'rubygems'
require 'sinatra'
require 'haml'
require File.join(File.dirname(__FILE__), 'game_of_life')

get '/game/new' do
  @game = GameOfLife.new(28)
  haml :index
end

get '/game/evolve' do
  @game = GameOfLife.new(28)
  @game.state = Array.new(28){ Array.new(28){ 0 } }
  params[:state].each_pair do |x,row|
    row.each_pair do |y,value|
      @game.state[x.to_i][y.to_i] = value.to_i
    end
  end
  @game.evolve
  haml :index
end

__END__

@@ layout
%html
%h1 Game of Life
= yield

@@ index
%form.game{:action => "/game/evolve"}
  - @game.state.each_with_index do |row, x|
    .row
      - row.each_with_index do |cell,y|
        %input{:type=>"radio", :name => "state[#{x}][#{y}]", :value => 1, :checked => (cell==1)}
  %input{:type => "submit", :value => "evolve"}
%script(type="text/javascript"
          src="http://code.jquery.com/jquery-latest.js")
:javascript
  var refreshId = setInterval(function()
  {
       $('form.game').submit();
  }, 1000);