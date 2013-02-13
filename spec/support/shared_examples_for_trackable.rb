require "rspec/expectations"
require "set"

shared_examples "trackable model" do

	describe "attributes and methods" do
    #attributes
    it { should respond_to(:creator) }
    it { should respond_to(:updater) }
    it { should respond_to(:creator_id) }
    it { should respond_to(:updater_id) }
    it { should respond_to(:creator_pseudo) }
    it { should respond_to(:updater_pseudo) }
  end

	describe "validations :" do
		describe "when creating a trackable" do
			before { trackable.creator = nil }
			it "should not be valid if creator is nil" do
				trackable.should_not be_valid
			end
		end
		describe "when updating a trackable" do
			before do
				trackable.save
				trackable.updater = nil
			end
			it "should not be valid if updater is nil" do
				trackable.should_not be_valid
			end
		end
	end

	describe 'Methods :' do
		it 'delegate to creator.pseudo' do
			trackable.creator_pseudo.should == trackable.creator.pseudo
		end
		it 'delegate to updater.pseudo' do
			trackable.updater_pseudo.should == trackable.updater.pseudo
		end
	end
end