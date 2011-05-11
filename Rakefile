
require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

# Bring in Rocco tasks
require 'rocco/tasks'


namespace :docs do

    Rocco::make 'docs/', 'lib/**/*.coffee'

    desc 'Build docs'
    task :build => :rocco

    desc 'Build docs and open in browser for the reading'
    task :read => :rocco do
      sh 'open docs/lib/accessorize.html'
    end

end
