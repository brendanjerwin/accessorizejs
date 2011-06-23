define ['src/accessorize'], (accessorize) ->
  'use strict'

  describe 'array accessors with subscriptions ', ->

    beforeEach ->
      callee =
        subscriber: ->
      @subscriber = spyOn callee, 'subscriber'

      @original = ['original']

      @obj = accessorize
        arrayProperty: @original

      @obj.arrayProperty.subscribe callee.subscriber

    describe 'when the underlying array value is changed', ->

      beforeEach ->
        @new = ['new']
        @obj.arrayProperty @new

      it 'should call the subscription with the new array value', ->
        (expect @subscriber).toHaveBeenCalledWith ['new'], @obj.arrayProperty

      describe 'when a promoted mutator is called', ->

        beforeEach ->
          @obj.arrayProperty.push 'another'

        it 'should mutate the correct array (new value)', ->
          (expect @new.length).toBe 2
          (expect @new[1]).toEqual 'another'

        it 'should call the subscription with the new array value', ->
          (expect @subscriber).toHaveBeenCalledWith ['new', 'another'], @obj.arrayProperty
