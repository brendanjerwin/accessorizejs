vows = require 'vows'
assert = require 'assert'

accessorize = require '../../lib/accessorize.js'

vows.describe('subscription mixin')
  .addBatch
    'when called' :
      topic : ->
        target = {}
        trigger = accessorize.mixin_change_notification target

        return {
          target : target
          trigger : trigger
        }

      'it should return a trigger function' : (topic) ->
        assert.isFunction topic.trigger

      'it should provide a subscribe method' : (topic) ->
        assert.isFunction topic.target.subscribe

.export(module)

