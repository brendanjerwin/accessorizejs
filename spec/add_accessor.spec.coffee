define ['src/accessorize', 'spec/helpers/SpecHelper'],  (accessorize) ->

  describe 'addAccessor Method', ->

    beforeEach ->
      @obj = accessorize
        simpleProperty : ''

    it 'should have the addAccessor Method', ->
      (expect @obj.addAccessor).toBeAFunction()

    describe 'when called with a new accessor name', ->
      beforeEach ->
        @obj.addAccessor 'newProperty'

      it 'should add the new accessor', ->
        (expect @obj.newProperty).toBeAnAccessor()


