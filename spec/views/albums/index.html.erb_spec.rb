require 'spec_helper'

describe "albums/index" do
  before(:each) do
    assign(:albums, [
      stub_model(Album,
        :title => "Title",
        :album_type => "Type"
      ),
      stub_model(Album,
        :title => "Title",
        :album_type => "Type"
      )
    ])
  end

  it "renders a list of albums" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
  end
end
