(function() {

  var request = require('request');
  var jsdom   = require('jsdom');

  // Categories for Board
  var CATEGORY = [
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
  ];

  function Pinterest(username, password) {
    this.email    = username;
    this.password = password;

    if (!this.login()) {
      throw new Error('Login you mofo!');
    }
  }

  Pinterest.prototype = {
    login: function() {
      var self = this;

      request.get('https://pinterest.com/login/?next=%2Flogin%2F', function(err, res) {
        var options = {
          followAllRedirects: true,
          url: 'https://pinterest.com/login/?next=%2Flogin%2F',
          form: {
            email:    self.email,
            password: self.password,
            csrfmiddlewaretoken: self._getCsrfToken(res.headers)
          }
        };

        request.post(options, function(err, res) {
          console.log(res.body);
        });
      });

      return 1;
    },

    _getCsrfToken: function(headers) {
      var cookie, cookies = headers['set-cookie'][0].split(';')
      for (var c in cookies) {
        if (cookies[c].match(/csrf/)) {
          cookie = cookies[c].match(/csrftoken=(.*)/)[1];
        }
      }
      return cookie;
    }
  };

  console.log('Running Pinterbot!');

  // This is in cleartext right now
  // Just for testing.. DONT COMMIT ANYTHING BEYOND THIS POINT
  account = new Pinterest('william.estoque@gmail.com', 'YOUR_PASSWORD_HERE');

})();
