define ['src/accessorize'],  (accessorize) ->
  beforeEach ->
    @addMatchers
      toBeAFunction : ->
        typeof this.actual == 'function'

      toBeAnObject : ->
        typeof this.actual == 'object'

      toBeAnAccessor : ->
        accessorize.isAccessorized this.actual


