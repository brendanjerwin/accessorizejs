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

  nativeBind = Function.prototype.bind
  bind = (func, obj) ->
    return (nativeBind.apply func, slice.call(arguments, 1)) if nativeBind? and func.bind is nativeBind
    args = slice.call(arguments, 2)
    return ->
      func.apply(obj, args.concat(slice.call(arguments)))

  promote_array_methods = (source_array, target_accessor, change_notification_trigger) ->
      change_causing_methods = ['pop','push','reverse','shift','sort','splice','unshift']
      other_methods = ['concat', 'join', 'slice', 'indexOf', 'lastIndexOf']

      promote = (method) ->
        target_accessor[method] = () ->
          ret_val = source_array[method].apply(source_array, slice.call(arguments))
          change_notification_trigger(target_accessor(), target_accessor)
          return ret_val

      promote method for method in change_causing_methods

      promote = (method) ->
        target_accessor[method] = bind source_array[method], source_array

      promote method for method in other_methods

  create_accessor = (property, source_object, target_object) ->
    source_val = source_object[property]

    if source_val? and typeof source_val == "object" and not _.isArray source_val
      source_object[property] = api(source_object[property])

    change_notification_trigger = undefined

    simple_accessor = (val) ->
      return _(source_object[property]) if val == _

      return source_object[property] unless val?

      source_object[property] = val
      change_notification_trigger(val, accessor)
      return target_object

    if _.isArray source_val

      accessor = (valOrIndex, indexedVal) ->
        if _.isNumber(valOrIndex) and indexedVal?
          return _(source_object[property][valOrIndex]) if indexedVal == _

          source_object[property][valOrIndex] = indexedVal
          change_notification_trigger(indexedVal, accessor)
          return target_object

        return source_object[property][valOrIndex] if _.isNumber valOrIndex
        return simple_accessor(valOrIndex)
    else accessor = simple_accessor

    accessor.__accessorized_accessor = true

    change_notification_trigger = api.mixins.change_notification accessor
    promote_array_methods source_val, accessor, change_notification_trigger if _.isArray source_val

    api.mixins.json_serialization accessor, -> source_object[property]

    target_object[property] = accessor


  api = (target, recurse=true) ->
    wrapped = newFrom target

    is_a_wrappable = (property) ->
      typeof target[property] != 'function'

    create_accessor(property, target, wrapped) for own property of target when is_a_wrappable property

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
      return event_handler

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
