require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'Leprosorium.db'
	@db.results_as_hash = true
end	

# before вызывается каждый раз при перезагрузке
# любой страницы
before do 
	init_db
end	

# вызывается каждый раз при конфигурации приложения:
# когда изменился код программы И перезагрузке страницы
configure do 
	init_db

# создаёт таблицу , если ее нет, при каждом запуски программы 	
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts (
	ID	INTEGER,
	author TEXT,
	created_date DATA,
	content	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT))'

	@db.execute 'CREATE TABLE IF NOT EXISTS Comments (
	ID	INTEGER,
	created_date DATA,
	content	TEXT,
	post_id INTEGER,
	PRIMARY KEY("ID" AUTOINCREMENT))'
end

# обработчик get запроса /
get '/' do
	
	@results = @db.execute 'select * from Posts order by id desc'
	
	erb :index
end

# обработчик get запроса /new
get '/new' do
  	erb :new
end

# обработчик post запроса /new
post '/new' do
  
  	content = params[:content]
  	author = params[:autor]
	
	# сохранение данных в БД
	@db.execute 'insert into Posts (autor, content, created_date) values (?, ?, datetime ())', [author, content]

	# проверка на пустое поле
	# hh = {:author => 'Type autorname', :content => 'Type text'}
	
	# @error = hh.select {|k,v| params[k] == ""}.values.join(", ")
	
  	if author.length <= 0 
  		@error = 'Type Autorname'
  		return erb :new
	end

  	if content.length <= 0 
  		@error = 'Type text'
  		return erb :new
	end
	
	redirect to '/'
end

get '/post/:post_id' do
	post_id = params[:post_id]

	@results = @db.execute 'select * from Posts where ID = ?', [post_id]
	@row = @results[0]

	@comments = @db.execute 'select * from Comments where post_id = ? order by id',[post_id]

	erb :post
end

post '/post/:post_id' do
	post_id = params[:post_id]
	content = params[:content]	
	
	# if content.length <= 0 
  	#  	@error = 'Type comment'
  	#  	return /post/post_id
	#  end
	
	@db.execute 'insert into Comments 
	(content, created_date, post_id) 
	values (?, datetime (), ?)', [content, post_id]
	
	redirect to('/post/' + post_id)
end