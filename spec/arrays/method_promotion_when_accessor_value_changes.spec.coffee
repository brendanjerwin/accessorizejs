define ['src/accessorize.js'], (accessorize) ->
  'use strict'

  describe 'array method promotion', ->
    obj = null
    describe 'when the original value is an array', ->

      beforeEach ->
        obj = accessorize
          property: []

      it 'should promote the methods', ->
        (expect obj.property.push).to.be.a.function

      describe 'when the new value is an array', ->

        beforeEach ->
          obj.property ['new']

        it 'should promote the methods', ->
          (expect obj.property.push).to.be.a.function

      describe 'when the new value is not an array', ->

        beforeEach ->
          obj.property "s"

        it 'should set the value', ->
          (expect obj.property()).to.eql "s"

        it 'should not promote the methods', ->
          (expect obj.property.push).not.to.exist



    describe 'when the original value is not an array', ->

      beforeEach ->
        obj = accessorize
          property: 'string'

      it 'should not promote the methods', ->
        (expect obj.property.push).not.to.exist

      describe 'when the new value is an array', ->

        beforeEach ->
          obj.property ['new']

        it 'should promote the methods', ->
          (expect obj.property.push).to.be.a.function

      describe 'when the new value is not an array', ->

        beforeEach ->
          obj.property 'string'

        it 'should not promote the methods', ->
          (expect obj.property.push).not.to.exist
