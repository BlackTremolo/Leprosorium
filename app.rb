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
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

# обработчик get запроса /new
get '/new' do
  erb :new
end

# обработчик post запроса /new
post '/new' do
  
  	text = params[:text]

	erb "You tiped #{text}"
end