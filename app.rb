#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/posts' do
	erb :posts
end

get '/new_posts' do
	erb :newposts
end

post '/new_posts' do
	new = params[:new_post]
	
	erb "You Typed: #{new}"
end