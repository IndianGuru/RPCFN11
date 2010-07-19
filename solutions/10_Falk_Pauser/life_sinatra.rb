require 'rubygems'
require 'sinatra'
require 'json'
require 'game_of_life'

set :views, Proc.new { File.join(root) }

get '/' do
  @state = GameOfLife.new(30, 30, 30).evolve
  erb :"life_sinatra.html"
end

post '/evolve' do
  @gol = GameOfLife.new(3,3,0)
  @gol.state = prepared_params(params[:state]) if params[:state]
  @gol.evolve.to_json
end

def prepared_params(state_params)
  prepared = Array.new(state_params.size)
  state_params.each {|index,row| prepared[index.to_i] = row.map{|v| v.to_i} }
  prepared
end