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
  :font_source => File.expand_path('../public/font', __FILE__),
  :font_dist => {
    :public_path => File.expand_path('../public', __FILE__),
    :dir => 'font_dist',
  },
}

run App.new
