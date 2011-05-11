describe "Array Accessors", ->
  obj = undefined
  the_array = undefined
  callbacks =
    subscriber : ->

  subscriber = undefined
  ret_val = undefined

  describe "Promoted Methods", ->
    beforeEach ->
      the_array = ["hello","world","I'm","here"]

      obj = accessorize.wrap
        arrayProperty : the_array

      subscriber = spyOn(callbacks, 'subscriber')
      obj.arrayProperty.subscribe(callbacks.subscriber)

    it 'should promote the methods from the array', ->
      expect_promoted = (method) ->
        console.log method
        expect(obj.arrayProperty[method]).toBeAFunction('called ' + method)

      expect_promoted method for method in ['pop','push','reverse','shift','sort','splice','unshift'].concat(['concat', 'join', 'slice', 'indexOf', 'lastIndexOf'])

    describe "change causing methods", ->
      describe "pop", ->
        beforeEach ->
          ret_val = obj.arrayProperty.pop()

        it 'should return the right value', ->
          expect(ret_val).toEqual("here")

        it 'should shorten the array', ->
          expect(the_array.length).toBe(3)

        it 'should call the subscriber', ->
          expect(subscriber).toHaveBeenCalled()
