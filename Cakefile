{exec} = require 'child_process'
fs = require 'fs'
file = require 'file'
logger = (callback) ->
    return (err, stdout, stderr) ->
      console.log stdout + stderr
      throw err if err
      callback?()

task 'build', 'Build project from src/*.coffee to release/*.js', ->
  exec 'coffee --compile --output release/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'minify', 'Minify the resulting application file after build', ->
  exec './node_modules/uglify-js/bin/uglifyjs --reserved-names "require,define,_" --output release/accessorize.min.js release/accessorize.js', logger()

task 'test', 'Run the specs', ->
  exec 'node_modules/coffee-script/bin/coffee --compile spec', logger ->
    exec 'node_modules/coffee-script/bin/coffee --compile src', logger ->
      specs = []
      file.walkSync 'spec', (dirPath, dirs, files) ->
        files = (dirPath + "/" + file for file in files when file.match /.*spec\.js/) if files?
        specs = specs.concat files

      fs.writeFileSync 'spec/spec_list.js', "define([], {specs : #{JSON.stringify specs}})"
      exec './node_modules/mocha/bin/mocha ./spec/initialize.coffee --colors --growl --reporter dot', logger()
