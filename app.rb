# app.rb
require 'sinatra'
require './boot'

set :sessions, true
set :session_secret, SESSION_SECRET

enable :sessions

get '/' do
  haml 'welcome/index'.to_sym
end

get '/data.json' do
  content_type :json
  Item.chart_values.to_json
end

get '/water-level.json' do
  content_type :json
  { waterLevel: Item.all.last.payload['wat'].to_i }.to_json
end

post '/take-action' do
  CLIENT.publish('raspi-water-pump/data', {state:{pump: params['action']}}.to_json)
  200
end