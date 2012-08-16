require 'spec_helper'

describe "albums/new" do
  before(:each) do
    assign(:album, FactoryGirl.build(:album_with_artists))
  end

  it "renders new album form" do
    render :partial => "albums/form"

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should have_selector "form", :action => albums_path do |form|
      @album.artists.each do |artist|
        form.should have_selector "input", id: "product_artist_ids_#{artist.id}", :name => "product[artist_ids]"
      end
      form.should have_selector "input", id: "artist_typeahead"
      form.should have_selector "input", id: "cancel_artists_deletions", type: "button"
      form.should have_selector "input", id: "album_title", :name => "album[title]"
      form.should have_selector "input", id: "album_release_date", :name => "album[release_date]"
      form.should have_selector "select", id: "album_kind", :name => "album[kind]"
      form.should have_selector "input", id: "album_cover", :name => "album[cover]", type: "file"
    end
  end
end
