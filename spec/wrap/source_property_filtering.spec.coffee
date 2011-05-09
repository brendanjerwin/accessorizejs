vows = require 'vows'
assert = require 'assert'
wrap_it = require('./helper.js').wrap_it

test_fodder = ->
  wrap_it
    simple_property : 'simple'
    a_method : ->
      "return value"
    an_object_property :
      sub_simple_property : 'also simple'
      sub_method : ->
        "another return value"


vows.describe('wrap function')
  .addBatch
    'when called with a source having more than just simple properties' :
      topic : test_fodder()

      'it should make an accessor for the simple property' : (topic) ->
        assert.isFunction topic.wrapped.simple_property

      'it should not touch the method' : (topic) ->
        assert.isTrue topic.source.hasOwnProperty 'a_method'
        assert.isFalse topic.wrapped.hasOwnProperty 'a_method'

      'it should make an accessor for the object property' : (topic) ->
        assert.isFunction topic.wrapped.an_object_property
        assert.isObject topic.wrapped.an_object_property()
        assert.equal topic.wrapped.an_object_property(), topic.source.an_object_property


.export module

vows.describe('sub object wrapping')
  .addBatch
    'when called with a source having an object property' :
      topic : test_fodder().wrapped.an_object_property()

      'it should create an accessor for the simple property' : (topic) ->
        assert.isFunction topic.sub_simple_property

      'it should create an accessor that is not on the prototype' : (topic) ->
        assert.notEqual topic.sub_simple_property topic.prototype.sub_simple_property

.export module
