require 'spec_helper'

describe ContributionsHelper do

  describe "contribute_with" do

    describe "with invalid object" do
      let(:not_contributable_obj) { FactoryGirl.create(:music_label) }
      it "should raise ContributableError" do
        expect { helper.contribute_with not_contributable_obj }.to raise_error(Exceptions::ContributableError)
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
      before { helper.stub(:can?).with(:bypass_approval, an_instance_of(Album)).and_return true }
      it "should reward the contribution and save the object" do
        helper.should_receive(:reward_contribution).with(object).and_return true
        helper.should_receive(:save).with(object).and_return true
        helper.contribute_with(object).should == true
      end
      describe "when something goes wrong" do
        it "should return false" do
          helper.should_receive(:reward_contribution).with(object).and_return false
          helper.should_receive(:save).with(object).and_return true
          helper.contribute_with(object).should == false
        end
        it "should rollback object save" do
          helper.should_receive(:reward_contribution).with(object).and_return false
          expect { helper.contribute_with(object) }.to_not change(Album, :count)
        end
      end
      describe "when saving :" do
        it "should save the object" do
          expect { helper.contribute_with object }.to change(Album, :count).by(1)
        end
        
        it { helper.contribute_with(object).should == true }

        describe "object should be published" do
          before { helper.contribute_with object }
          specify { Album.last.published.should == true }
        end
        describe "unless told otherwise" do
          before do
            object.published = false
            helper.contribute_with object
          end
          specify { Album.last.published.should be_false }
        end
      end
    end



    context "(cannot bypass_approval)" do
      let(:object) { FactoryGirl.build(:album_with_artists) }
      before { helper.stub(:can?).with(:bypass_approval, an_instance_of(Album)).and_return false }
      describe "a new object :" do
        it "should create an approval and save the object" do
          helper.should_receive(:save).with(object).and_return true
          helper.should_receive(:request_approval).with(object).and_return true
          helper.contribute_with(object).should == true
        end
      end
      describe "an existing object :" do
        let(:existing_object) { FactoryGirl.create(:album_with_artists) }
        it "should create an approval and not save the object" do
          helper.should_receive(:request_approval).with(existing_object).and_return true
          helper.stub(:save).and_raise "this test case should not save the object"
          helper.contribute_with(existing_object).should == true
        end
      end
      describe "when something goes wrong" do
        it "should return false" do
          helper.should_receive(:request_approval).with(object).and_return true
          helper.should_receive(:save).with(object).and_return false
          helper.contribute_with(object).should == false
        end
        it "should rollback approval request" do
          helper.should_receive(:save).with(object).and_return false
          expect { helper.contribute_with(object) }.to_not change(Approval, :count)
        end
      end
      describe "when saving a new record" do
        describe " then" do
          it "should save the album" do
            expect { helper.contribute_with(object) }.to change(Album, :count)
          end
        end

        describe "it should be unpublished" do
          before { helper.contribute_with(object) }
          specify { Album.last.title.should == object.title }
          specify { object.published.should == false }
          specify { Album.last.published.should == false }
        end
        describe "even if told otherwise" do
          before do
            object.published = true
            helper.contribute_with object
          end
          specify { object.published.should == false }
          specify { Album.last.published.should == false }
        end
      end
    end
  end
end