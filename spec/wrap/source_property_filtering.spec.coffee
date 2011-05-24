define ['src/accessorize', 'spec/helpers/SpecHelper'], (accessorize) ->
  'use strict'

  wrap_it = (source) ->
      wrapped : accessorize source
      source : source

  test_fodder = ->
    wrap_it
      simple_property : 'simple'
      a_method : ->
        "return value"
      an_object_property :
        sub_simple_property : 'also simple'
        sub_method : ->
          "another return value"


  describe 'wrap function', ->
    describe 'when called with a source having more than just simple properties', ->
      topic = test_fodder()

      it 'should make an accessor for the simple property', ->
        expect(topic.wrapped.simple_property).toBeAFunction()

      it 'should not touch the method', ->
        expect(topic.source.hasOwnProperty 'a_method').toBeTruthy()
        expect(topic.wrapped.hasOwnProperty 'a_method').toBeFalsy()

      it 'should make an accessor for the object property', ->
        expect(topic.wrapped.an_object_property).toBeAFunction()
        expect(topic.wrapped.an_object_property()).toBeAnObject()
        expect(topic.wrapped.an_object_property()).toEqual(topic.source.an_object_property)


  describe 'sub object wrapping', ->
    describe 'when called with a source having an object property', ->
      topic = test_fodder().wrapped.an_object_property()

      it 'should create an accessor for the simple property', ->
        expect(topic.sub_simple_property).toBeAFunction()

      it 'should create an accessor that is not on the prototype', ->
        expect(topic.sub_simple_property).not.toEqual(topic.toJSON().sub_simple_property)
