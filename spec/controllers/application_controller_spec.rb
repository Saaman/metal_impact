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

  describe "having a referer" do
    before(:each) { request.env["HTTP_REFERER"] = albums_path }
    
    describe "handling AccessDenied exceptions redirects to referer with alert" do
      before { get :index }
      it { should redirect_to albums_path }
      specify { flash[:alert].should_not be_nil }
    end
    describe "handling RecordNotFound exceptions redirects to referer with error" do
      before { get :edit, :id => "anyid" }
      it { should redirect_to albums_path }
      specify { flash[:error].should_not be_nil }
    end
    describe "handling RedirectBackError exceptions redirects to root" do
      before { get :new }
      it { should redirect_to root_path }
    end
  end

  describe "Without a referer" do
    describe "handling AccessDenied exceptions redirects to root with alert" do
      before { get :index }
      it { should redirect_to root_path }
      specify { flash[:alert].should_not be_nil }
    end
    describe "handling RecordNotFound exceptions redirects to root with error" do
      before { get :edit, :id => "anyid" }
      it { should redirect_to root_path }
      specify { flash[:error].should_not be_nil }
    end
  end
end