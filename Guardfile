# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'coffeescript', :output => '.' do
  watch(%r{(^src.+\.coffee)})
  watch(%r{(^spec.+\.coffee)})
end

guard 'livereload', :apply_js_live => false do
  watch(%r{(^src.+\.coffee)})
  watch(%r{(^spec.+\.coffee)})
end
