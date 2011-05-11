###
_Add observable accessors to any object._

`accessorize.js` makes it easy to convert plain javascript 'properties'
into fancy-ass-observable-accessor-methods!

See [accessorizejs.com](http://accessorizejs.com) for more info and license information.

###
'use strict'


###
Find a reasonable place to hang our api. Fall back to a global `accessorize` object if we have to.

  **TODO:** Need to detect an amd compatible `define` function and use it if we can.
###
api = window.accessorize ? (window.accessorize = {})
api.mixins = {}


#A bunch of utilities stollen from underscore. Need to find a way to use underscore if its available
isArray = Array.isArray || (obj) ->
  toString.call(obj) == '[object Array]'

isNumber = (obj) ->
  !!(obj == 0 || (obj && obj.toExponential && obj.toFixed))

nativeBind = Function.prototype.bind
bind = (func, obj) ->
    return nativeBind.apply(func, slice.call(arguments, 1)) if (func.bind == nativeBind && nativeBind)
    args = slice.call(arguments, 2)
    return ->
      return func.apply(obj, args.concat(slice.call(arguments)))




create_accessor = (property, source_object, target_object) ->
  source_val = source_object[property]

  if typeof source_val == "object" and not isArray source_val
    source_object[property] = api.wrap source_object[property]

  change_notification_trigger = undefined

  simple_accessor = (val) ->
    return source_object[property] unless val?

    source_object[property] = val
    change_notification_trigger(val, accessor)
    return val

  if isArray source_val then accessor = (valOrIndex, indexedVal) ->
    if isNumber(valOrIndex) and indexedVal?
        source_object[property][valOrIndex] = indexedVal
        change_notification_trigger(indexedVal, accessor)
        return indexedVal

    return source_object[property][valOrIndex] if isNumber valOrIndex
    return simple_accessor(valOrIndex)
  else accessor = simple_accessor

  change_notification_trigger = api.mixins.change_notification accessor

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
api.wrap = (target, recurse=true) ->
  wrapped = {}

  is_a_wrappable = (property) ->
    typeof target[property] != 'function'

  create_accessor(property, target, wrapped) for own property of target when is_a_wrappable property

  wrapped.prototype = target
  return wrapped


###

###
api.mixins.change_notification = (target) ->
  subscriptions = []

  target.subscribe = (event_handler) ->
    subscriptions.push event_handler
    return event_handler

  return (new_value, accessor) ->
    handler(new_value, accessor) for handler in subscriptions
