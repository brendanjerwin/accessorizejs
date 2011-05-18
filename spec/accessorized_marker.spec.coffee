define ['src/accessorize'], (accessorize) ->

  describe 'accessorized marker (.isAccessorized)', ->

    obj = undefined

    beforeEach ->
      obj = accessorize
        simpleProperty : 'hello'
        arrayProperty : ['hello', 'world']

    describe 'identifying accessorized objects', ->

      it 'should identify a wrapped object', ->
        answer = accessorize.isAccessorized(obj)
        expect(answer).toBeTruthy()
        expect(answer.kind).toBe('object')

      it 'should identify an accessor', ->
        answer = accessorize.isAccessorized(obj.simpleProperty)
        expect(answer).toBeTruthy()
        expect(answer.kind).toBe('accessor')

      it 'should identify an array accessor', ->
        answer = accessorize.isAccessorized(obj.arrayProperty)
        expect(answer).toBeTruthy()
        expect(answer.kind).toBe('accessor')

      it 'should not identify an unwrapped object', ->
        expect(accessorize.isAccessorized(obj.prototype)).toBeFalsy()

      it 'should not identify a non-accessor function', ->
        expect(accessorize.isAccessorized(->)).toBeFalsy()

      it 'should not identify a null', ->
        expect(accessorize.isAccessorized(null)).toBeFalsy()

      it 'should not identify an undefined', ->
        expect(accessorize.isAccessorized(undefined)).toBeFalsy()

