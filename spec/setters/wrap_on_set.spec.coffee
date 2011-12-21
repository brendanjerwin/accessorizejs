define ['src/accessorize.js'], (accessorize) ->
  'use strict'

  describe 'wrap on set', ->
    parent = null

    describe 'when the accessor is an array accessor', ->

      beforeEach ->
        parent = accessorize arrayProperty: [1,2,3]

      it 'should not wrap', ->
        parent.arrayProperty []
        (expect parent.arrayProperty()).not.to.be.accessorized

      describe 'when the accessor is an indexed array accessor', ->
        describe_non_object = (value, name) ->
          describe "when the value is a #{name}", ->
            beforeEach ->
              parent.arrayProperty 1, value

            it 'should not wrap', ->
              (expect parent.arrayProperty(1)).not.to.be.accessorized

        describe_object = (value, name) ->
          describe "when the value is a #{name}", ->
            beforeEach ->
              parent.arrayProperty 1, value

            it 'should wrap', ->
              (expect parent.arrayProperty(1)).to.be.accessorized

    describe 'when the accessor is a regular accessor', ->

      beforeEach ->
        parent = accessorize simpleProperty: 'something'
        parent = parent

      describe_non_object = (value, name) ->
        describe "when the value is a #{name}", ->
          beforeEach ->
            parent.simpleProperty value

          it 'should not wrap', ->
            (expect parent.simpleProperty()).not.to.be.accessorized

      describe_object = (value, name) ->
        describe "when the value is a #{name}", ->
          beforeEach ->
            parent.simpleProperty value

          it 'should wrap', ->
            (expect parent.simpleProperty()).to.be.accessorized

      describe_object {prop: "1"}, "object"

      describe_non_object new Date, 'foo date'
      describe_non_object 'string', 'string'
      describe_non_object 1, 'number'
      describe_non_object (->), 'function'


