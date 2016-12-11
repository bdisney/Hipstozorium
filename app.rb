require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'hipstozorium.db'
  @db.results_as_hash = true
end

# вызывается каждый раз при обновлении страницы
before do
#инициализация БД  
  init_db
end

configure do
  init_db
  @db.execute 'CREATE TABLE IF NOT EXISTS Posts
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_date DATE,
      content TEXT
    )'
end

get '/' do
  # выбираем список постов из БД

  @results = @db.execute 'SELECT * FROM Posts order by created_date desc'
  
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]

  if content.length <= 0
    @error = 'Type post text'
    return erb :new
  end

# сохранение данных в БД
  @db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

  redirect to '/'
end

# вывод инф-ии о посте
get '/details/:post_id' do
  post_id = params[:post_id]
  erb "Displaing results information for post with id #{post_id}"
end