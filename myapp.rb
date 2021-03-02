require 'sinatra'
require 'sinatra/reloader'
require 'erb'
include ERB::Util

helpers do
  def h(text)
    escape_html(text)
  end
end

get '/' do
  all_memos = Dir.glob('memos/*')
  @memos = all_memos.map { |m| JSON.parse(File.read(m)) }
  erb :index
end

get '/memos' do
  erb :memo
end

def create_memo(title, body)
  created_memo = {
    id: SecureRandom.uuid,
    title: h(title),
    body: h(body)
  }
  File.open("memos/#{created_memo[:id]}.json", 'w') do |m|
    m.puts JSON.pretty_generate(created_memo)
  end
  redirect '/'
end

post '/memos' do
  create_memo(params['title'], params['body'])
end

def get_memo(id)
  all_memos = Dir.glob('memos/*')
  @memos = all_memos.map { |m| JSON.parse(File.read(m)) }
  @memos.each do |m|
    @memo = m if m['id'] == id
  end
  @memo
end

get '/memos/:id' do |n|
  @memo = get_memo(n)
  erb :single_memo
end

get '/memos/:id/edit' do |n|
  @memo = get_memo(n)
  erb :edit
end

def edit_memo(id, title, body)
  edited_memo = {
    id: id,
    title: h(title),
    body: h(body)
  }
  File.open("memos/#{edited_memo[:id]}.json", 'w') do |m|
    m.puts JSON.pretty_generate(edited_memo)
  end
  redirect '/'
end

patch '/memos/:id/edit' do |n|
  edit_memo(params['id'], params['title'], params['body'])
end

def delete_memo(m)
  File.delete("memos/#{m}.json")
  redirect '/'
end

delete '/memos/:id' do |n|
  delete_memo(n)
end

not_found do
  'このページは存在しないでやんす、ブラウザの「戻るボタンを押すでやんす」'
end
