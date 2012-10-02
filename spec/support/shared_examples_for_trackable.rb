require "rspec/expectations"
require "set"

shared_examples "trackable model" do

	describe "attributes and methods" do
    #attributes
    it { should respond_to(:creator) }
    it { should respond_to(:updater) }
    it { should respond_to(:creator_id) }
    it { should respond_to(:updater_id) }
  end

  describe "when creating" do
		before { trackable.creator = nil }
		it "should rollback if creator is not fullfilled" do
			expect {
				begin
					trackable.save
				rescue Exception
				end
			}.to_not change(trackable.class, :count)
		end
	end

	describe "callbacks" do
		describe "when creating a trackable" do
			before { trackable.creator = nil }
			it "should raise a TrackableException if creator is nil" do
				expect { trackable.save }.to raise_error(Exceptions::TrackableError)
			end
		end
		describe "when updating a trackable" do
			before do
				trackable.save
				trackable.updater = nil
			end
			it "should raise a TrackableException if creator is nil" do
				expect { trackable.save }.to raise_error(Exceptions::TrackableError)
			end
		end
	end
end