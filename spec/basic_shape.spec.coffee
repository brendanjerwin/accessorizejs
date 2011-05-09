vows = require 'vows'
assert = require 'assert'

vows.describe('basic shape of the api')
  .addBatch
    'when loaded' :
      topic : -> return require('../lib/accessorize.js')

      'it should exist' : (tbn) -> assert.isObject tbn

      'it should have a wrap function' : (tbn) -> assert.isFunction tbn.wrap

      'it should not attach the global object (we are in node)' : -> assert.isUndefined global.TBN
.export(module)
