require 'spec_helper'

describe ContributionsHelper do
	let(:contributable_obj) { FactoryGirl.create(:album_with_artists) }
  let(:not_contributable_obj) { FactoryGirl.create(:music_label) }
  
  subject { helper }

  stub_abilities

  describe "contribute_with" do
    describe "with invalid object" do
      it "should raise HasContributionsError" do
        expect { helper.contribute_with not_contributable_obj }.to raise_error(Exceptions::HasContributionsError)
      end
    end
    describe "with object.valid? is false" do
      let(:invalid_object) { FactoryGirl.build(:album) }
      it "should should return false" do
        helper.contribute_with(invalid_object).should == false
      end
    end
    
    context "(can bypass_approval)" do
      let(:object) { FactoryGirl.build(:album_with_artists) }
      before(:each) { @ability.can :bypass_approval, Album }
      describe "should reward the contribution and save the object" do
        it "when everything went well, got true" do
          object.should be_valid
          helper.can?(:bypass_approval, object).should be_true
          helper.should_receive(:reward_contribution).with(object).and_return true
          helper.should_receive(:save).with(object).and_return true
          helper.contribute_with(object).should == true
        end
        it "when something went wrong, got false" do
          helper.should_receive(:reward_contribution).with(object).and_return false
          helper.should_receive(:save).with(object).and_return true
          helper.contribute_with(object).should == false
        end
      end
      describe "when something goes wrong" do
        it "should return false false" do
          helper.should_receive(:reward_contribution).with(object).and_return false
          helper.should_receive(:save).with(object).and_return true
          helper.contribute_with(object).should == false
        end
        it "should rollback object save" do
          helper.should_receive(:reward_contribution).with(object).and_return false
          expect { helper.contribute_with(object) }.to not_change(Album, :count)
        end
      end
    end
    context "(cannot bypass_approval)" do
      describe "a new object :" do
        let!(:object) { FactoryGirl.build(:album_with_artists) }
        it "should create an approval and save the object" do
          helper.should_receive(:save).with(object).and_return true
          helper.should_receive(:request_approval).with(object).and_return true
          helper.contribute_with(object).should == true
        end
      end
      describe "an existing object :" do
        let!(:object) { FactoryGirl.create(:album_with_artists) }
        it "should create an approval and not save the object" do
          helper.should_receive(:request_approval).with(object).and_return true
          helper.stub(:save).and_raise "this test case should not save the object"
          helper.contribute_with(object).should == true
        end
      end
    end
  end
end