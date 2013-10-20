require 'rubygems'

require './app'
require '../lib/rack/subset'

require 'rack/cache'

use Rack::Cache,
  :metastore   => 'file:./cache/rack/meta',
  :entitystore => 'file:./cache/rack/body'

use Rack::Subset, {
  :font_map => {
    'sentychalk' => ['/senty/SentyChalk', '.ttf'],
  },
  :prefix => 'webfont',
  :font_file_dir => 'font',
  :font_dist_dir => 'font_dist',
  :public_path => File.expand_path('../public', __FILE__)
}

run App.new
