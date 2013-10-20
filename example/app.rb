require 'sinatra/base'

class App < Sinatra::Base
  set :public_folder, File.expand_path('../public', __FILE__)
  get '/' do
    erb :index
  end
end
