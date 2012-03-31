require "rspec/expectations"
require "set"

shared_examples "unauthorized" do
	 it { should redirect_to root_path }
   specify { flash[:alert].should include(not_authorized_string) }
 end