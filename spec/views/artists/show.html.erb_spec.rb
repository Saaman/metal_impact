require 'spec_helper'

describe "artists/show" do
  before(:each) { @artist = assign(:artist, FactoryGirl.build_stubbed(:artist, name: "Metallica", countries: ["FR", "DE"])) }

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/METALLICA/)
    rendered.should match(/France/)
    rendered.should match(/Germany/)
    rendered.should match(/band/)
  end
end
