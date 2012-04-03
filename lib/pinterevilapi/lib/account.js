var Account, LOGIN_PAGE_URL, jsdom, request;

request = require('request');

jsdom = require('jsdom');

LOGIN_PAGE_URL = 'https://pinterest.com/login/?next=%2Flogin%2F';

Account = (function() {

  function Account(email, password) {
    this.email = email;
    this.password = password;
    this.headers = null;
  }

  Account.prototype.login = function() {
    var self;
    self = this;
    return request.get(LOGIN_PAGE_URL, function(err, res) {
      var options;
      options = {
        followAllRedirects: true,
        url: LOGIN_PAGE_URL,
        form: {
          email: self.email,
          password: self.password,
          csrfmiddlewaretoken: self._getCsrfToken(res.headers)
        }
      };
      return request.post(options, function(err, res) {
        return self.headers = res.headers;
      });
    });
  };

  Account.prototype._getCsrfToken = function(headers) {
    var cookie, cookies, item;
    cookies = headers['set-cookie'][0].split(';');
    cookie = ((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = cookies.length; _i < _len; _i++) {
        item = cookies[_i];
        if (item.match(/csrf/)) _results.push(item);
      }
      return _results;
    })())[0];
    return cookie.match(/csrftoken=(.*)/)[1];
  };

  return Account;

})();

module.exports = Account;
