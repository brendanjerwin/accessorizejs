# vim: set filetype=coffee.jasmine :

define ['src/accessorize.js'], (accessorize) ->
  'use strict'

  describe 'When adding a subscription', ->
    beforeEach =>
      @obj = accessorize
        prop: ''

    it 'should return a reference to the added function', =>
      thefunc = (->)
      (expect @obj.prop.subscribe thefunc).toBe thefunc

  describe 'When a subscription is removed', ->
    beforeEach =>
      @obj = accessorize
        prop: ''

      @callback = jasmine.createSpy 'the subscriber'
      @obj.prop.subscribe @callback
      @callback.reset()
      @obj.prop.unsubscribe @callback

    describe 'When the property is changed', =>
      beforeEach =>
        @obj.prop 'new value'

      it 'should not call the subscription', =>
        (expect @callback).not.toHaveBeenCalled()



