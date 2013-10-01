require 'rack'
module Rack
  class Subset
    def initialize(app, options={})
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      append_s = "test"
      new_body = ""
      body.each { |string| new_body << " " << string }
      new_body << " " << append_s
      [status, headers, [new_body]]
    end
  end
end
