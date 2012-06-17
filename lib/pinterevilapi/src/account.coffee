request = require('request')
jsdom   = require('jsdom')

LOGIN_PAGE_URL = 'https://pinterest.com/login/?next=%2Flogin%2F'

BOARD = {
  create: 'http://pinterest.com/board/create/'
  destroy: 'http://pinterest.com/westoque/zomg/settings/'
}

BOARD_CATEGORIES = [
  "architecture",
  "art",
  "cars_motorcycles",
  "design",
  "diy_crafts",
  "education",
  "film_music_books",
  "fitness",
  "food_drink",
  "gardening",
  "geek",
  "hair_beauty",
  "history",
  "holidays",
  "home",
  "humor",
  "kids",
  "mylife",
  "women_apparel",
  "men_apparel",
  "outdoors",
  "people",
  "pets",
  "photography",
  "prints_posters",
  "products",
  "science",
  "sports",
  "technology",
  "travel_places",
  "wedding_events",
  "other"
]

class Account
  # Account objects have their session in them so you can
  # keep making calls to Pinterest with a no limits API.
  #
  # email - The email
  # password - The password
  constructor: (@email, @password) ->
    @headers   = null
    @csrftoken = null

  # Logs you in into Pinterest, saves the headers
  login: (callback) ->
    self = this

    # Show the login page
    request.get LOGIN_PAGE_URL, (err, res) ->
      # set the CSRF token
      self.csrftoken = self._setCsrfToken(res.headers)

      options =
        url: LOGIN_PAGE_URL
        form:
          email: self.email
          password: self.password
          csrfmiddlewaretoken: self.csrftoken
        followAllRedirects: true

      # Login and save the headers and session for reuse :-)
      request.post options, (err, res) ->
        self.headers = res.headers
        callback()

  # Creates a board for the user
  #
  # name - the name of the board
  # category - the category of the board
  # collaborator - the collaborator
  createBoard: (name = 'Zomg', category = 'outdoors', collaborator = 'me') ->
    console.log 'Creating board\n' + name
    self = this

    # Fake the ajax request
    self.headers['x-csrftoken']      = @csrftoken
    self.headers['x-requested-with'] = 'XMLHttpRequest'

    options =
      url: BOARD.create
      headers: self.headers
      form:
        name: name
        category: category
        collaborator: collaborator

    request.post options, (err, res) ->
      console.log res.statusCode
      console.log res.body

  # Deletes a board from the user
  #
  # name - the name of the board to be deleted
  deleteBoard: (name) ->
    console.log 'Deleting board\n'
    self = this

    # Fake the ajax request
    self.headers['x-csrftoken']      = @csrftoken
    self.headers['x-requested-with'] = 'XMLHttpRequest'

    options =
      url: BOARD.destroy
      headers: self.headers

    request.del options, (err, res) ->
      console.log res.statusCode
      console.log res.body

  followUser: (name) ->
    self = this

    url  = 'http://pinterest.com/' + name + '/follow/'

    # Fake the ajax request
    self.headers['x-csrftoken']      = @csrftoken
    self.headers['x-requested-with'] = 'XMLHttpRequest'

    options =
      url: url
      headers: self.headers

    request.post options, (err, res) ->
      console.log 'Followed user ' + name + '\n'
      console.log res.body

  unfollowUser: (name) ->
    self = this

    url  = 'http://pinterest.com/' + name + '/follow/'

    # Fake the ajax request
    self.headers['x-csrftoken']      = @csrftoken
    self.headers['x-requested-with'] = 'XMLHttpRequest'

    options =
      url: url
      headers: self.headers
      form:
        unfollow: 1

    request.post options, (err, res) ->
      console.log 'Unfollowed user ' + name + '\n'
      console.log res.body

  navigate: (url, callback) ->
    self = this

    # Fake the ajax request
    self.headers['x-csrftoken']      = @csrftoken
    self.headers['x-requested-with'] = 'XMLHttpRequest'

    options =
      url: url
      headers: self.headers

    request.get options, (err, res) ->
      console.log "request done"
      jsdomHash = 
        html: res.body,
        scripts: ['http://code.jquery.com/jquery-1.5.min.js']

      jsdom.env jsdomHash, (err, window) ->
        $ = window.jQuery
        console.log "calling callback"
        callback(err, window, $)


  _setCsrfToken: (headers) ->
    cookies = headers['set-cookie'][0].split(';')
    cookie  = (item for item in cookies when item.match(/csrf/))[0]
    cookie.match(/csrftoken=(.*)/)[1]


module.exports = Account
