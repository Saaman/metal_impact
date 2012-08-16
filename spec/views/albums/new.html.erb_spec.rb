require 'spec_helper'

describe "albums/new" do
  before(:each) do
    assign(:album, FactoryGirl.build(:album_with_artists))
  end

  it "renders new album form" do
    stub_template "albums/_form.html.erb" => "<div>albums_form.html.erb</div>"
    render

    rendered.should =~ /albums_form.html.erb/
  end
end
