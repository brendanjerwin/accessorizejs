vows = require 'vows'
assert = require 'assert'
wrap_it = require('./helper.js').wrap_it

vows.describe('wrap function')
  .addBatch
    'when called' :
      topic : -> wrap_it {}

      'it should return an object' : (topic) -> assert.isObject topic.wrapped

      'it should set the prototype of the returned object to the target' : (topic) ->
        assert.strictEqual topic.wrapped.prototype, topic.source

    'with a single property on the source' :
      topic : -> wrap_it
        single_property : 'foo'

      'it should make an accessor function for the property' : (topic) ->
        assert.isFunction topic.wrapped.single_property

      'it should hide the original property with the accessor function' : (topic) ->
        assert.notEqual topic.source.single_property, topic.wrapped.single_property

      'the accessor function should return the value' : (topic) ->
        assert.equal topic.wrapped.single_property(), topic.source.single_property

    'setting the property via the accessor' :
      topic : ->
        result = wrap_it
          a_property : 'bar'

        result.wrapped.a_property('baz')
        return result

      'should cause the accessor to return the new value' : (topic) ->
        assert.equal 'baz', topic.wrapped.a_property()

      'should cause the underlying property to change' : (topic) ->
        assert.equal 'baz', topic.source.a_property

    'setting the property on the underlying source object' :
      topic : ->
        result = wrap_it
          another_property : 'nothing'

        result.source.another_property = 'hello'
        return result

      'should cause the underlying property to change' : (topic) ->
        assert.equal 'hello', topic.source.another_property

      'should cause the accessor to return the new value' : (topic) ->
        assert.equal 'hello', topic.wrapped.another_property()

.export(module)

