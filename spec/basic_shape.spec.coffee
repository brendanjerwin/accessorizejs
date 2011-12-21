define ['src/accessorize.js'], (accessorize) ->
  describe 'basic shape of the api', ->
    it 'should exist', ->
      expect(accessorize).to.exist

    it 'should be a function', ->
      expect(accessorize).to.have.typeof 'function'
