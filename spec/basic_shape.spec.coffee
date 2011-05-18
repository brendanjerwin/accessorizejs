define ['src/accessorize.js', 'spec/helpers/SpecHelper'], (accessorize) ->
  describe 'basic shape of the api', ->

    it 'should exist', ->
      expect(accessorize).toBeDefined()

    it 'should be a function', ->
      expect(accessorize).toBeAFunction()
