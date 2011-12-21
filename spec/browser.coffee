require ['node_modules/mocha/mocha.js','node_modules/chai/chai.js','node_modules/underscore/underscore.js', 'node_modules/sinon/pkg/sinon-1.2.0.js'], (mocha, chai, sinon)->
  mocha = global.mocha
  mocha.setup('bdd')

  global.expect = chai.expect
  global.Assertion = chai.Assertion

  sinon = global.sinon
  global.sinon = undefined
  define 'sinon', -> sinon

  require ['spec/spec_list', 'spec/helpers/SpecHelper'], (list)->
    require list.specs, ->
      mocha
        .run()
        .globals(['define', 'expect','Assertion' ])
