define ['src/accessorize'], (accessorize) ->


  describe 'toJSON method', ->
    obj = null

    beforeEach ->
      obj = accessorize
        simpleProperty : ''
        arrayProperty : ['one', '']
        objectProperty :
          simpleProperty : ''

      obj.simpleProperty "string value"
      obj.objectProperty().simpleProperty "another value"
      obj.arrayProperty(1, "two")

    it 'should have a toJSON method on the wrapped object', ->
      expect(obj.toJSON).toBeAFunction()

    it 'should have a toJSON method on the accessors', ->
      expect(obj.simpleProperty.toJSON).toBeAFunction()
      expect(obj.arrayProperty.toJSON).toBeAFunction()

    describe 'object level method', ->
      ret_val = null

      beforeEach ->
        ret_val = JSON.stringify obj

      it 'should return valid JSON', ->
        expect(-> JSON.parse(ret_val)).not.toThrow()

      it 'should return the serialized object', ->
        console.log ret_val
        console.log JSON.parse(ret_val)
        expect(ret_val).toBe('{"simpleProperty":"string value","arrayProperty":["one","two"],"objectProperty":{"simpleProperty":"another value"}}')

    describe 'accessor level method', ->
      ret_val = null

      beforeEach ->
        ret_val = JSON.stringify obj.simpleProperty

      it 'should return the serialized version of the backing property', ->
        expect(ret_val).toBe '"string value"'
