define ['src/accessorize.js'], (accessorize) ->

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
      expect(obj.toJSON).to.be.a.function

    it 'should have a toJSON method on the accessors', ->
      expect(obj.simpleProperty.toJSON).to.be.a.function
      expect(obj.arrayProperty.toJSON).to.be.a.function

    describe 'object level method', ->
      ret_val = null

      beforeEach ->
        ret_val = JSON.stringify obj

      it 'should return valid JSON', ->
        expect(-> JSON.parse(ret_val)).not.to.throw

      it 'should return the serialized object', ->
        expect(ret_val).to.eql('{"simpleProperty":"string value","arrayProperty":["one","two"],"objectProperty":{"simpleProperty":"another value"}}')

    describe 'accessor level method', ->
      ret_val = null

      beforeEach ->
        #NOTE: Some browsers refuse to serialize an accessor even though it has a toJSON method. This is because, generally, a function is not a valid thing to serialize
        #current browsers will call the toJSON if it exists, and ignore the function otherwise.
        ret_val = obj.simpleProperty.toJSON()

      it 'should return the value of the backing property', ->
        expect(ret_val).to.eql "string value"

    describe 'interactions with addAccessor', ->
      beforeEach ->
        obj.addAccessor 'added', "added"

      it 'should include added properties in the JSON output', ->
        (expect JSON.stringify obj).to.include 'added'
