define ['src/accessorize.js', 'sinon'], (accessorize, sinon) ->
  'use strict'

  describe 'When adding a subscription', ->
    obj = undefined

    beforeEach =>
      obj = accessorize
        prop: ''

    it 'should return a reference to the added function', =>
      thefunc = (->)
      (expect obj.prop.subscribe thefunc).to.eql thefunc

  describe 'When a subscription is removed', ->
    obj = undefined
    callback = undefined

    beforeEach =>
      obj = accessorize
        prop: ''

      callback = sinon.spy 'the subscriber'
      obj.prop.subscribe callback
      callback.reset()
      obj.prop.unsubscribe callback

    describe 'When the property is changed', =>
      beforeEach =>
        obj.prop 'new value'

      it 'should not call the subscription', =>
        (expect callback.called).to.be.false
