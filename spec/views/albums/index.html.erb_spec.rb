require 'spec_helper'

describe "albums/index" do
  before(:each) do
    assign(:albums, [
      stub_model(Album,
        :title => "Title1",
        :kind => :album
      ),
      stub_model(Album,
        :title => "Title2",
        :kind => :demo
      )
    ])
  end

  describe "renders a list of albums" do
    before { render }
    
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    specify { assert_select "tr>td", :text => /Title/, :count => 2 }
    specify { assert_select "tr>td", :text => :album.to_s, :count => 1 }
    specify { assert_select "tr>td", :text => :demo.to_s, :count => 1 }
  end
end
