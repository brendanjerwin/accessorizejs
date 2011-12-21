define ['src/accessorize.js'], (accessorize) ->
  'use strict'

  describe 'wrapping an object twice', ->
    firstTime = undefined
    secondTime = undefined

    beforeEach ->
      firstTime = accessorize simpleProperty: 'hello'
      secondTime = accessorize firstTime

    it 'should return the same object', ->
      (expect secondTime).to.eql firstTime

    it 'should return a working acccessorized object', ->
      (expect secondTime.simpleProperty()).to.eql 'hello'
