require 'spec_helper'

describe "albums/show" do
  let(:album) { FactoryGirl.create(:album_with_artists,
      :title => "Ride The Lightning",
      :kind => :mini_album,
      :release_date => DateTime.now
    ) }
  before(:each) do
    @album = album
    @album.stub(:artists).and_return([FactoryGirl.build(Artist, name: "Metallica")])
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Ride The Lightning/)
    rendered.should match(/Mini album/)
    rendered.should match(/METALLICA/)
    rendered.should match(/Edit/)
    rendered.should match(/Back/)
  end
end
