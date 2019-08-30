require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra-websocket'
require './lib/user'
require './lib/board'
require './lib/task'

class Server < Sinatra::Base
    get '/' do
        erb :boards, :locals => { boards: Board.all }
    end

    post "/boards" do
        Board.create(title: params['title'])
        erb :boards, :locals => {boards: Board.all}
    end
end