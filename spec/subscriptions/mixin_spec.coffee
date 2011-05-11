describe 'subscription mixin', ->
  target = {}
  trigger = {}

  beforeEach ->
    trigger = accessorize.mixins.change_notification target

  it 'should return a trigger function',  ->
    expect(trigger).toBeAFunction()

  it 'should provide a subscribe method', ->
    expect(target.subscribe).toBeAFunction()

  describe 'add a subscriber', ->
    callback = {}
    callbackTarget =
      callback : ->

    accessor = ->

    beforeEach ->
      callback = spyOn(callbackTarget, 'callback')
      target.subscribe(callbackTarget.callback)
      trigger('new value', accessor)

    it 'should call the subscribed callback', ->
      expect(callback).toHaveBeenCalled()

    it 'should call the subscribed callback with new value and the accessor', ->
      expect(callback).toHaveBeenCalledWith('new value', accessor)

  describe 'multiple subscriptions', ->
    callbacks =
      first_subscriber : ->
      second_subscriber : ->

    accessor = ->
    first_subscriber = undefined
    second_subscriber = undefined

    beforeEach ->
      first_subscriber = spyOn(callbacks, 'first_subscriber')
      second_subscriber = spyOn(callbacks, 'second_subscriber')
      target.subscribe callbacks.first_subscriber
      target.subscribe callbacks.second_subscriber
      trigger 'another new value', accessor

    it 'should have called both subscribers', ->
      expect(first_subscriber).toHaveBeenCalledWith('another new value', accessor)
      expect(second_subscriber).toHaveBeenCalledWith('another new value', accessor)


