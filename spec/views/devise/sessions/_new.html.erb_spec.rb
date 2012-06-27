require 'spec_helper'

describe "devise/sessions/new" do
  
  it "renders login form" do
    user = stub_model(User).as_new_record
    @view.stub(:resource => user, :resource_name => "user", :user_session_path => user_session_path, :devise_mapping => Devise.mappings[:user])
    render :partial => "devise/sessions/new"

    assert_select "form", :action => user_session_path, :method => "post" do
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_password", :name => "user[password]"
      assert_select "input[type=submit]", :name => "commit"
    end
  end
end
