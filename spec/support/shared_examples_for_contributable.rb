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

  describe 'Default behaviors' do
    its(:published) { should be_false }
  end

	describe "when saving" do
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

  describe "contribute" do
    describe "a new object" do
      describe "without bypassing approval" do
        before { contributable.contribute }
        it "should save contributable as unpublished" do
          contributable.should be_persisted
          contributable.should_not be_published
        end
        it "should create a contribution" do
          contributable.contributions(true).size.should == 1
        end
      end
      describe "with bypassing approval" do
        before { contributable.contribute(true) }
        it "should save contributable as published" do
          contributable.should be_persisted
          contributable.should be_published
        end
        it "should create a contribution" do
          contributable.contributions(true).size.should == 1
        end
      end
    end
    describe "an existing object" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        contributable.published = true
        contributable.save
        contributable.updater = user
      end
      describe "without bypassing approval" do
        before { contributable.contribute }
        it "should save contributable as unpublished" do
          contributable.should be_persisted
          contributable.should be_published
          contributable.reload.updater.should_not == user
        end
        it "should create a contribution" do
          contributable.contributions(true).size.should == 1
        end
      end
      describe "with bypassing approval" do
        before { contributable.contribute(true) }
        it "should save contributable as published" do
          contributable.should be_persisted
          contributable.should be_published
          contributable.reload.updater.should == user
        end
        it "should create a contribution" do
          contributable.contributions(true).size.should == 1
        end
      end
    end
	end

  describe 'publish!' do
    before do
      contributable.published = false
      contributable.publish!
    end
    it 'should publish contributable' do
      contributable.reload.should be_published
    end
  end
end