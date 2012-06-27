require 'spec_helper'

describe "devise/passwords/new" do
  
  it "renders password retrieval form" do
    user = stub_model(User).as_new_record
    @view.stub(:resource => user, :resource_name => "user", :password_path => user_password_path)
    render

    assert_select "form", :action => user_password_path, :method => "post" do
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input[type=submit]", :name => "commit"
    end
  end
end
