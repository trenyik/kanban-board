require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra-websocket'
require './lib/user'
require './lib/board'
require './lib/task'

class Server < Sinatra::Base

    set :sockets, Hash.new

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

    get '/board/:id/socket' do |board_id|
        request.websocket do |ws|
            ws.onopen do
                if settings.sockets.key?(board_id)
                    settings.sockets[board_id] << ws
                else
                    settings.sockets[board_id] = [ws]
                end
            end

            ws.onmessage do |msg|
                action,message = msg.split("<*>")
                if action == "create"
                    board_id,text,user_id = message.split("|")
                    task = Task.create(title: "task", text: text, user_id: user_id, status: "to-do", board_id: board_id)
                elsif action == "update"

                elsif action == "delete"

                end
                # board_id, colname = text.split("|")
                # board = Board.find(board_id)
                # task = Task.find(task_id)
                # previous_colname = task.colname
                # task.colname = colname
                # task.status = colname == "done" ? "done" : "pending"
                # task.save
                settings.sockets[board_id].each { |ws| ws.send([task.id, task.status, task.text, task.user_id].join("|"))}
            end

            ws.onclose do
                settings.sockets[board_id].delete(ws)
            end
        end
    end
    
    get '/board/:id' do
        board_id = params['id']
        board_that_we_found = Board.find_by(id: board_id)
        erb :single_board, :locals => { matching_board: board_that_we_found }
    end


end