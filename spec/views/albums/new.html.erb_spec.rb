require 'spec_helper'

# TODO : revoir les tests de ces écrans. Il suffit de tester _form en fait, et rajouter le test de tous les champs. Cf vues users
describe "albums/new" do
  before(:each) do
    assign(:album, stub_model(Album,
      :title => "MyString",
      :kind => nil
    ).as_new_record)
  end

  it "renders new album form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => albums_path, :method => "post" do
      assert_select "input#album_title", :name => "album[title]"
      assert_select "select#album_kind", :name => "album[kind]"
    end
  end
end
