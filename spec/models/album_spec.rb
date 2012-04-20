# == Schema Information
#
# Table name: albums
#
#  id                 :integer         not null, primary key
#  title              :string(255)
#  release_date       :date
#  album_type         :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#

require 'spec_helper'

describe Album do

  before do
    @album = Album.new(title: "Ride the lightning", release_date:Date.new(1988, 5, 14), album_type: "album")
  end

  subject { @album }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:title) }
    it { should respond_to(:release_date) }
    it { should respond_to(:album_type) }
    it { should respond_to(:music_label) }
    #methods
    #validators
    it { should have_attached_file(:cover) }
    it { should validate_attachment_content_type(:cover).
      allowing('image/png', 'image/jpg').
      rejecting('text/plain', 'text/xml') }
  end
  
  describe "Validations" do

    it { should be_valid }

    describe "when title is not present" do
      before { @album.title = " " }
      it { should_not be_valid }
    end

    describe "when title is already taken" do
      before do
        album_with_same_title = @album.dup
        album_with_same_title.title = @album.title.upcase
        album_with_same_title.save
      end

      it { should_not be_valid }
    end

    describe "when release_date is not present" do
      before { @album.release_date = nil }
      it { should_not be_valid }
    end

    describe "album_type :" do
      describe "when not present" do
        before { @album.album_type = " " }
        it { should_not be_valid }
      end

      describe "when assigning an unknown type" do
        before { @album.album_type = "tata" }
        it { should_not be_valid }
      end
      describe "when assigning a music label" do
        before { @album.music_label = MusicLabel.new }
        its(:music_label) { should_not be_nil }
      end
    end
  end
end
