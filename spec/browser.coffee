require ['node_modules/mocha/mocha.js','node_modules/chai/chai.js','node_modules/underscore/underscore.js'], (mocha, chai)->
  mocha = global.mocha
  mocha.setup('bdd')

  global.expect = chai.expect
  global.Assertion = chai.Assertion

  require ['spec/spec_list', 'spec/helpers/SpecHelper'], (list)->
    require list.specs, ->
      mocha
        .run()
        .globals(['define', 'expect','Assertion' ])
