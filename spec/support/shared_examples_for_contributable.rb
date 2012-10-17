require "rspec/expectations"
require "set"

shared_examples "contributable model" do

	it_should_behave_like "trackable model" do
    let(:trackable) { contributable }
  end

	describe "attributes and methods" do
    #attributes
    it { should respond_to(:published) }
    it { should respond_to(:approvals) }
    its(:published) { should be_false }
  end

  describe "validations" do

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

end