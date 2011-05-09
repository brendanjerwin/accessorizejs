api = exports ? (window.accessorize = {})

create_accessor = (property, source_object, target_object) ->
  if typeof source_object[property] == "object"
    source_object[property] = api.wrap source_object[property]

  accessor = (val) ->
    return source_object[property] unless val?
    return source_object[property] = val if val?

  # api.mixin_change_notification accessor.prototype

  target_object[property] = accessor


###
Takes a `target` object and wrap it in a new object with
accessor functions for all of the target object's properties.

Accessor functions and the wrapper object are  both extended
with `mixin_change_notification`; enabling observable behavior
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
api.mixin_change_notification = (target) ->
  target.subscribe = (event_handler) ->

