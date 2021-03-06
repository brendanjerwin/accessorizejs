define ['src/accessorize.js'], (accessorize) ->
  describe "Array Accessors", ->
    obj = undefined
    the_array = ["hello","world","I'm","here"]
    ret_val = undefined

    describe "Indexing Getter", ->
      beforeEach ->
        obj = accessorize
          arrayProperty : the_array

      describe 'passing a number into the accessor', ->
        beforeEach ->
          ret_val = obj.arrayProperty(1)

        it 'should not modify the array', ->
          expect(obj.toJSON().arrayProperty[1]).to.eql("world")

        it 'should return the value from the requested index', ->
          expect(ret_val).to.eql("world")
