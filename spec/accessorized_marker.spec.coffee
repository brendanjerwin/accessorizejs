define ['src/accessorize.js'], (accessorize) ->

  describe 'accessorized marker (.isAccessorized)', ->

    obj = undefined

    beforeEach ->
      obj = accessorize
        simpleProperty : 'hello'
        arrayProperty : ['hello', 'world']

    describe 'identifying accessorized objects', ->

      it 'should identify a wrapped object', ->
        answer = accessorize.isAccessorized(obj)
        expect(!!answer).to.be.true
        expect(answer.kind).to.equal('object')

      it 'should identify an accessor', ->
        answer = accessorize.isAccessorized(obj.simpleProperty)
        expect(!!answer).to.be.true
        expect(answer.kind).to.equal('accessor')

      it 'should identify an array accessor', ->
        answer = accessorize.isAccessorized(obj.arrayProperty)
        expect(!!answer).to.be.true
        expect(answer.kind).to.equal('accessor')

      it 'should not identify an unwrapped object', ->
        expect(accessorize.isAccessorized(obj.prototype)).to.be.false

      it 'should not identify a non-accessor function', ->
        expect(accessorize.isAccessorized(->)).to.be.false

      it 'should not identify a null', ->
        expect(accessorize.isAccessorized(null)).to.be.false

      it 'should not identify an undefined', ->
        expect(accessorize.isAccessorized(undefined)).to.be.false

