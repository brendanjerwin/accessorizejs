global.define = requirejs = require('requirejs');
chai = require 'chai'
global.expect = chai.expect
global.Assertion = chai.Assertion

requirejs.config nodeRequire: require
global.UNDERSCORE_PATH = 'underscore'
requirejs ['spec/spec_list.js', 'spec/helpers/SpecHelper'], (list)->
  requirejs list.specs
