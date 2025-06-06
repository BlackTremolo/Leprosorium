require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do  
	erb :about
end 

get '/visit' do  
	erb :visit
end 
get '/contacts' do  
	erb :contacts
end 

post '/visit' do 
	@user_name = params[:username]
	@phone = params[:phone]
	@date_time = params[:datetime]
	@hairdresser = params[:hairdresser]

	f = File.open('./public/users.txt', 'a')
	f.write("User name:#{@user_name}, Phone:#{@phone}, Date and time:#{@date_time}, Hairdresser:#{@hairdresser}\n")
	f.close

	erb :visit
end	 

post '/contacts' do 
	@email = params[:email]
	@message = params[:message]

	f1 = File.open('./public/contacts.txt', 'a' )
	f1.write("Email:#{@email}, Message:#{@message}")
	f1.close

	erb :contacts
end	