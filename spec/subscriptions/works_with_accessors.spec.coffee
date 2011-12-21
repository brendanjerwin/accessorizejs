define ['src/accessorize.js', 'sinon'], (accessorize, sinon) ->
  describe 'subscription to accessor changes', ->
    obj = undefined
    callbacks = undefined
    subscriber = undefined

    beforeEach ->
      obj =
        property_one : "foo"

      obj = accessorize obj
      callbacks =
        subscriber : ->
      subscriber = sinon.spy(callbacks, 'subscriber')

      obj.property_one.subscribe callbacks.subscriber

    it 'should mix in the subscription stuff on the accessor', ->
      expect(obj.property_one.subscribe).to.be.a.function

    it 'should invoke the subscription when it is added', ->
      expect subscriber.called

    describe 'when a value is set', ->
      beforeEach ->
        obj.property_one("new value")

      it 'should call the subscriber with the new value and accessor', ->
        expect(subscriber.calledWith 'new value', obj.property_one)

    describe 'when the value is getted', ->
      beforeEach ->
        foo = obj.property_one()

      it 'should not call the subscriber', ->
        expect(subscriber.callCount).to.eql 1
