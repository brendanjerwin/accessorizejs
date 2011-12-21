define ['src/accessorize.js'], (accessorize) ->
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
        expect(topic.wrapped.simple_property).to.be.a.function

      it 'should not touch the method', ->
        expect(topic.source.hasOwnProperty 'a_method').to.be.true
        expect(topic.wrapped.hasOwnProperty 'a_method').to.be.false

      it 'should make an accessor for the object property', ->
        expect(topic.wrapped.an_object_property).to.be.a.function
        expect(topic.wrapped.an_object_property()).to.be.an.object
        expect(topic.wrapped.an_object_property()).to.eql(topic.source.an_object_property)


  describe 'sub object wrapping', ->
    describe 'when called with a source having an object property', ->
      topic = test_fodder().wrapped.an_object_property()

      it 'should create an accessor for the simple property', ->
        expect(topic.sub_simple_property).to.be.a.function

      it 'should create an accessor that is not on the prototype', ->
        expect(topic.sub_simple_property).not.toEqual(topic.toJSON().sub_simple_property)
