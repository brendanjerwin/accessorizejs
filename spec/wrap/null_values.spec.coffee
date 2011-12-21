define ['src/accessorize.js'], (accessorize) ->
  'use strict'

  describe 'wrap function', ->
    obj = undefined
    ret_val = 'before value'

    describe 'wrapping an object having a null-valued property', ->

      beforeEach ->
        obj = accessorize
          nullProperty : null
          undefinedProperty : undefined

      it 'should create an accessor', ->
        expect(obj.nullProperty).to.be.a.function
        expect(obj.undefinedProperty).to.be.a.function

      describe 'the value returned by the accessor of the null property', ->

        beforeEach ->
          ret_val = obj.nullProperty()

        it 'should return null', ->
          expect(ret_val).to.be.null

      describe 'the value returned by the accessor of the undefined property', ->
          beforeEach ->
            ret_val = obj.undefinedProperty()

          it 'should return undefined', ->
            expect(ret_val).not.to.exist
