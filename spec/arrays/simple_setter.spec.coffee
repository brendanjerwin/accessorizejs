define ['src/accessorize.js', 'sinon'], (accessorize, sinon) ->
  describe "Array Accessors", ->
    obj = undefined
    the_array = [1,2,3]

    describe "Simple Setter", ->
      beforeEach ->
        obj = accessorize
          arrayProperty : []

      it 'should allow the value to be set', ->
        expect(->obj.arrayProperty(the_array)).not.to.throw()

      describe 'setting a value', ->
        callbacks = undefined
        subscriber = undefined

        beforeEach ->
          callbacks =
            subscriber : ->

          subscriber = sinon.spy(callbacks, 'subscriber')
          obj.arrayProperty.subscribe callbacks.subscriber
          obj.arrayProperty(the_array)

        it 'should set the underlying value', ->
          expect(obj.toJSON().arrayProperty).to.eql(the_array)

        it 'should trigger a change event', ->
          expect subscriber.called
