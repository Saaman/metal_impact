# == Schema Information
#
# Table name: music_labels
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  website     :string(255)
#  distributor :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe MusicLabel do
  let!(:owner) { FactoryGirl.create(:user, :role => :admin) }
  before do
    @musicLabel = MusicLabel.new(name: "Relapse Records", website: "http://www.google.com")
    @musicLabel.creator = owner
    @musicLabel.updater = owner
  end

  subject { @musicLabel }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:name) }
    it { should respond_to(:website) }
    it { should respond_to(:distributor) }
    #associations
    it { should respond_to(:albums) }
  end

  describe "Validations" do

    it { should be_valid }

    describe "when name is not present" do
      before { @musicLabel.name = " " }
      it { should_not be_valid }
    end

    describe "when name is already taken" do
      before do
        label_with_same_name = @musicLabel.dup
        label_with_same_name.name = @musicLabel.name.upcase
        label_with_same_name.save
      end
      it { should_not be_valid }
    end

    describe "when website format is invalid" do
      invalid_websites =  %w[tata http:example.fr http://example.fr. http//example http://example]
      invalid_websites.each do |invalid_website|
        before { @musicLabel.website = invalid_website }
        it { should_not be_valid }
      end
    end

    describe "when website format is valid" do
      valid_websites = %w[http://example.fr.com https://fr.example.com http://example.fr]
      valid_websites.each do |valid_website|
        before { @musicLabel.website = valid_website }
        it { should be_valid }
      end
    end

    describe "when website is already taken" do
      before do
        label_with_same_website = @musicLabel.dup
        label_with_same_website.website = @musicLabel.website.upcase
        label_with_same_website.save
      end
      it { should_not be_valid }
    end

    describe "when website is not given" do
      before { @musicLabel.website = "" }
      it { should be_valid }
    end
  end

  describe "callbacks before save" do
    describe "on name" do
      before do
        @musicLabel.name = "relapse records"
        @musicLabel.save
      end
      it { should be_valid }
      its(:name) { should == "Relapse Records" }
    end
  end

  describe "albums association :" do
    describe "when adding an album" do
      before { @musicLabel.albums << Album.new }
      specify { @musicLabel.albums.should_not be_empty }
      specify { @musicLabel.albums.size.should == 1 }
    end
    describe "when saving an album" do
      let!(:album) { FactoryGirl.create(:album_with_artists) }
      let!(:other_album) { FactoryGirl.create(:album_with_artists) }
      before do
        @musicLabel.albums << album
        @musicLabel.albums << other_album
        @musicLabel.save
      end
      specify { @musicLabel.albums(true).should_not be_empty }
      specify { @musicLabel.albums(true).size.should == 2 }
      specify { @musicLabel.album_ids.should == [album.id, other_album.id] }
    end
  end
end
