require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra-websocket'
require './lib/user'
require './lib/board'
require './lib/task'

class Server < Sinatra::Base
    get '/' do
        erb :index, :locals => { tasks: Task.all }
    end

end