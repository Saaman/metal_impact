require "rspec/expectations"
require "set"

shared_examples "unauthorized" do
	 it { should redirect_to new_user_session_path }
   specify { flash[:alert].should_not be_empty }
 end

shared_examples "protected" do
	it { should redirect_to new_user_session_path }
	specify { flash[:alert].should == requires_registration_string }
end

shared_examples "already signed in" do
 	it { should redirect_to root_path }
  specify { flash[:alert].should  == already_signed_in_string }
  specify { @controller.current_user.should_not be_nil }
end
