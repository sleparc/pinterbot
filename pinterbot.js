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
    this.username = username;
    this.password = password;

    if (!this.login()) {
      throw new Error('Login you mofo!');
    }
  }

  Pinterest.prototype = {
    login: function() {
      request.get('http://pinterest.com/login/?next=%2Flogin%2F', function(err, res) {
        console.log(res.body);
      });

      //var options = {
        //url: 'http://pinterest.com/login/?next=%2Flogin%2F',
        //json: {
          //login:    this.email,
          //password: this.password
        //}
      //};

      //request.post(options, function(err, res) {
        //console.log(res.headers);
        //console.log(res.body);
      //});

      return 1;
    },

    createBoard: function() {
      return 'http://pinterest.com/board/create';
    }
  };

  console.log('Running Pinterbot!');

  account = new Pinterest('westoque', 'password');

})();
