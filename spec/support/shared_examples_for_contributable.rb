require "rspec/expectations"
require "set"

shared_examples "contributable model" do

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
end