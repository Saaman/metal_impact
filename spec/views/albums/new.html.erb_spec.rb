require 'spec_helper'

describe "albums/new" do
  before(:each) do
    assign(:album, stub_model(Album,
      :title => "MyString",
      :album_type => ""
    ).as_new_record)
  end

  it "renders new album form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => albums_path, :method => "post" do
      assert_select "input#album_title", :name => "album[title]"
      assert_select "input#album_album_type", :name => "album[album_type]"
    end
  end
end
