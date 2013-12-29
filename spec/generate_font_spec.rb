require File.join(File.dirname(__FILE__), './spec_helper')

describe "Generate ttf" do
  GENERATE_TTF_FIXTURE = File.join(FIXTURES_ROOT, 'generate-font')
  FONT_DIST = File.join(GENERATE_TTF_FIXTURE, './public/font_dist')

  before(:each) do
    Capybara.app = Rack::Builder.parse_file(
      File.join(GENERATE_TTF_FIXTURE, '/config.ru')).first
    FileUtils.rm_rf(Dir.glob("#{FONT_DIST}/*"))
  end

  it "page can be visted" do
    visit '/'
    expect(page).to have_content 'Chalk'
  end

  it "TTF should be generated" do
    visit '/'
    font_is_generated = File.exist?(File.join(
      FONT_DIST, '448ab822cd2af69dc18fbf3ebb1ae5858f78da3b.ttf'))
    expect(font_is_generated).to be_true
  end
end
