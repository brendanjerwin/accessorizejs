{exec} = require 'child_process'
task 'build', 'Build project from src/*.coffee to release/*.js', ->
  exec 'coffee --compile --output release/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'minify', 'Minify the resulting application file after build', ->
  exec './node_modules/uglify-js/bin/uglifyjs --reserved-names "require,define,_" --output release/accessorize.min.js release/accessorize.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'test', 'Run the specs', ->
  exec '/.node_modules/coffee-script/bin/coffee --compile spec'
  exec '/.node_modules/coffee-script/bin/coffee --compile src'
  exec './node_modules/mocha/bin/mocha ./spec/initialize.coffee --colors --growl --reporter dot', (err, stdout, stderr) ->
    console.log stdout + stderr

