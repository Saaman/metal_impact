# == Schema Information
#
# Table name: practices
#
#  id         :integer          not null, primary key
#  artist_id  :integer          not null
#  kind_cd    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Practice do

  before do
  	@practice = Practice.new :kind => :band
  	@practice.artist = Artist.new name: "Metallica"
  end

  subject { @practice }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:kind) }
    it { should respond_to(:kind_cd) }
    it { should respond_to(:artist) }
    it { should respond_to(:artist_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }

    #methods
    it { should respond_to(:band?) }
    it { should respond_to(:writer?) }
    it { should respond_to(:musician?) }
    it { should respond_to(:band!) }
    it { should respond_to(:writer!) }
    it { should respond_to(:musician!) }
  end

  describe "Validations" do

    it { should be_valid }
    its(:artist) { should_not be_nil }

    describe "when kind" do
      describe "is not present" do
        before { @practice.kind = nil }
        it { should_not be_valid }
      end
      describe "is unknown" do
      	before { @practice.kind_cd = 145 }
      	it { should_not be_valid }
      end
    end

  end

  describe "when saving" do
  	describe "without an artist" do
  		before { @practice.artist = nil }
      it { should_not be_valid }
  	end
  	describe "a new practice on an existing artist" do
  		let!(:artist) { FactoryGirl.create(:artist) }
  		before do
  			@new_practice = Practice.new :kind => :musician
  			@new_practice.artist = artist
  		end
  		it "should update artist timestamps" do
  			expect { @new_practice.save }.to change {artist.updated_at}
  		end
  	end
  end
end