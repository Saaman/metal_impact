require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      raise CanCan::AccessDenied
    end
    def edit
      raise ActiveRecord::RecordNotFound
    end
    def new
      raise ActionController::RedirectBackError
    end
  end

  subject { response }

  describe "handling AccessDenied exceptions redirects to login modal with alert" do
    before { get :index }
    its_access_is "unauthorized"
  end

  describe "handling RedirectBackError exceptions redirects to root" do
    before { get :new }
    it { should redirect_to root_path }
  end

  describe "handling RecordNotFound exceptions redirects to referer with error" do
    describe "having a referer" do
      before do
        request.env["HTTP_REFERER"] = albums_path
        get :edit, :id => "anyid"
      end
      it { should redirect_to albums_path }
      specify { flash[:error].should_not be_nil }
    end
    describe "Without a referer" do
      before { get :edit, :id => "anyid" }
      it { should redirect_to root_path }
      specify { flash[:error].should_not be_nil }
    end
  end
end