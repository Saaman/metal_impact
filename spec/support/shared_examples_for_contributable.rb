require "rspec/expectations"
require "set"

shared_examples "contributable model" do

	it_should_behave_like "trackable model" do
    let(:trackable) { contributable }
  end

	describe "attributes and methods :" do
    #attributes
    it { should respond_to(:published) }
    it { should respond_to(:contributions) }
    it { should respond_to(:contribution_ids) }

    #methods
    it { should respond_to(:publish!) }
    it { should respond_to(:contribute) }
  end

  describe "validations :" do

	  describe "when published" do
	    describe "is not present" do
	      before { contributable.published = " " }
	      it { should_not be_valid }
	    end
	    describe "is false" do
	      before { contributable.published = false }
	      it { should be_valid }
	    end
	  end
	end

  describe 'Default behaviors :' do
    its(:published) { should be_false }
  end

	describe "when saving :" do
		describe "it should set published to false if not present" do
			before { contributable.save }
			its(:published) { should be_false }
		end
		describe "but not override published if a value is given" do
			before do
				contributable.published = true
				contributable.save
			end
			its(:published) { should be_true }
		end
	end

	describe "scopes : " do
    describe "published scope should retrieve only published objects" do
    	before do
    		contributable.published = false
    		contributable.save
    	end
      specify { contributable.class.published.pluck("id").should_not include(contributable.id) }
    end
  end

  describe "contribute :" do
    let(:contributor) { FactoryGirl.create :user }
    describe "a new object" do
      describe "without bypassing approval" do
        it "should save contributable as unpublished" do
          contributable.contribute(contributor).should be_true
          contributable.reload.should be_persisted
          contributable.reload.should_not be_published
        end
        it "should create a contribution" do
          contributable.contribute(contributor).should be_true
          contributable.contributions(true).size.should == 1
          Contribution.first.should be_pending
        end
      end
      describe "with bypassing approval" do
        it "should save contributable as published" do
          contributable.contribute(contributor, true).should be_true
          contributable.reload.should be_persisted
          contributable.reload.should be_published
        end
        it "should create a contribution" do
          contributable.contribute(contributor, true).should be_true
          contributable.contributions(true).size.should == 1
          Contribution.first.should be_approved
        end
      end
      describe 'first without approval, then with' do
        let(:user) { FactoryGirl.create(:user) }
        before do
          contributable.contribute(contributor)
          contributable.published = true
        end
        it "should save contributable as unpublished" do
          contributable.contribute(user, true).should be_true
          contributable.reload.should be_persisted
          contributable.reload.should_not be_published
          contributable.owner.should_not == user
        end
        it "should create two contributions" do
          contributable.contribute(user, true).should be_true
          contributable.contributions(true).size.should == 2
          Contribution.first.should be_pending
          Contribution.last.should be_pending
        end
      end
      describe 'when the same user do 2 contributions' do
        before do
          contributable.contribute(contributor)
          contributable.published = true
        end
        it "should save contributable as unpublished" do
          contributable.contribute(contributor).should be_true
          contributable.reload.should be_persisted
          contributable.reload.should_not be_published
        end
        it "should create one contribution" do
          contributable.contribute(contributor).should be_true
          contributable.contributions(true).size.should == 1
          Contribution.first.should be_pending
        end
      end
    end
    describe "an existing object" do
      before do
        contributable.published = true
        contributable.save
      end
      describe "without bypassing approval" do
        it "should save contributable as unpublished" do
          contributable.contribute(contributor).should be_true
          contributable.reload.should be_persisted
          contributable.reload.should be_published
          contributable.owner.should_not == contributor
        end
        it "should create a contribution" do
          contributable.contribute(contributor).should be_true
          contributable.contributions(true).size.should == 1
          Contribution.first.should be_pending
        end
      end
      describe "with bypassing approval" do
        it "should save contributable as published" do
          contributable.contribute(contributor, true).should be_true
          contributable.reload.should be_persisted
          contributable.reload.should be_published
          contributable.owner.should == contributor
        end
        it "should create a contribution" do
          contributable.contribute(contributor, true).should be_true
          contributable.contributions(true).size.should == 1
          Contribution.first.should be_approved
          contributable.updated_at.to_s.should == Contribution.first.created_at.to_s
          #WARNING : this test is more likely failing, but needs to be instrumented correctly to make the dates difference to appear
          true.should be_false
        end
      end
    end
	end

  describe 'publish! :' do
    before do
      contributable.published = false
      contributable.publish!
    end
    it 'should publish contributable' do
      contributable.reload.should be_published
    end
  end
end