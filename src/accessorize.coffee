###
_Add observable accessors to any object._

`accessorize.js` makes it easy to convert plain javascript 'properties'
into fancy-ass-observable-accessor-methods!

See [accessorizejs.com](http://accessorizejs.com) for more info and license information.

###
define ["lib/underscore"], (_) ->
  'use strict'

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

    change_notification_trigger = api.mixins.change_notification accessor
    promote_array_methods source_val, accessor, change_notification_trigger if isArray source_val

    accessor.__accessorized_accessor = true
    target_object[property] = accessor


  ###
  Takes a `target` object and wrap it in a new object with
  accessor functions for all of the target object's properties.

  Accessor functions and the wrapper object are  both extended
  with `mixins.change_notification`; enabling observable behavior
  at both the individual property level and the object level.

  (As a point of interest: the first subscriber to each accessor's
  change notification is the parent wrapper object itself.)

  Wrapping an object will not touch its methods, but since the
  original object is set to the wrapper's prototype, they are
  still accessible.

  If a property's _value_ is an object itself, then the value
  object is also wrapped. This behavior can be disabled by
  passing `false` for the second, `recurse`, parameter.

    TODO: Make the recurse option turn-off-able

  ###
  api = (target, recurse=true) ->
    wrapped = {}

    is_a_wrappable = (property) ->
      typeof target[property] != 'function'

    create_accessor(property, target, wrapped) for own property of target when is_a_wrappable property

    wrapped.prototype = target
    wrapped.__accessorized_object = yes
    return wrapped


  api.isAccessorized = (obj) ->
    return no if not obj?
    return {kind : 'object' } if obj.__accessorized_object
    return {kind : 'accessor' } if obj.__accessorized_accessor
    return no


  api.mixins = {}
  api.mixins.change_notification = (target) ->
    subscriptions = []

    target.subscribe = (event_handler) ->
      subscriptions.push event_handler
      return event_handler

    return (new_value, accessor) ->
      handler(new_value, accessor) for handler in subscriptions

  #export the api
  return api
