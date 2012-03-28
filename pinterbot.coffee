request = require('request')
jsdom   = require('jsdom')

class Account
  constructor: (email, password) ->
    @email    = email
    @password = password
