require 'sinatra'
require 'redis'
require 'haml'
require 'coffee_script'
require_relative 'models'

enable :sessions

DATE_FORMAT = "%d.%m.%Y"

get '/login' do
  redirect '/' if logged_in?
  haml :login
end

post '/login' do
  redirect '/' if logged_in?
  if login_valid?(params[:name])
      and password_valid?(params[:pass])
      and User.valid?(params[:name], params[:pass])
    session[:name] = params[:name]
    return "true"
  else
    return "false"
  end
end

get '/logout' do
  session[:name] = nil
  redirect '/login'
end

get '/register' do
  haml :register
end

post '/register' do
  if params[:pass1] == params[:pass2]
    User.register(params[:name], params[:pass])
  end
end

get '/' do
  redirect '/login' unless logged_in?
  now = Time.now
  @days = (1..now.day).map do |day|
    str_day = Time.mktime(now.year, now.month, day).strftime(DATE_FORMAT)
    items = Item.get_all str_day
    {day: str_day, items: items}
  end.reject{|day| day[:items].empty? }.reverse

  @balance = "%.2f" % Balance.current(session[:name])
  haml :index
end

post '/' do
  @item = {"title" => params[:title].to_s, "price" => params[:price].to_f}
  Item.create Time.now.strftime(DATE_FORMAT), @item
  partial :_item, item: @item
end

get '/balance' do
  "%.2f" % Balance.current(session[:name]) if loggen_in?
end

get '/app.js' do
  coffee :app
end

helpers do
  def logged_in?
    !session[:name].nil?
  end
end

module Partials
  def partial( page, variables={} )
    haml page.to_sym, {layout:false}, variables
  end
end

helpers Partials
