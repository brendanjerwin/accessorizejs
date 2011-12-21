define ['src/accessorize.js', 'sinon'], (accessorize, sinon) ->
  describe "Array Accessors", ->
    obj = undefined
    the_array = undefined
    callbacks = undefined
    subscriber = undefined
    ret_val = undefined

    it_should_call = ->
      it 'should call the subscriber', ->
        expect(subscriber.called).to.be.true


    describe "Promoted Methods", ->
      beforeEach ->
        the_array = ["hello","world","I'm","here"]

        obj = accessorize
          arrayProperty : the_array

        callbacks =
          subscriber : ->
        subscriber = sinon.spy(callbacks, 'subscriber')
        obj.arrayProperty.subscribe(callbacks.subscriber)

      expect_promoted = (method) ->
          expect(obj.arrayProperty[method]).to.be.a.function

      it 'should promote the methods from the array', ->
        expect_promoted method for method in ['pop','push','reverse','shift','sort','splice','unshift'].concat(['concat', 'join', 'slice'])

      if Array.prototype.indexOf?
        it 'should promote the ES5 methods from the array too (indexOf)', ->
          expect_promoted 'indexOf'

      if Array.prototype.lastIndexOf?
        it 'should promote the ES5 methods from the array too (lastIndexOf)', ->
          expect_promoted 'lastIndexOf'

      describe "change causing methods", ->
        describe "pop", ->
          beforeEach ->
            ret_val = obj.arrayProperty.pop()

          it_should_call()

          it 'should return the right value', ->
            expect(ret_val).to.eql "here"

          it 'should shorten the array', ->
            expect(the_array.length).to.eql 3


        describe "push", ->
          beforeEach ->
            ret_val = obj.arrayProperty.push("new")

          it_should_call()

          it 'should return the right value', ->
            expect(ret_val).to.eql(5)

          it 'should lengthen the array', ->
            expect(the_array.length).to.eql(5)

        describe "reverse", ->
          beforeEach ->
            ret_val = obj.arrayProperty.reverse()

          it_should_call()

          it 'should reverse the array', ->
            expect(the_array[0]).to.eql("here")
            expect(the_array[3]).to.eql("hello")

        describe "shift", ->
          beforeEach ->
            ret_val = obj.arrayProperty.shift()

          it_should_call()

          it 'should return the right value', ->
            expect(ret_val).to.eql("hello")

          it 'should shorten the array', ->
            expect(the_array.length).to.eql(3)

        describe "sort", ->
          beforeEach ->
            ret_val = obj.arrayProperty.sort()

          it_should_call

          it 'should sort the array', ->
            expect(the_array[0]).to.eql("I'm")
            expect(the_array[3]).to.eql("world")

        # describe "splice", ->


