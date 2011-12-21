define ['src/accessorize.js', 'sinon'], (accessorize, sinon) ->
  describe "Array Accessors", ->
    obj = undefined

    describe "Indexing Setter", ->
      beforeEach ->
        obj = accessorize
          arrayProperty : ["hello", "planet"]

      it 'should allow the value to be set at an index', ->
        expect(->obj.arrayProperty(1, "world")).not.to.throw()

      describe 'setting a value at an index', ->
        subscriber = undefined

        beforeEach ->
          subscriber = sinon.spy(->)
          obj.arrayProperty.subscribe subscriber
          obj.arrayProperty(1, "world")

        it 'should set the underlying value at the index location', ->
          expect(obj.toJSON().arrayProperty[1]).to.eql("world")

        it 'should trigger a change event', ->
          expect(subscriber.called).to.be.true
