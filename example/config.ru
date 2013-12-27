require File.join(File.dirname(__FILE__), './app')
require File.join(File.dirname(__FILE__), '../lib/rack/subsetter')

use Rack::Subsetter, {
  :font_map => {
    'sentychalk' => ['/senty/SentyChalk', '.ttf'],
  },
  :prefix => 'webfont',
  :font_source => File.expand_path('../public/font', __FILE__),
  :font_dist => {
    :public_path => File.expand_path('../public', __FILE__),
    :dir => 'font_dist',
  },
  :relative_url_root => '/',
}

run App.new
