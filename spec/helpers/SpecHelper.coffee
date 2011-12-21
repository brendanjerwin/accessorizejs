define ['src/accessorize'], (accessorize) ->

  Assertion.prototype.typeof = (type) ->
    this.assert(
          typeof this.obj == type
        , 'expected ' + this.inspect + ' to be a ' + type
        , 'expected ' + this.inspect + ' to not to be a ' + type);

      return this

  Object.defineProperty Assertion.prototype, 'accessor',
  get: ->
    this.assert(
        accessorize.isAccessorized this.obj
      , 'expected ' + this.inspect + ' to be an accessor'
      , 'expected ' + this.inspect + ' to not be an accessor');

    return this

  Object.defineProperty Assertion.prototype, 'accessorized',
  get: ->
    this.assert(
        !!(accessorize.isAccessorized this.obj)
      , 'expected ' + this.inspect + ' to be accessorized'
      , 'expected ' + this.inspect + ' to not be accessorized');

    return this
