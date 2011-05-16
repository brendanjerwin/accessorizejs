define ['src/accessorize', 'spec/helpers/SpecHelper'], (accessorize) ->
  'use strict'

  obj = undefined

  describe 'wrapping an object having a null-valued property', ->

    beforeEach ->
      obj = accessorize.wrap
        nullProperty : null

    it 'should create an accessor', ->
      expect(obj.nullProperty).toBeAFunction()

    describe 'the value returned by the accessor', ->
      ret_val = 'before value'

      beforeEach ->
        ret_val = obj.nullProperty()

      it 'should return null', ->
        expect(ret_val).toBeNull()
