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
  throw new Error('JSON is required for accessorize to run. You can get a polyfill here: https://github.com/douglascrockford/JSON-js/blob/master/json2.js') unless JSON?
  throw new Error("Did not get an instance of underscore (_) loaded from #{UNDERSCORE_PATH}. The underscore module probably didn't `return` the object.") unless _?

  api = undefined

  #A bunch of utilities stollen from underscore. Need to find a way to use underscore if its available
  isArray = Array.isArray || (obj) ->
    toString.call(obj) == '[object Array]'

  isNumber = (obj) ->
    !!(obj == 0 || (obj && obj.toExponential && obj.toFixed))

  slice = Array.prototype.slice

  bind = (func, obj) ->
    nativeBind = Function.prototype.bind
    return nativeBind.apply(func, slice.call(arguments, 1)) if (func.bind == nativeBind && nativeBind)
    args = slice.call(arguments, 2)
    return ->
      return func.apply(obj, args.concat(slice.call(arguments)))


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
        target_accessor[method] = bind(source_array[method], source_array)

      promote method for method in other_methods

  create_accessor = (property, source_object, target_object) ->
    source_val = source_object[property]

    if source_val? and typeof source_val == "object" and not isArray source_val
      source_object[property] = api(source_object[property])

    change_notification_trigger = undefined

    simple_accessor = (val) ->
      return _(source_object[property]) if val == _

      return source_object[property] unless val?

      source_object[property] = val
      change_notification_trigger(val, accessor)
      return target_object

    if isArray source_val

      accessor = (valOrIndex, indexedVal) ->
        if isNumber(valOrIndex) and indexedVal?
          return _(source_object[property][valOrIndex]) if indexedVal == _

          source_object[property][valOrIndex] = indexedVal
          change_notification_trigger(indexedVal, accessor)
          return target_object

        return source_object[property][valOrIndex] if isNumber valOrIndex
        return simple_accessor(valOrIndex)
    else accessor = simple_accessor

    accessor.__accessorized_accessor = true

    change_notification_trigger = api.mixins.change_notification accessor
    promote_array_methods source_val, accessor, change_notification_trigger if isArray source_val

    api.mixins.json_serialization accessor, -> source_object[property]

    target_object[property] = accessor


  api = (target, recurse=true) ->
    wrapped = {}

    is_a_wrappable = (property) ->
      typeof target[property] != 'function'

    create_accessor(property, target, wrapped) for own property of target when is_a_wrappable property

    wrapped.prototype = target
    wrapped.__accessorized_object = yes

    api.mixins.json_serialization wrapped
    api.mixins.add_accessor wrapped

    return wrapped


  api.isAccessorized = (obj) ->
    return no if not obj?
    return {kind : 'object' } if obj.__accessorized_object
    return {kind : 'accessor' } if obj.__accessorized_accessor
    return no


  api.mixins = {}

  api.mixins.add_accessor = (target) ->
    target.addAccessor = (name) ->
      create_accessor name, target.prototype, target

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

  api.mixins.json_serialization = (target, accessor_backer) ->
    sniff = api.isAccessorized target
    throw new Error 'can only mix-in on accessorized objects' unless sniff

    if sniff.kind is 'object' then target.toJSON = ->
      target.prototype

    if sniff.kind is 'accessor' then target.toJSON = ->
      val = accessor_backer()
      return val.toJSON() if val.toJSON?
      return val


  #export the api
  return api
