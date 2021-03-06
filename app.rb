#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

# Initialize database
def init_db()
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end
# Before вызывается каждый раз при перезагрузке любой страницы

before do
	init_db()
end

# Вызывается каждый раз при конфигурации приложения 
# И когда изменился код программы и перезагрузилась страница
configure do
	init_db()
	# Создает таблицу если таблицы не сущетсвует
	@db.execute 'CREATE TABLE IF NOT EXISTS 
	Posts
	(
		"id" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,
		"created_date" Date,
		"content" Text 
	)'
	@db.execute 'CREATE TABLE IF NOT EXISTS 
	Comments
	(
		"id" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,
		"created_date" Date,
		"content" Text,
		"post_id" Integer 
	)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/posts' do
	@result = @db.execute 'Select * from Posts order by id desc'
	erb :posts
end

get '/new_posts' do
	erb :newposts
end

post '/new_posts' do
	new = params[:new_post]
	
	if new.length <= 0
		@error = "Type text"
		return erb :newposts
	end
# Сохранение данных в БД
	@db.execute 'insert into posts
	(content, created_date) 
	
	values(?, datetime());', [new]
	redirect to '/posts'
end

get '/details/:post_id' do
	# получаем переменную из URL
	post_id = params[:post_id]
	# Получаем один пост с помощью id
	get_post = @db.execute 'Select * from Posts WHERE id=?', [post_id]
	# В массиве который получили выбираем первый элемент с хешем
	@row = get_post[0]

	@get_comments = @db.execute 'Select * from Comments WHERE post_id=? order by id', [post_id]
	erb :details
end

# Обработчик POST запроса /posts/....
# Браузер отправляет данные мы их принимаем

post '/details/:post_id' do
	post_id = params[:post_id]
	content = params[:details_comments]
	@db.execute 'insert into comments(content, post_id, created_date)
	values(?, ?, datetime())', [content, post_id]
	redirect to ('/details/' + post_id)
end