require 'spec_helper'

describe "albums/new" do
  before(:each) do
    assign(:album, FactoryGirl.build(:album_with_artists))
    reset_abilities
  end

  it "renders album form" do
    stub_template "shared/_error_messages.html.erb" => "<div>shared_error_messages.html.erb</div>"
    render :partial => "albums/form"

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should have_selector "form", :action => albums_path do |form|
      form.should have_selector "input", id: "album_artists", type: "hidden"
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
