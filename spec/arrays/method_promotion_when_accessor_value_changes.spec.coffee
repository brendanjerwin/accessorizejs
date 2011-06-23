define ['src/accessorize'], (accessorize) ->
  'use strict'

  describe 'array method promotion', ->

    describe 'when the original value is an array', ->

      beforeEach ->
        @obj = accessorize
          property: []

      it 'should promote the methods', ->
        (expect @obj.property.push).toBeAFunction()

      describe 'when the new value is an array', ->

        beforeEach ->
          @obj.property ['new']

        it 'should promote the methods', ->
          (expect @obj.property.push).toBeAFunction()

      describe 'when the new value is not an array', ->

        beforeEach ->
          @obj.property "s"

        it 'should set the value', ->
          (expect @obj.property()).toBe "s"

        it 'should not promote the methods', ->
          (expect @obj.property.push).toBeUndefined()



    describe 'when the original value is not an array', ->

      beforeEach ->
        @obj = accessorize
          property: 'string'

      it 'should not promote the methods', ->
        (expect @obj.property.push).toBeUndefined()

      describe 'when the new value is an array', ->

        beforeEach ->
          @obj.property ['new']

        it 'should promote the methods', ->
          (expect @obj.property.push).toBeAFunction()

      describe 'when the new value is not an array', ->

        beforeEach ->
          @obj.property 'string'

        it 'should not promote the methods', ->
          (expect @obj.property.push).toBeUndefined()
