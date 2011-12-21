require 'bundler/setup'
require 'sinatra/base'

# The project root directory
$root = ::File.dirname(__FILE__)

class SinatraStaticServer < Sinatra::Base

  get(/.+/) do
    send_sinatra_file(request.path) {404}
  end

  not_found do
    send_sinatra_file('404.html') {"Sorry, I cannot find #{request.path}"}
  end

  def send_sinatra_file(path, &missing_file_block)
    path.gsub!(/spec\/lib/, "lib")
    path.gsub!(/spec\/spec/, "spec")
    path.gsub!(/spec\/src/, "src")

    cache_control :must_revalidate
    expires 0, :must_revalidate
    file_path = File.join($root, path)
    file_path = File.join(file_path, 'index.html') unless file_path =~ /\.[a-z]+$/i
    File.exist?(file_path) ? send_file(file_path) : missing_file_block.call
    path
  end

end

run SinatraStaticServer
