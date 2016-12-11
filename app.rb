require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'hipstozorium.db'
  @db.results_as_hash = true
end

before do

end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]

  erb "You typed #{content}"
end