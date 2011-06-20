define ['src/accessorize'], (accessorize) ->
  'use strict'

  describe 'wrapping an object twice', ->

    beforeEach ->
      @firstTime = accessorize simpleProperty: 'hello'
      @secondTime = accessorize @firstTime

    it 'should return the same object', ->
      (expect @secondTime).toBe @firstTime

    it 'should return a working acccessorized object', ->
      (expect @secondTime.simpleProperty()).toEqual 'hello'
