define ['src/accessorize', 'spec/helpers/SpecHelper'],  (accessorize) ->

  describe 'addAccessor Method', ->

    beforeEach ->

      class Obj
        protoProperty : ""

      @obj = new Obj

      @obj.simpleProperty = ""

      @obj = accessorize @obj

    it 'should have the addAccessor Method', ->
      (expect @obj.addAccessor).toBeAFunction()

    describe 'when called with a new accessor name', ->
      beforeEach ->
        @obj.addAccessor 'newProperty'

      it 'should add the new accessor', ->
        (expect @obj.newProperty).toBeAnAccessor()

      it 'should add a new backing property to the source object', ->
        (expect @obj.toJSON().hasOwnProperty('newProperty')).toBeTruthy()

      describe 'adding property with initial value', ->
        beforeEach ->
          @obj.addAccessor 'newArrayProperty', [1,2,3]

        it 'should create return the value', ->
          (expect @obj.newArrayProperty()).toEqual([1,2,3])

        it 'should create an array accessor', ->
          (expect @obj.newArrayProperty.concat).toBeAFunction()

      describe 'overwrite protection', ->
        describe 'when the property is already on the wrapped object', ->
            it 'should throw', ->
              (expect => @obj.addAccessor 'simpleProperty').toThrow(new accessorize.errors.PropertyAlreadyExistsError 'simpleProperty')

        describe 'when the property is already somewhere on the prototype chain', ->
          it 'should throw', ->
            (expect => @obj.addAccessor 'protoProperty').toThrow(new accessorize.errors.PropertyAlreadyExistsError 'protoProperty')
