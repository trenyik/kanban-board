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

    post "/tasks/add" do
        title = params['title']
        status = params['status']
        text = params['text']
        user_id = params['user_id']
        board_id = params['board_id']

        board_that_we_found = Board.find(board_id)
        Task.create(title: title, status: status, text: text, user_id: user_id, board_id: board_id )
        erb :single_board, :locals => { matching_board: board_that_we_found }
    end
    
    get '/board/:id' do
        board_id = params['id']
        board_that_we_found = Board.find_by(id: board_id)
        erb :single_board, :locals => { matching_board: board_that_we_found }
    end

end