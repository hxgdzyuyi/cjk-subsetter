require 'rack'
require 'nokogiri'

module Rack
  class Subset
    def initialize(app, options={})
      @app = app
    end

    def is_cjk_char(str)
      !!(str =~ /\p{Han}|\p{Katakana}|\p{Hiragana}\p{Hangul}/)
    end

    def get_cjk_set(html)
      doc = Nokogiri::HTML(html)
      inner_text = doc.search('.cjk').inner_text
      dict = Hash.new
      inner_text.each_char do |s|
        next unless is_cjk_char(s)
        dict[s] = 1
      end
      dict.map { |key, value| key }.join
    end

    def call(env)
      status, headers, body = @app.call(env)
      new_body = ""
      append_s = ""
      body.each do |string|
        append_s << get_cjk_set(string)
        new_body << " " << string
      end
      new_body << " " << append_s
      [status, headers, [new_body]]
    end
  end
end
