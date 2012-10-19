require 'spec_helper'

describe "artists/_new" do
  let (:artist) { FactoryGirl.build(:artist) }
  before(:each) do
    assign(:artist, artist)
    reset_abilities
  end

  it "renders artist _new partial" do
    stub_template "shared/_error_messages.html.erb" => "<div>shared_error_messages.html.erb</div>"
    render :partial => "artists/new"

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should have_selector "form", :action => artists_path do |form|
      form.should have_selector "input", id: "product_type_targeted", type: "hidden"
      Practice.all.each do |pratice|
        form.should have_selector "input", id: "artist_practice_#{pratice.id}", type: "checkbox"
      end
      form.should have_selector "input", id: "artist_name", type: "text"
      form.should have_selector "select", id: "artist_countries"
      form.should have_selector "textarea", id: "artist_biography"
      form.should have_selector "input", type: "submit"
    end
  end
end
