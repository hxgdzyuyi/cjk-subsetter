require 'rack'
require 'nokogiri'
require 'digest/sha1'
require 'erb'
require 'pathname'

module Rack
  class Subset
    def initialize(app, options={})
      @app = app
      @subset_css_prefix = options[:subset_css_prefix]
      @prefix = options[:prefix]
      @symbol_font_map = options[:symbol_font_map]
      @public_path = options[:public_path]
      @font_file_dir = ::File.expand_path(options[:font_file_dir], @public_path)
      @font_dist_dir = ::File.expand_path(options[:font_dist_dir], @public_path)
      @sfnttool = ::File.expand_path("../tools/sfnttool.jar", __FILE__)
    end

    def is_cjk_char(str)
      !!(str =~ /\p{Han}|\p{Katakana}|\p{Hiragana}\p{Hangul}/)
    end

    def create_subset_map(html)
      doc = Nokogiri::HTML(html)
      doc.search('[class*="%s"]' % @prefix).each do |element|
        type = /#{@prefix}-(\w+)/.match(element['class'])[1]
        unless @subset_string_map[type]
          @subset_string_map[type] = Hash.new
        end
        set_subset_map(type, element.inner_text)
      end
    end

    def set_subset_map(type, string)
      string.each_char do |s|
        next unless is_cjk_char(s)
        @subset_string_map[type][s] = 1
      end
    end

    def html?(headers)
      headers['Content-Type'] =~ /html/
    end

    def create_path(string, font_name)
      filename = Digest::SHA1.hexdigest(string + font_name)
      @font_dist_dir + '/' + filename + '.ttf'
    end

    def call(env)
      @path = @font_dist_dir

      status, headers, body = @app.call(env)
      return [status, headers, body] unless html? headers

      response = Rack::Response.new([], status, headers)
      new_body = ""
      @subset_string_map = Hash.new

      body.each do |string|
        create_subset_map(string)
        new_body << " " << string
      end

      p_public = Pathname.new @public_path
      template = ::ERB.new ::File.read ::File.expand_path("../style.erb", __FILE__)

      @subset_string_map.each do |font_key, chars_map|
        subset_string = chars_map.map { |key, value| key }.join
        font_name = @symbol_font_map[font_key].join
        file_path = create_path(subset_string, font_name)

        unless ::File.exist? file_path
          ::File.open(file_path, 'w+')
          `java -jar #{@sfnttool} -s #{subset_string} #{@font_file_dir}/#{font_name} #{file_path}`
        end

        p_output = Pathname.new file_path
        relative_path = p_output.relative_path_from p_public
        klass = '.%s-' % @prefix + font_key
        new_body.gsub!(%r{</head>}, template.result(binding) + "</head>")
      end

      response.write new_body
      response.finish
    end
  end
end
