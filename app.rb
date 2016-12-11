require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/new' do
  erb :new
end
