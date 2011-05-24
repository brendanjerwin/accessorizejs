define ['src/accessorize.js'], (accessorize) ->
  describe "Array Accessors", ->
    obj = undefined
    the_array = [1,2,3]

    describe "Simple Setter", ->
      beforeEach ->
        obj = accessorize
          arrayProperty : []

      it 'should allow the value to be set', ->
        expect(->obj.arrayProperty(the_array)).not.toThrow()

      describe 'setting a value', ->
        callbacks =
          subscriber : ->

        subscriber = undefined

        beforeEach ->
          subscriber = spyOn(callbacks, 'subscriber')
          obj.arrayProperty.subscribe callbacks.subscriber
          obj.arrayProperty(the_array)

        it 'should set the underlying value', ->
          expect(obj.toJSON().arrayProperty).toBe(the_array)

        it 'should trigger a change event', ->
          expect(subscriber).toHaveBeenCalled()
