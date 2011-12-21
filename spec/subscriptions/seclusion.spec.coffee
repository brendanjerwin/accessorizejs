define ['src/accessorize.js', 'sinon'], (accessorize, sinon) ->
  describe 'subscription seclusion', ->
    target1 = undefined
    target2 = undefined

    callbacks = undefined
    subscriber_for_1 = undefined
    subscriber_for_2 = undefined

    trigger_for_1 = undefined
    trigger_for_2 = undefined

    beforeEach ->
      target1 = (accessorize target: '').target
      trigger_for_1 = accessorize.mixins.change_notification target1

      target2 = (accessorize target: '').target
      trigger_for_2 =  accessorize.mixins.change_notification target2

      callbacks =
        subscriber_for_1 : ->
        subscriber_for_2 : ->
      subscriber_for_1 = sinon.spy(callbacks, 'subscriber_for_1')
      subscriber_for_2 = sinon.spy(callbacks, 'subscriber_for_2')

      target1.subscribe callbacks.subscriber_for_1
      target2.subscribe callbacks.subscriber_for_2

    describe 'target 1', ->
      beforeEach ->
        trigger_for_1('value for 1')

      it 'should have called the subscriber for 1', ->
        expect(subscriber_for_1.callCount).to.eql 2

      it 'should not have called the subscriber for 2', ->
        expect(subscriber_for_2.callCount).to.eql 1

    describe 'target 2', ->
      beforeEach ->
        trigger_for_2('value for 2')

      it 'should have called the subscriber for 2', ->
        expect(subscriber_for_2.callCount).to.eql 2

      it 'should not have called the subscriber for 1', ->
        expect(subscriber_for_1.callCount).to.eql 1
