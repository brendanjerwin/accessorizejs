define ['src/accessorize.js', 'sinon'], (accessorize, sinon) ->
  describe 'subscription mixin', ->
    target = (accessorize target: '').target
    trigger = {}

    beforeEach ->
      trigger = accessorize.mixins.change_notification target

    it 'should return a trigger function', ->
      expect(trigger).to.be.a.function

    it 'should provide a subscribe method', ->
      expect(target.subscribe).to.be.a.function

    describe 'add a subscriber', ->
      callback = {}
      callbackTarget = undefined
      accessor = ->

      beforeEach ->
        callbackTarget =
          callback : ->
        callback = sinon.spy(callbackTarget, 'callback')
        target.subscribe(callbackTarget.callback)
        trigger('new value', accessor)

      it 'should call the subscribed callback', ->
        expect(callback.called).to.be.true

      it 'should call the subscribed callback with new value and the accessor', ->
        expect(callback.calledWith 'new value', accessor)

    describe 'multiple subscriptions', ->
      callbacks =
        first_subscriber : ->
        second_subscriber : ->

      accessor = ->
      first_subscriber = undefined
      second_subscriber = undefined

      beforeEach ->
        first_subscriber = sinon.spy(callbacks, 'first_subscriber')
        second_subscriber = sinon.spy(callbacks, 'second_subscriber')
        target.subscribe callbacks.first_subscriber
        target.subscribe callbacks.second_subscriber
        trigger 'another new value', accessor

      it 'should have called both subscribers', ->
        expect(first_subscriber.calledWith 'another new value', accessor)
        expect(second_subscriber.calledWith 'another new value', accessor)


