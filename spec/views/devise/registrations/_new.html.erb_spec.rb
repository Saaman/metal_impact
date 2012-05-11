require 'spec_helper'

describe "devise/registrations/new" do
  
  it "renders registration form" do
    user = stub_model(User).as_new_record
    @view.stub(:resource => user, :resource_name => "user", :registration_path => user_registration_path)
    stub_template "devise/registrations/_links.html.erb" => "<div>links</div>"
    render :partial => "devise/registrations/new"

    assert_select "form", :action => user_registration_path, :method => "post" do
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_password", :name => "user[password]"
      assert_select "input#user_password_confirmation", :name => "user[password_confirmation]"
    end
  end
end
