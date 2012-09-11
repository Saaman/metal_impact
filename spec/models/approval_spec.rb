require 'spec_helper'

describe Approval do

  let(:album) {FactoryGirl.create :album_with_artists}
  let(:not_contributable_obj) { FactoryGirl.create(:music_label) }

  before do
    @approval = Approval.new object: album, approvable: album
  end

  subject { @approval }

  describe "attributes and methods" do
    
    #attributes
    it { should respond_to(:state) }
    it { should respond_to(:event) }
    it { should respond_to(:object) }
    it { should respond_to(:original) }
    it { should respond_to(:approvable_type) }
    it { should respond_to(:approvable_id) }
    it { should respond_to(:reason) }
    
    #methods
    it { should respond_to(:pending?) }
    it { should respond_to(:pending!) }
    it { should respond_to(:fail?) }
    it { should respond_to(:fail!) }
    it { should respond_to(:approved?) }
    it { should respond_to(:approved!) }
    it { should respond_to(:refused?) }
    it { should respond_to(:refused!) }

    it { should respond_to(:event_create?) }
    it { should respond_to(:event_create!) }
    it { should respond_to(:event_update?) }
    it { should respond_to(:event_update!) }
  end
  
  describe "Validations" do
    before(:each) { @approval.valid? }
    it { should be_valid }

    #calculates data
    its(:event_create?) { should be_true }
    its(:pending?) { should be_true }
    its(:original) { should be_nil }

    describe "when object" do
      describe "is not present" do
        before { @approval.object = nil }
        it { should_not be_valid }
      end
    end

    describe "when approvable" do
      describe "is not present" do
        before { @approval.approvable = nil }
        it { should_not be_valid }
      end

      describe "is not of the same class as the object" do
        before { @approval.approvable = not_contributable_obj }
        it { should_not be_valid }
      end

      describe "is not of the same id as the object" do
        let(:other_album) {FactoryGirl.create :album_with_artists}
        before { @approval.approvable = other_album }
        it { should_not be_valid }
      end
    end

    describe "when original" do
      describe "and event does not match" do
        before { @approval.event = :update }
        it { should_not be_valid }
      end

      describe "is not nil and event does not match" do
        before do
          @approval.event = :create
          @approval.original = album
        end
        it { should_not be_valid }
      end

      describe "is not of the same class as the object" do
        before { @approval.original = not_contributable_obj }
        it { should_not be_valid }
      end

      describe "is not of the same id as the object" do
        let(:other_album) {FactoryGirl.create :album_with_artists}
        before { @approval.original = other_album }
        it { should_not be_valid }
      end
    end
  end

  describe "callbacks before save" do
    describe "on state" do
      before do
        @approval.state = nil
        @approval.valid?
      end
      it { should be_valid }
      its(:state) { should == :pending }
    end
    describe "on event" do
      describe " when original is nil" do
        before do
          @approval.event = nil
          @approval.original = nil
          @approval.valid?
        end
        it { should be_valid }
        its(:event) { should == :create }
      end
      describe " when original is not nil" do
        before do
          @approval.event = nil
          @approval.original = album
          @approval.valid?
        end
        it { should be_valid }
        its(:event) { should == :update }
      end
    end
  end

  describe "class methods" do
    describe "new_for_creation" do
      describe "with nil object" do
        before { @approval = Approval.new_for_creation nil }
        it { should_not be_valid }
      end
      describe "with invalid object" do
        it "should raise HasContributionsError" do
          expect { Approval.new_for_creation not_contributable_obj }.to raise_error(Exceptions::HasContributionsError)
        end
      end
      describe "with valid object" do
        before { @approval = Approval.new_for_creation album }
        it { should be_valid }
        its(:pending?) { should be_true }
        its(:event_create?) { should be_true }
        its(:original) { should be_nil }
        its(:approvable) { should == album }
        its(:object) { should == album }
      end
    end
    describe "new_for_update" do
      describe "with nil object and original" do
        before { @approval = Approval.new_for_update nil, nil }
        it { should_not be_valid }
      end
      describe "with invalid object" do
        it "should raise HasContributionsError" do
          expect { Approval.new_for_update not_contributable_obj, nil }.to raise_error(Exceptions::HasContributionsError)
        end
      end
      describe "with valid object and without original" do
        before { @approval = Approval.new_for_update album, nil }
        it { should_not be_valid }
      end
      describe "with valid object and original" do
        before do
          modified_album = album.dup
          modified_album.title = "toto"
          @approval = Approval.new_for_creation modified_album, album
        end
        it { should be_valid }
        its(:pending?) { should be_true }
        its(:event_update?) { should be_true }
        its(:original) { should == album }
        its(:approvable) { should == album }
        its(:object) { should == modified_album }
      end
    end
  end
end