PROJECT_ROOT_PATH = File.dirname(File.dirname(File.dirname(__FILE__))) \
  unless defined? PROJECT_ROOT_PATH

require File.join(File.dirname(__FILE__), './app')
require File.join(File.dirname(__FILE__), '../../lib/rack/subsetter')

use Rack::Subsetter, {
  :font_map => {
    'sentychalk' => ['/senty/SentyChalk', '.ttf'],
  },
  :prefix => 'webfont',
  :font_source => File.join(PROJECT_ROOT_PATH, './vendor/free-chinese-font'),
  :font_dist => {
    :public_path => File.expand_path('../public', __FILE__),
    :dir => 'font_dist',
  },
  :relative_url_root => '/',
}

run App.new
