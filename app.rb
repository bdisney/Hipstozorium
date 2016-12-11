require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]

  erb "You typed #{content}"
end