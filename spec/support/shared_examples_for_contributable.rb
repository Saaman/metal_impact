require "rspec/expectations"
require "set"

shared_examples "contributable model" do

	describe "attributes and methods" do
    #attributes
    it { should respond_to(:published) }
    it { should respond_to(:approvals) }
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
end