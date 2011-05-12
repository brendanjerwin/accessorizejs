describe "Array Accessors", ->
  obj = undefined
  the_array = undefined
  callbacks =
    subscriber : ->

  subscriber = undefined
  ret_val = undefined

  it_should_call = ->
    it 'should call the subscriber', ->
      expect(subscriber).toHaveBeenCalled()


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

        it_should_call()

        it 'should return the right value', ->
          expect(ret_val).toEqual("here")

        it 'should shorten the array', ->
          expect(the_array.length).toBe(3)


      describe "push", ->
        beforeEach ->
          ret_val = obj.arrayProperty.push("new")

        it_should_call()

        it 'should return the right value', ->
          expect(ret_val).toEqual(5)

        it 'should lengthen the array', ->
          expect(the_array.length).toBe(5)

      describe "reverse", ->
        beforeEach ->
          ret_val = obj.arrayProperty.reverse()

        it_should_call()

        it 'should reverse the array', ->
          expect(the_array[0]).toBe("here")
          expect(the_array[3]).toBe("hello")

      describe "shift", ->
        beforeEach ->
          ret_val = obj.arrayProperty.shift()

        it_should_call()

        it 'should return the right value', ->
          expect(ret_val).toBe("hello")

        it 'should shorten the array', ->
          expect(the_array.length).toBe(3)

      describe "sort", ->
        beforeEach ->
          ret_val = obj.arrayProperty.sort()

        it_should_call

        it 'should sort the array', ->
          expect(the_array[0]).toEqual("I'm")
          expect(the_array[3]).toEqual("world")

      # describe "splice", ->


