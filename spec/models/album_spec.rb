# == Schema Information
#
# Table name: albums
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  release_date :date
#  type         :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
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
    
    #methods
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
    end
  end
end