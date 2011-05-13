define ['src/accessorize.js'], (accessorize) ->
  describe 'basic shape of the api', ->

    it 'should exist', ->
      expect(accessorize).toBeDefined()

    it 'should have a wrap function', ->
      expect(accessorize.wrap).toBeAFunction()
