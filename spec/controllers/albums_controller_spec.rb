require 'spec_helper'

#######################################################################################
shared_examples "albums actions granted for anybody" do
  describe "GET 'index'" do
    before(:all) { 50.times { FactoryGirl.create(:album) } }
    after(:all)  { Album.delete_all }
    let(:first_page)  { Album.paginate(page: 1) }
    let(:second_page) { Album.paginate(page: 2) }
    it "should return the first page of albums" do
      get :index
      should render_template("index")
      albums = assigns(:albums)
      albums.should have(first_page.length).items
      albums.count.should == Album.count
      first_page.each do |item|
        albums.should include(item)
      end
    end
    it "should return the second page of albums" do
      get :index, { :page => 2 }
      should render_template("index")
      albums = assigns(:albums)
      albums.length.should == second_page.length
      albums.count.should == Album.count
      albums.should have(second_page.length).items
      second_page.each do |item|
        albums.should include(item)
      end
    end
  end
end

shared_examples "access denied on restricted actions" do
  describe "GET edit" do
    before { get :edit }
    its_access_is "unauthorized"
  end

  describe "POST create" do
    let(:album_attrs) { FactoryGirl.attributes_for(:album) }
    before { post :create, :album => album_attrs }
    its_access_is "unauthorized"
   end

  describe "PUT update" do
     let!(:album) { FactoryGirl.create(:album) }
     before { put :update, {id: album.id, :album => {'these' => 'params'}} }
     its_access_is "unauthorized"
   end

   describe "DELETE destroy" do
     let!(:album) { FactoryGirl.create(:album) }
     before { delete :destroy, id: album.id }
     its_access_is "unauthorized"
   end
end
#######################################################################################

describe AlbumsController do
  
  subject { response }

  context "anonymous user :" do
    it_should_behave_like "albums actions granted for anybody"
    it_should_behave_like "access denied on restricted actions"
  end

  #######################################################################################

  context "signed-in user :" do
    it_should_behave_like "albums actions granted for anybody" do
      login_user
    end
    it_should_behave_like "access denied on restricted actions" do
      login_user
    end
  end

  ###################################################################################### 

  context "admin user :" do
    it_should_behave_like "albums actions granted for anybody" do
      login_admin
    end

    login_admin

    describe "GET new" do
      it "assigns a new album as @album" do
        get :new
        assigns(:album).should be_a_new(Album)
      end
    end

    describe "GET edit" do
      let(:album) { FactoryGirl.create(:album) }
      it "assigns the requested album as @album" do
        get :edit, {:id => album.to_param}
        assigns(:album).should eq(album)
      end
    end

    describe "POST create" do
      let(:album_attrs) { FactoryGirl.attributes_for(:album) }
      describe "with valid params" do
        it "creates a new Album" do
          expect {
            post :create, {:album => album_attrs}
          }.to change(Album, :count).by(1)
        end

        it "assigns a newly created album as @album" do
          post :create, {:album => album_attrs}
          assigns(:album).should be_a(Album)
          assigns(:album).should be_persisted
        end

        it "redirects to the created album" do
          post :create, {:album => album_attrs}
          response.should redirect_to(Album.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved album as @album" do
          # Trigger the behavior that occurs when invalid params are submitted
          Album.any_instance.stub(:save).and_return(false)
          post :create, {:album => {}}
          assigns(:album).should be_a_new(Album)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Album.any_instance.stub(:save).and_return(false)
          post :create, {:album => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      let(:album_attrs) { FactoryGirl.attributes_for(:album) }
      let(:album) { Album.create! album_attrs }
      describe "with valid params" do
        it "updates the requested album" do
          #album = Album.create! album_attrs
          # Assuming there are no other albums in the database, this
          # specifies that the Album created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Album.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => album.id, :album => {'these' => 'params'}}
        end

        it "assigns the requested album as @album" do
          put :update, {:id => album.id, :album => album_attrs}
          assigns(:album).should eq(album)
        end

        it "redirects to the album" do
          put :update, {:id => album.id, :album => album_attrs}
          response.should redirect_to(album)
        end
      end

      describe "with invalid params" do
        it "assigns the album as @album" do
          # Trigger the behavior that occurs when invalid params are submitted
          Album.any_instance.stub(:save).and_return(false)
          put :update, {:id => album.id, :album => {}}
          assigns(:album).should eq(album)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Album.any_instance.stub(:save).and_return(false)
          put :update, {:id => album.id, :album => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      let!(:album) { FactoryGirl.create(:album) }
      it "destroys the requested album" do
        expect {
          delete :destroy, {:id => album.id}
        }.to change(Album, :count).by(-1)
      end

      it "redirects to the albums list" do
        delete :destroy, {:id => album.id}
        response.should redirect_to(albums_url)
      end
    end
  end
end