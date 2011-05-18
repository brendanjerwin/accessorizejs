define ['src/accessorize', 'spec/helpers/SpecHelper'], (accessorize) ->
  'use strict'

  obj = undefined
  ret_val = 'before value'

  describe 'wrapping an object having a null-valued property', ->

    beforeEach ->
      obj = accessorize
        nullProperty : null
        undefinedProperty : undefined

    it 'should create an accessor', ->
      expect(obj.nullProperty).toBeAFunction()
      expect(obj.undefinedProperty).toBeAFunction()

    describe 'the value returned by the accessor of the null property', ->

      beforeEach ->
        ret_val = obj.nullProperty()

      it 'should return null', ->
        expect(ret_val).toBeNull()

    describe 'the value returned by the accessor of the undefined property', ->
        beforeEach ->
          ret_val = obj.undefinedProperty()

        it 'should return undefined', ->
          expect(ret_val).toBeUndefined()
