# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'pg'
require './memo'

helpers do
  include ERB::Util
  def h(text)
    escape_html(text)
  end
end

get '/' do
  @memo = Memo.new
  @memos = @memo.load_all_memos
  erb :index
end

get '/memos' do
  erb :memo
end

post '/memos' do
  memo = Memo.new
  memo.create_memo(params['title'], params['body'])
  redirect '/'
end

get '/memos/:id' do |id|
  memo = Memo.new
  @memo = memo.find_memo(id)
  erb :single_memo
end

get '/memos/:id/edit' do |id|
  memo = Memo.new
  @memo = memo.find_memo(id)
  erb :edit
end

patch '/memos/:id/edit' do |id|
  memo = Memo.new
  memo.update_memo(id, params['title'], params['body'])
  redirect '/'
end

delete '/memos/:id' do |id|
  memo = Memo.new
  memo.delete_memo(id)
  redirect '/'
end

not_found do
  'このページは存在しません。トップページにお戻りください。'
end
