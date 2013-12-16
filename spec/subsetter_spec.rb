require File.join(File.dirname(__FILE__), './spec_helper')

describe "Cjk Subsetter" do
  it "check page can be visited" do
    visit '/'
    expect(page).to have_content 'Chalk'
  end
end
