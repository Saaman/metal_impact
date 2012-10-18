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
  	@practice = Practice.find_by_kind_cd 0
  end

  subject { @practice }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:kind) }
    it { should respond_to(:kind_cd) }
    it { should respond_to(:artists) }
    it { should respond_to(:artist_ids) }
    
    #methods
    it { should respond_to(:band?) }
    it { should respond_to(:writer?) }
    it { should respond_to(:musician?) }
    it { should respond_to(:band!) }
    it { should respond_to(:writer!) }
    it { should respond_to(:musician!) }
  end

  describe "Default values" do
    specify { Practice.find_by_kind_cd(0).should_not be_nil }
    specify { Practice.find_by_kind_cd(1).should_not be_nil }
    specify { Practice.find_by_kind_cd(2).should_not be_nil }
  end

  describe "Validations" do

    it { should be_valid }

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

  describe "practices kinds are unique" do
    let(:practice) { Practice.new :kind => :band }
    it "should raise exception if we break this rule" do
      expect { practice.save }.to raise_error
    end
  end

  describe "find_by_kind method" do
    describe "should return nil if parameter is nil" do
      specify { Practice.find_by_kind(nil).should be_nil }
    end
    it "should raise exception if parameter is not a symbol" do
      expect { Practice.find_by_kind("tata") }.to raise_error
    end
    describe "should return the practice corresponding to the kind symbol" do
      let(:practice) { Practice.find_by_kind(:band) }
      specify { practice.should_not be_nil }
      specify { practice.kind.should == :band }
    end
  end
end