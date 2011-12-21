define ['src/accessorize.js', 'sinon'], (accessorize, sinon) ->
  'use strict'

  describe 'array accessors with subscriptions ', ->
    obj = null
    subscriber = null
    original = null
    theNew = null

    beforeEach ->
      callee =
        subscriber: ->
      subscriber = sinon.spy callee, 'subscriber'

      original = ['original']

      obj = accessorize
        arrayProperty: original

      obj.arrayProperty.subscribe callee.subscriber

    describe 'when the underlying array value is changed', ->

      beforeEach ->
        theNew = ['new']
        obj.arrayProperty theNew

      it 'should call the subscription with the new array value', ->
        expect subscriber.calledWith 'new', obj.arrayProperty

      describe 'when a promoted mutator is called', ->

        beforeEach ->
          obj.arrayProperty.push 'another'

        it 'should mutate the correct array (new value)', ->
          (expect theNew.length).to.eql 2
          (expect theNew[1]).to.eql 'another'

        it 'should call the subscription with the new array value', ->
          expect subscriber.calledWith 'new', 'another', obj.arrayProperty
