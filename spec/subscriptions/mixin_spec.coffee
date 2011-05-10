describe 'subscription mixin', ->
  target = {}
  trigger = {}

  beforeEach ->
    trigger = accessorize.mixin_change_notification target

  it 'should return a trigger function',  ->
    expect(trigger).toBeAFunction()

  it 'should provide a subscribe method', ->
    expect(target.subscribe).toBeAFunction()

