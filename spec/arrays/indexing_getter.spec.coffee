define ['src/accessorize.js'], (accessorize) ->
  describe "Array Accessors", ->
    obj = undefined
    the_array = ["hello","world","I'm","here"]
    ret_val = undefined

    describe "Indexing Getter", ->
      beforeEach ->
        obj = accessorize.wrap
          arrayProperty : the_array

      describe 'passing a number into the accessor', ->
        beforeEach ->
          ret_val = obj.arrayProperty(1)

        it 'should not modify the array', ->
          expect(obj.prototype.arrayProperty[1]).toEqual("world")

        it 'should return the value from the requested index', ->
          expect(ret_val).toEqual("world")
