global.define = requirejs = require('requirejs');
chai = require 'chai'
global.expect = chai.expect
global.Assertion = chai.Assertion

requirejs.config nodeRequire: require

requirejs ['spec/helpers/SpecHelper'], ->
  requirejs ['spec/basic_shape.spec']
