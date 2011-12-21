define ['src/accessorize.js', 'underscore'], (accessorize, _) ->
  'use strict'

  obj = undefined

  describe 'underscore integration', ->
    beforeEach ->
      obj = accessorize
        singleProperty : "hello"
        arrayProperty : [ "hello", "world" ]

    it 'should allow the simple accessor to be called with underscore', ->
      expect(-> obj.singleProperty(_)).not.to.throw()

    it 'should allow the array accessor to be called with underscore', ->
      expect(-> obj.arrayProperty(_)).not.to.throw()

    it 'should allow the indexing array accessor to be called with underscore', ->
      expect(-> obj.arrayProperty(1,_)).not.to.throw()

    describe "return value", ->
      ret_val = undefined

      it_should_wrap = ->
        it 'should return an _ wrapped object', ->
          expect(ret_val._wrapped).to.exist

      describe "simple accessor", ->
        beforeEach ->
          ret_val = obj.singleProperty(_)

        it_should_wrap()

      describe 'simple array accessor', ->
        beforeEach ->
          ret_val = obj.arrayProperty(_)

        it_should_wrap()

      describe 'indexing array accessor', ->
        beforeEach ->
          ret_val = obj.arrayProperty(0,_)

        it_should_wrap()
