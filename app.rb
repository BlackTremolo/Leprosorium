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
	created_date DATA,
	content	TEXT,
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

	# проверка на пустое поле
  	if content.length <= 0 
  		@error = 'Type text'
  		return erb :new
	end
	
	# сохранение данных в БД
	@db.execute 'insert into Posts (content, created_date) values (?, datetime ())', [content]

	redirect to '/'
end

get '/post/:post_id' do
	post_id = params[:post_id]

	erb "Displaying information for post with id #{post_id}"
end