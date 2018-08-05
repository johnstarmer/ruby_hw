#hw.rb
require 'sinatra'

get '/name/:name' do
  @name=params['name']
  erb :index
end

get '/:name' do
  @name=params['name']
  erb :index
end

get '/' do
  name="World"
  erb :index
end
