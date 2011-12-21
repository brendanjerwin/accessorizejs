define ['src/accessorize.js'],  (accessorize) ->

  describe 'addAccessor Method', ->
    obj = null
    beforeEach =>

      class Obj
        protoProperty : ""

      obj= new Obj

      obj.simpleProperty = ""

      obj= accessorize obj

    it 'should have the addAccessor Method', =>
      (expect obj.addAccessor).to.be.a.function

    describe 'when called with a new accessor name', =>
      beforeEach =>
        obj.addAccessor 'newProperty'

      it 'should add the new accessor', =>
        (expect obj.newProperty).to.be.an.accessor

      it 'should add a new backing property to the source object', =>
        (expect obj.toJSON().hasOwnProperty('newProperty')).to.be.true

      describe 'adding property with initial value', =>
        beforeEach =>
          obj.addAccessor 'newArrayProperty', [1,2,3]

        it 'should create return the value', =>
          (expect obj.newArrayProperty()).to.eql([1,2,3])

        it 'should create an array accessor', =>
          (expect obj.newArrayProperty.concat).to.be.a.function

      describe 'overwrite protection', =>
        describe 'when the property is already on the wrapped object', =>
            it 'should throw', =>
              (expect => obj.addAccessor 'simpleProperty').to.throw accessorize.errors.PropertyAlreadyExistsError

        describe 'when the property is already somewhere on the prototype chain', =>
          it 'should throw', =>
            (expect => obj.addAccessor 'protoProperty').to.throw accessorize.errors.PropertyAlreadyExistsError
