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

    @db.execute 'CREATE TABLE IF NOT EXISTS Comments
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_date DATE,
      content TEXT,
      post_id INTEGER
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

  # получаем переменную из url'a
  post_id = params[:post_id]

  # получаем список постов (у нас будет список из 1-го поста)
  results = @db.execute 'SELECT * FROM Posts where id = ?', [post_id]
  # выбираем этот 1 (один) пост
  @row = results[0]


  #комментарии к посту
  @comments = @db.execute 'SELECT * FROM Comments WHERE post_id = ? order by created_date asc', [post_id]

  erb :details
end

# добавление новых комментариев
post '/details/:post_id' do
  # получаем переменную из url'a
  post_id = params[:post_id]

  # получаем переменную из post-запроса
  content = params[:content]

  # сохранение данных (комментарии) в БД
  @db.execute 'insert into Comments
    (
      content,
      created_date,
      post_id
    )
      values 
    (
      ?,
      datetime(),
      ?
    )', [content, post_id]

  erb "You typed #{content} for post #{post_id}"

  # перенаправляем на страницу поста
  redirect to('/details/' + post_id)

end
