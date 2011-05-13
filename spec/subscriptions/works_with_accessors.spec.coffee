define ['src/accessorize.js'], (accessorize) ->
  describe 'subscription to accessor changes', ->
    obj = undefined

    callbacks =
      subscriber : ->

    subscriber = undefined

    beforeEach ->
      obj =
        property_one : "foo"

      obj = accessorize.wrap obj

      subscriber = spyOn(callbacks, 'subscriber')

      obj.property_one.subscribe callbacks.subscriber

    it 'should mix in the subscription stuff on the accessor', ->
      expect(obj.property_one.subscribe).toBeAFunction()

    describe 'when a value is set', ->
      beforeEach ->
        obj.property_one("new value")

      it 'should call the subscriber with the new value and accessor', ->
        expect(subscriber).toHaveBeenCalledWith('new value', obj.property_one)

    describe 'when the value is getted', ->
      beforeEach ->
        foo = obj.property_one()

      it 'should not call the subscriber', ->
        expect(subscriber).not.toHaveBeenCalled()
