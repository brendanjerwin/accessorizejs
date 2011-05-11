describe "Array Accessors", ->
  obj = undefined

  describe "Indexing Setter", ->
    beforeEach ->
      obj = accessorize.wrap
        arrayProperty : ["hello", "planet"]

    it 'should allow the value to be set at an index', ->
      expect(->obj.arrayProperty(1, "world")).not.toThrow()

    describe 'setting a value at an index', ->
      callbacks =
        subscriber : ->

      subscriber = undefined

      beforeEach ->
        subscriber = spyOn(callbacks, 'subscriber')
        obj.arrayProperty.subscribe callbacks.subscriber
        obj.arrayProperty(1, "world")

      it 'should set the underlying value at the index location', ->
        expect(obj.prototype.arrayProperty[1]).toEqual("world")

      it 'should trigger a change event', ->
        expect(subscriber).toHaveBeenCalled()
