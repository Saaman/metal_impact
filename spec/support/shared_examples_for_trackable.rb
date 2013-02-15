require "rspec/expectations"
require "set"

shared_examples "trackable model" do

	describe "attributes and methods" do
    #attributes
    it { should respond_to(:activities) }
  end
end