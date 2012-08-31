require 'spec_helper'

describe AlbumsHelper do
	let(:album) { FactoryGirl.create(:album_with_artists) }

  describe "artists_links_for" do
    context "renders names when less than 3 artists" do
      let(:artists) { FactoryGirl.create_list(:artist, 2) }
      before do
        album.artists = artists
        album.save
      end
      specify { artists_links_for(album).should match(/#{artists[0].name.upcase}/) }
      specify { artists_links_for(album).should match(/#{artists[1].name.upcase}/) }
    end
    context "renders 'Various Artists' when more than 3 artists" do
      let(:artists) { FactoryGirl.create_list(:artist, 4) }
      before do
        album.artists = artists
        album.save
      end
      specify { artists_links_for(album).should == "VARIOUS ARTISTS" }
    end
  end
end