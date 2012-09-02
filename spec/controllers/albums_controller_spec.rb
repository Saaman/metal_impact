require 'spec_helper'

#######################################################################################
shared_examples "albums actions granted for anybody" do
  describe "GET 'index'" do
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
    let!(:album) { FactoryGirl.create(:album_with_artists) }
    before { get :edit, {id: album.id} }
    its_access_is "unauthorized"
  end

  describe "POST create" do
    let(:album_attrs) { FactoryGirl.attributes_for(:album) }
    before { post :create, :album => album_attrs }
    its_access_is "unauthorized"
   end

  describe "PUT update" do
     let!(:album) { FactoryGirl.create(:album_with_artists) }
     before { put :update, {id: album.id, :album => {'these' => 'params'}} }
     its_access_is "unauthorized"
   end

   describe "DELETE destroy" do
     let!(:album) { FactoryGirl.create(:album_with_artists) }
     before { delete :destroy, id: album.id }
     its_access_is "unauthorized"
   end
end
#######################################################################################

describe AlbumsController do
  before(:all) { 50.times { FactoryGirl.create(:album_with_artists) } }
  after(:all)  { Album.all.each {|a| a.destroy } }
  before(:each) do
    request.env["HTTP_REFERER"] = root_path
  end

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
      let(:album) { FactoryGirl.create(:album_with_artists) }
      it "assigns the requested album as @album" do
        get :edit, {:id => album.to_param}
        assigns(:album).should eq(album)
      end
    end

    describe "POST create" do
      let(:album) { FactoryGirl.build(:album) }
      let(:artist) { FactoryGirl.create(:artist) }
      let!(:album_params) { build_params_for_albums_controller album, [artist.id] }
      describe "with valid params" do
        it "creates a new Album" do
          expect { post :create, album_params }.to change(Album, :count).by(1)
        end

        it "assigns a newly created album as @album" do
          post :create, album_params
          assigns(:album).should be_a(Album)
          assigns(:album).should be_persisted
        end

        it "redirects to the created album" do
          post :create, album_params
          response.should redirect_to(Album.last)
        end
        describe "about music label creation : " do
          let(:new_music_label) { FactoryGirl.build(:music_label) }
          let!(:album_params) { build_params_for_albums_controller album, [artist.id], true, new_music_label }
          it "creates a new MusicLabel with valid parameters" do
            expect {
              post :create, album_params
            }.to change(MusicLabel, :count).by(1)
          end
          describe "if MusicLabel params are invalid" do
            before { album_params[:album][:new_music_label][:music_label][:name] = "" }
            it "does not create MusicLabel" do
              expect {
                post :create, album_params
              }.not_to change(MusicLabel, :count)
            end
            it "does not create Album" do
              expect {
                post :create, album_params
              }.not_to change(Album, :count)
            end
          end
        end
      end

      describe "with invalid params" do
        before { Album.any_instance.stub(:save).and_return(false) }
        it "assigns a newly created but unsaved album as @album" do
          # Trigger the behavior that occurs when invalid params are submitted
          post :create, build_params_for_albums_controller
          assigns(:album).should be_a_new(Album)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Album.any_instance.stub(:save).and_return(false)
          post :create, build_params_for_albums_controller
          response.should render_template("new")
        end
        describe "with music label creation" do
          let(:music_label) { FactoryGirl.build(:music_label) }
          it "does not create a new MusicLabel" do
            expect {
              post :create, build_params_for_albums_controller(Album.new, [], true, music_label)
            }.not_to change(MusicLabel, :count)
          end
        end
      end
    end

    describe "PUT update" do
      let(:album) { FactoryGirl.build(:album) }
      let(:artist) { FactoryGirl.create(:artist) }
      let!(:persisted_album) { FactoryGirl.create(:album_with_artists) }
      describe "with valid params" do
        before do
          Album.any_instance.stub(:save).and_return(true)
          put :update, {id: persisted_album.id}.merge(build_params_for_albums_controller(album, [artist.id]))
        end
        it "redirects to the album" do
          response.should redirect_to(persisted_album)
        end
        it "udaptes the album" do
          assigns(:album)[:title].should == album[:title]
        end
      end

      describe "with invalid params" do
        it "assigns the album as @album" do
          # Trigger the behavior that occurs when invalid params are submitted
          Album.any_instance.stub(:save).and_return(false)
          put :update, {:id => persisted_album.id}.merge(build_params_for_albums_controller)
          assigns(:album)[:id].should == persisted_album.id
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Album.any_instance.stub(:save).and_return(false)
          put :update, {:id => persisted_album.id}.merge(build_params_for_albums_controller)
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      let!(:album) { FactoryGirl.create(:album_with_artists) }
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

  ###################################################################################### 

  describe "new way tests" do
    before(:all) { Artist.all.each {|a| a.destroy } }
    stub_abilities

    describe "GET show :" do
      let(:album) { FactoryGirl.create(:album_with_artists) }
      describe "(unauthorized)" do
        before { get :show, {id: album.id} }
        its_access_is "unauthorized"
      end
      describe "(authorized)" do
        before(:each) { @ability.can :show, Album }
        before { get :show, {id: album.id} }
        it { should render_template("show") }
        specify { assigns(:album).should == album }
      end
      describe "(RecordNotFound exception)" do
        before(:each) { @ability.can :show, Album }
        before { get :show, {id: 10000} }
        it { should redirect_to root_path }
      end
    end
  end

end