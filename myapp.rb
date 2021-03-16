# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'

helpers do
  include ERB::Util
  def h(text)
    escape_html(text)
  end
end

def take_all_memos
  Dir.glob('memos/*').map { |m| JSON.parse(File.read(m)) }
end

get '/' do
  @memos = take_all_memos
  erb :index
end

get '/memos' do
  erb :memo
end

def create_memo(title, body)
  created_memo = {
    id: SecureRandom.uuid,
    title: title,
    body: body
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
  memos = take_all_memos
  @memo = memos.find { |memo| memo['id'] == id }
end

get '/memos/:id' do |n|
  @memo = get_memo(n)
  erb :single_memo
end

get '/memos/:id/edit' do |n|
  @memo = get_memo(n)
  erb :edit
end

def check_arrays(id)
  check_arrays = Dir.glob('memos/*')
  if check_arrays.include?("memos/#{id}.json")
    true
  else
    false
  end
end

def edit_memo(id, title, body)
  edited_memo = { id: id, title: title, body: body }
  if check_arrays(id)
    File.open("memos/#{edited_memo[:id]}.json", 'w') do |m|
      m.puts JSON.pretty_generate(edited_memo)
    end
  end
end

patch '/memos/:id/edit' do |id|
  edit_memo(id, params['title'], params['body'])
  redirect '/'
end

def delete_memo(id)
  File.delete("memos/#{id}.json") if check_arrays(id)
end

delete '/memos/:id' do |id|
  delete_memo(id)
  redirect '/'
end

not_found do
  'このページは存在しません。トップページにお戻りください。'
end
