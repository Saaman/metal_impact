require 'spec_helper'

#######################################################################################
shared_examples "dashboard access is unauthorized" do
  describe "GET 'dashboard'" do
    before { get :dashboard }
    its_access_is "unauthorized"
  end

   describe "POST 'dashboard'" do
     before { post :dashboard, allow_debug: true }
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
      it 'should not allow debug' do
        assigns(:dashboard).allow_debug.should be_false
        response.should render_template('dashboard')
      end
    end
    describe "POST 'dashboard'" do
      before { post :dashboard, allow_debug: true }
      it 'should set debug on' do
        assigns(:dashboard).allow_debug.should be_true
        response.should render_template('dashboard')
      end
    end
    describe "POST 'dashboard'" do
      before { post :dashboard, allow_debug: false }
      it 'should set debug off' do
        assigns(:dashboard).allow_debug.should be_false
        response.should render_template('dashboard')
      end
    end
  end
end