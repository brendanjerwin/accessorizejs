define ['src/accessorize.js'], (accessorize) ->
  describe "Array Accessors", ->
    obj = undefined
    the_array = [1,2,3]

    describe "Simple Getter", ->
      beforeEach ->
        obj = accessorize.wrap
          arrayProperty : the_array

      it 'should return the array', ->
        expect(obj.arrayProperty()).toBe(the_array)
