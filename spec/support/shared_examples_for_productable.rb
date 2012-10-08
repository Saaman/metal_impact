require "rspec/expectations"
require "set"

shared_examples "productable model" do

	it_should_behave_like "contributable model" do
    let(:contributable) { productable }
  end

	describe "attributes and methods" do
    #attributes
    it { should respond_to(:title) }
    it { should respond_to(:release_date) }
    it { should respond_to(:artists) }
    it { should respond_to(:artist_ids) }
    it { should respond_to(:cover) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }

  end

  describe "validations" do
  	its(:artists) { should_not be_empty }

	  describe "when title" do
	    describe "is not present" do
	      before { productable.title = " " }
	      it { should_not be_valid }
	    end

	    describe "is too long" do
	      before { productable.title = 'a'*512 }
	      it { should_not be_valid }
	    end
	  end

	  describe "when release_date" do
	    describe "is not present" do
	      before { productable.release_date = nil }
	      it { should_not be_valid }
	    end
	  end

	  describe "when artists" do
	    describe "is empty" do
	      before { productable.artists = [] }
	      it { should_not be_valid }
	      its(:artists) { should be_empty }
	    end

	    describe "has more than one artist" do
	      before { productable.artists << FactoryGirl.create(:artist) }
	      it { should be_valid }
	      its(:artists) { should have(2).items }
	    end

	    describe "when adding an empty/unknown artist" do
	    	it "should raise ArtistAssociationError" do
		      expect { productable.artists << Artist.new }.to raise_error(Exceptions::ArtistAssociationError)
		      expect { productable.artist_ids += [10000] }.to raise_error(ActiveRecord::RecordNotFound)
		    end
	    end
	  end
	end

	describe "Cascading saves" do
		describe "artists" do
			before { productable.save }
			it { should satisfy {|p| p.artists(true).size == 1} }
			it { should satisfy {|p| p.artists(true)[0].persisted?} }
		end
	end

	describe "callbacks before save" do
    before do
      productable.artist_ids << artist.id
      productable.title = "ride the lightning"
      productable.save
    end
    it { should be_valid }
    its(:title) { should == "Ride The Lightning" }
    its(:artist_ids) { should == [artist.id] }
  end

end