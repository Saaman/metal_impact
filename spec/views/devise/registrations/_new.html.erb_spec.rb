require 'spec_helper'

describe "devise/registrations/new" do
  
  it "renders registration form" do
    user = stub_model(User).as_new_record
    @view.stub(:resource => user, :resource_name => "user", :registration_path => user_registration_path)
    stub_template "devise/registrations/_links.html.erb" => "<div>links</div>"
    render :partial => "devise/registrations/new"

    assert_select "form", :action => user_registration_path, :method => "post" do
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_email_confirmation", :name => "user[email_confirmation]"
      assert_select "input#user_password", :name => "user[password]"
      assert_select "input#user_pseudo", :name => "user[pseudo]"
      assert_select "input#user_gender_male", :name => "user[gender]"
      assert_select "input#user_gender_female", :name => "user[gender]"
      assert_select "select#user_date_of_birth_3i", :name => "user[date_of_birth(3i)]"
      assert_select "select#user_date_of_birth_2i", :name => "user[date_of_birth(2i)]"
      assert_select "select#user_date_of_birth_1i" do
        assert_select "[name=?]", "user[date_of_birth(1i)]"
        #assert years are starting from today -12 years, descending
        assert_select "option" do |elements|
          count = 12
          #logger.warn "elements = #{elements.inspect}"
          elements.drop(1).each do |element|
            logger.warn "element = #{element.inspect}"
            assert_select element, "[value=?]", Time.now.year-count
            count += 1
          end
        end
      end
      assert_select "input[type=submit]", :name => "commit"
    end
  end
end
