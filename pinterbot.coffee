console.log 'Running pinterbot'

# You can spawn different bots with this thing
Pinterevilapi = require('./lib/pinterevilapi')
Account       = Pinterevilapi.Account

user1 = new Account('william.estoque@gmail.com', 'salarium17')
user1.login ->
  # Do something recursive
  user1.followUser "adrielfrederick"
