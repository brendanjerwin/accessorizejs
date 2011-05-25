{exec} = require 'child_process'
task 'build', 'Build project from src/*.coffee to release/*.js', ->
  exec 'coffee --compile --output release/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'minify', 'Minify the resulting application file after build', ->
  exec './node_modules/uglify-js/bin/uglifyjs --reserved-names "require,define,_" --output release/accessorize.min.js release/accessorize.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

