# == Schema Information
#
# Table name: albums
#
#  id                 :integer          not null, primary key
#  title              :string(511)      not null
#  release_date       :date             not null
#  kind_cd            :integer          not null
#  published          :boolean          default(FALSE), not null
#  creator_id         :integer
#  updater_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  music_label_id     :integer
#

require 'spec_helper'

describe Album do

	let!(:artist) { FactoryGirl.create(:artist) }
  let!(:owner) { FactoryGirl.create(:user, :role => :admin) }
  before do
    @album = Album.new title: "Ride The Lightning", release_date: 1.month.ago, :kind => :album
    @album.artists << artist
    @album.creator = owner
    @album.updater = owner
  end

	subject { @album }

	it_should_behave_like "productable model" do
		let(:productable) { @album }
    let(:artist) { FactoryGirl.create(:artist) }
	end

	describe "attributes and methods" do
		it { should respond_to(:kind) }
		it { should respond_to(:kind_cd) }

		#associations
    it { should respond_to(:music_label) }
    it { should respond_to(:music_label_id) }

    #methods
    it { should respond_to(:album?) }
    it { should respond_to(:album!) }
    it { should respond_to(:demo?) }
    it { should respond_to(:demo!) }
    it { should respond_to(:mini_album?) }
    it { should respond_to(:mini_album!) }
    it { should respond_to(:live?) }
    it { should respond_to(:live!) }

  end
  describe "Validations" do
		it { should be_valid }

		describe "kind :" do
			describe "is invalid" do
        it "raises invalid enumeration error" do
          expect { @album.kind = "tata" }.to raise_error(ArgumentError, /Invalid enumeration/)
          expect { @album.kind = 45 }.to raise_error(ArgumentError, /Invalid enumeration/)
        end
      end
      describe "is nil" do 
        before { @album.kind = nil }
        it { should_not be_valid }
      end
      describe "is blank" do 
        before { @album.kind = " " }
        it { should_not be_valid }
      end
    end
	end

  describe "when adding artist of the wrong kind" do
      let(:writer) { FactoryGirl.create(:artist, :practice_kind => :writer) }
      it "should raise ArtistAssociationError" do
        expect { @album.artists << writer }.to raise_error(Exceptions::ArtistAssociationError)
        expect { @album.artist_ids += [writer.id] }.to raise_error(Exceptions::ArtistAssociationError)
      end
    end

	describe "music label association" do
    describe "when assigning a music label" do
      before { @album.music_label = MusicLabel.new }
      its(:music_label) { should_not be_nil }
    end
    describe "should save the association" do
      let!(:music_label) { FactoryGirl.create(:music_label) }
      before do
        @album.music_label = music_label
        @album.save
        @album.reload
      end
      its(:music_label) { should_not be_nil }
      its(:music_label_id) { should == music_label.id }
    end
    describe "should save new music label when saving album" do
      let!(:music_label_attr) { FactoryGirl.attributes_for(:music_label, name: "tata") }
      before do
        @album.build_music_label(music_label_attr)
        @album.save
        @album.reload
      end
      its(:music_label_id) { should_not be_blank } 
      it { should satisfy {|a| a.music_label.name.should == music_label_attr[:name].titleize } }
    end
    describe "should not save new album when music label is invalid" do
      let!(:music_label_attr) { FactoryGirl.attributes_for(:music_label, name: "") }
      before do
        @album.build_music_label(music_label_attr)
        @album.save
      end
      it { should_not be_valid }
      it { should satisfy {|a| a.music_label.persisted? == false} }
    end
  end
	  
end
