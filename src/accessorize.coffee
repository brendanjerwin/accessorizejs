###
_Add observable accessors to any object._

`accessorize.js` makes it easy to convert plain javascript 'properties'
into fancy-ass-observable-accessor-methods!

See [accessorizejs.com](http://accessorizejs.com) for more info and license information.

###
UNDERSCORE_PATH = "lib/underscore"
define [UNDERSCORE_PATH], (_) ->
  'use strict'

  #Check runtime requirements
  if not JSON? then throw new Error('JSON is required for accessorize to run. You can get a polyfill here: https://github.com/douglascrockford/JSON-js/blob/master/json2.js')
  if not _? then throw new Error("Did not get an instance of underscore (_) loaded from #{UNDERSCORE_PATH}. The underscore module probably didn't `return` the object.")

  api = undefined

  slice = Array.prototype.slice

  newFrom = (prototype) ->
    f = ->
    f.prototype = prototype
    return new f

  is_value_that_should_be_accessorized = (val) ->
    return no if _.isArray val
    return no if val instanceof Date
    return yes if typeof val == "object"

  toggle_promoted_array_methods = (backing_value, target_accessor, change_notification_trigger) ->
    change_causing_methods = ['pop','push','reverse','shift','sort','splice','unshift']
    other_methods = ['concat', 'join', 'slice', 'indexOf', 'lastIndexOf']

    remove = (method) ->
      delete target_accessor[method]

    remove method for method in change_causing_methods.concat other_methods

    return unless _.isArray backing_value

    promote = (method) ->
      target_accessor[method] = () ->
        ret_val = backing_value[method].apply(backing_value, slice.call(arguments))
        change_notification_trigger(target_accessor(), target_accessor)
        return ret_val

    promote method for method in change_causing_methods

    promote = (method) ->
      if backing_value[method]
        target_accessor[method] = _.bind backing_value[method], backing_value

    promote method for method in other_methods

  create_accessor = (property, source_object, target_object) ->
    source_val = source_object[property]

    if source_val? and is_value_that_should_be_accessorized source_val
      source_object[property] = api(source_object[property])

    change_notification_trigger = undefined

    simple_accessor = (val) ->
      return _(source_object[property]) if val == _

      return source_object[property] unless val?

      source_object[property] = if is_value_that_should_be_accessorized val then api val else val
      toggle_promoted_array_methods val, accessor, change_notification_trigger
      change_notification_trigger(val, accessor)
      return target_object

    if _.isArray source_val

      accessor = (valOrIndex, indexedVal) ->
        if _.isNumber(valOrIndex) and indexedVal?
          return _(source_object[property][valOrIndex]) if indexedVal == _

          source_object[property][valOrIndex] = if is_value_that_should_be_accessorized indexedVal then api indexedVal else indexedVal
          change_notification_trigger(indexedVal, accessor)
          return target_object

        return source_object[property][valOrIndex] if _.isNumber valOrIndex
        return simple_accessor(valOrIndex)
    else accessor = simple_accessor

    accessor.__accessorized_accessor = true

    change_notification_trigger = api.mixins.change_notification accessor
    toggle_promoted_array_methods source_val, accessor, change_notification_trigger
    api.mixins.json_serialization accessor, -> source_object[property]

    target_object[property] = accessor


  api = (target, recurse=true) ->
    if api.isAccessorized target then return target

    wrapped = newFrom target

    should_create_accessor_for = (property) ->
      typeof target[property] != 'function'

    create_accessor(property, target, wrapped) for own property of target when should_create_accessor_for property

    wrapped.__accessorized_object = yes

    api.mixins.json_serialization wrapped, target
    api.mixins.add_accessor wrapped, target

    return wrapped


  api.isAccessorized = (obj) ->
    return no if not obj?
    return {kind : 'object' } if obj.__accessorized_object
    return {kind : 'accessor' } if obj.__accessorized_accessor
    return no


  api.mixins = {}

  api.mixins.add_accessor = (target, backer) ->
    target.addAccessor = (name, initialValue=undefined) ->
      throw new api.errors.PropertyAlreadyExistsError(name) if name of target
      backer[name] = initialValue
      create_accessor name, backer, target

  api.mixins.change_notification = (target) ->
    subscriptions = []

    target.subscribe = (event_handler) ->
      subscriptions.push event_handler
      event_handler target(), target
      return event_handler

    target.unsubscribe = (event_handler) ->
      subscriptions = _(subscriptions).reject (existing) =>
        existing == event_handler

    return (new_value, accessor) ->
      handler(new_value, accessor) for handler in subscriptions

  is_accessor = (property) ->
    sniff = api.isAccessorized property
    return false unless sniff
    return sniff.kind is 'accessor'

  api.mixins.json_serialization = (target, backer) ->
    throw new Error 'can only mix-in on accessorized objects' unless api.isAccessorized target

    target.toJSON = ->
      #we allow a function here just in case the property backer wasn't an object, this lets us always dereference the property just in time
      val = if _.isFunction backer then backer() else backer
      return val.toJSON() if val.toJSON?
      return val


  api.errors =
    PropertyAlreadyExistsError : class PropertyAlreadyExistsError extends Error
      constructor : (@attemptedPropertyName) ->
        @name = 'PropertyAlreadyExistsError'
        @message = "The name of the property you are attempting to add [#{@attemptedPropertyName}] already exists on this object's prototype chain."

  #export the api
  return api
