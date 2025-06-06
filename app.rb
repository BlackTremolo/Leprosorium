require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'Leprosorium.db'
	@db.results_as_hash = true
end	

before do 
	init_db
end	

configure do 
	
	init_db
	
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts (
	ID	INTEGER,
	created_date	DATA,
	content	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT))'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
  erb :new
end

post '/new' do
  
  	text = params[:text]

	erb "You tiped #{text}"
end