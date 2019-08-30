require_relative "../lib/task.rb"
require_relative "../lib/board.rb"
require_relative "../lib/user.rb"

board = Board.create(title: 'Shopping Cart Sprint')

joe = User.create(name: 'Joe')
nikolett = User.create(name: 'Nikolett')


taska = Task.create(title: 'get a coffee', status: 'done', text: 'Nikolett went to get a coffee from her friend and retrieved a coffee beverage which tastes lovely 5/5', board_id: board.id, user_id: joe.id)
taskb = Task.create(title: 'go get a plane', status: 'to do', text: 'myself am going to airport', board_id: board.id, user_id: nikolett.id)

