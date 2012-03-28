describe 'Pinterbot', ->
  account = null

  beforeEach ->
    account = new Account('test@pinterest.com', 'pass')

  describe '_getCsrfToken', ->
    it 'returns the csrf token', ->
      expect(account._getCsrfToken()).toEqual('752fa4947992')

