define ['src/accessorize.js'], (accessorize) ->
  "use strict"
  wrap_it = (source) ->
      wrapped : accessorize source
      source : source

  topic = {}

  describe 'wrap function', ->
    describe 'when called', ->
      beforeEach ->
        topic = wrap_it {}

      it 'should return an object', ->
        expect(topic.wrapped).toBeAnObject()

      it 'should set the prototype of the returned object to the target', ->
        expect(topic.wrapped.toJSON()).toEqual(topic.source)

      describe 'with a single property on the source', ->
        beforeEach ->
          topic = wrap_it
            single_property : 'foo'

        it 'should make an accessor function for the property', ->
          expect(topic.wrapped.single_property).toBeAFunction()

        it 'should hide the original property with the accessor function', ->
          expect(topic.source.single_property).not.toEqual(topic.wrapped.single_property)

        describe 'accessor function', ->
          it 'should return the value', ->
            expect(topic.wrapped.single_property()).toEqual(topic.source.single_property)

      describe 'setting the property via the accessor', ->
        beforeEach ->
          topic = wrap_it
            a_property : 'bar'

          topic.wrapped.a_property('baz')

        it 'should cause the accessor to return the new value', ->
          expect(topic.wrapped.a_property()).toEqual 'baz'

        it 'should cause the underlying property to change', ->
          expect(topic.source.a_property).toEqual 'baz'

      describe 'setting the property on the underlying source object', ->
        beforeEach ->
          topic= wrap_it
            another_property : 'nothing'

          topic.source.another_property = 'hello'

        it 'should cause the underlying property to change', ->
          expect(topic.source.another_property).toEqual 'hello'

        it 'should cause the accessor to return the new value', ->
          expect(topic.wrapped.another_property()).toEqual 'hello'

