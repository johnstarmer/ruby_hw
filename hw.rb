#hw.rb
require 'sinatra'

get '/:name' do
  name="World"
  erb :index
end

get '/' do
  name="World"
  erb :index
end
