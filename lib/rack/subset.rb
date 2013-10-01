require 'rack'
require 'nokogiri'
require 'erb'

module Rack
  class Subset
    def initialize(app, options={})
      @app = app
      @subset_css_prefix = options[:subset_css_prefix]
      @symbol_font_map = options[:symbol_font_map]
      @font_file_dir = options[:font_file_dir]
      @template ||= ::ERB.new ::File.read ::File.expand_path("../style.erb", __FILE__)
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

    def html?(headers)
      headers['Content-Type'] =~ /html/
    end

    def create_tempfile
      Tempfile.new(::File.basename(@path)).tap { |f| f.close }
    end

    def call(env)
      @path = env["PATH_INFO"]

      status, headers, body = @app.call(env)
      return [status, headers, body] unless html? headers

      response = Rack::Response.new([], status, headers)
      new_body = ""
      subset_string = ""

      body.each do |string|
        subset_string << get_cjk_set(string)
        new_body << " " << string
      end

      new_body.gsub!(%r{</head>}, @template.result() + "</head>")
      new_body.gsub!(%r{</body>}, subset_string + "</body>")
      response.write new_body
      response.finish
    end
  end
end
