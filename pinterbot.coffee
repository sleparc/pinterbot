request = require('request')
jsdom   = require('jsdom')

LOGIN_PAGE_URL = 'http://pinterest.com/login'

class Account
  constructor: (@email, @password) ->

  login: ->
    self = this

    request.get LOGIN_PAGE_URL, (err, res) ->
      options =
        url: 'http://pinterest.com/login'
        qs: {next: '/login/'}
        headers:
          "referer":    "http://pinterest.com/login/?next=%2F"
          "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120319 Firefox/13.0a2"
          "host":       "pinterest.com"
          "origin":       "https://pinterest.com"
          "accept":       "text/plain"
          "Accept":"*/*"
          "Accept-Charset":"ISO-8859-1,utf-8;q=0.7,*;q=0.3"
          "Accept-Encoding":"gzip,deflate,sdch"
          "Accept-Language":"en-US,en;q=0.8"
        form:
          email:    self.email
          password: self.password
          csrfmiddlewaretoken: 'oaeu'
          next: "/login/"

      request.post options, (one, two) ->
        console.log two.statusCode

        #request.get 'https://pinterest.com', (err, res) ->
          #console.log res.body


  # Internal: Gets the CSRF Token
  _getCsrfToken: (headers) ->
    cookies = headers['set-cookie'][0].split(';')
    cookie  = (item for item in cookies when item.match(/csrf/))[0]
    cookie.match(/csrftoken=(.*)/)[1]

console.log 'Running pinterbot'
account = new Account "william.estoque@gmail.com", "oea"
account.login()
