require 'spec_helper'

describe Users::AdministrationController do
  subject { response }

  context "anonymous user :" do
    describe "GET 'index'" do
      before { get :index }
      its_access_is "unauthorized"
    end

    describe "GET 'filter'" do
      before { get 'filter' }
       its_access_is "unauthorized"
    end
  end

  #######################################################################################

  context "signed-in user :" do
    login_user
    describe "GET 'index'" do
      before { get :index }
      its_access_is "unauthorized"
    end

    describe "GET 'filter'" do
      before { get 'filter' }
       its_access_is "unauthorized"
    end
  end

  #######################################################################################

  
end