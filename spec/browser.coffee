specs = ['spec/basic_shape.spec']
require ['node_modules/mocha/mocha.js','node_modules/chai/chai.js'], (mocha, chai)->
  mocha = global.mocha
  mocha.setup('bdd')

  global.expect = chai.expect
  global.Assertion = chai.Assertion

  require ['spec/helpers/SpecHelper'], ->
    require specs, ->
      mocha
        .run()
        .globals(['define', 'expect','Assertion' ])
