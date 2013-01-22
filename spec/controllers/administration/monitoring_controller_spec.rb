require 'spec_helper'

#######################################################################################
shared_examples "dashboard access is unauthorized" do
  describe "GET 'dashboard'" do
    before { get :dashboard }
    its_access_is "unauthorized"
  end

   describe "POST 'toggle_debug'" do
     before { post :toggle_debug }
     its_access_is "unauthorized"
   end
end
#######################################################################################

describe Administration::MonitoringController do
  before(:each) do
    request.env["HTTP_REFERER"] = root_path
  end

  subject { response }

  context "anonymous user :" do
    it_should_behave_like "dashboard access is unauthorized"
  end

  #######################################################################################

  context "staff user :" do
    it_should_behave_like "dashboard access is unauthorized" do
      login_user :staff
    end
  end

  #######################################################################################
  context "admin user :" do
    after { Rails.cache.clear }
    login_user :admin
    describe "GET 'dashboard'" do
      before { get :dashboard }
      it 'should display monitoring page with debug mode off' do
        assigns(:dashboard).allow_debug.should be_false
        should render_template('dashboard')
      end
    end
    describe "POST 'toggle_debug'" do
      before { post :toggle_debug }
      it 'should toggle debug' do
        @controller.should be_can_debug
        should redirect_to(dashboard_path)
      end
    end
  end
end