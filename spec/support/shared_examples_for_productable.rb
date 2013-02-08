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

	  describe "artists association :" do
	    describe "when empty" do
	    	let(:productable_without_artists) { FactoryGirl.build(:album) }
	    	before { productable_without_artists.valid? }
	      specify { productable_without_artists.should_not be_valid }
	      specify { productable_without_artists.artists.should be_empty }
	      specify { productable_without_artists.errors[:artist_ids].first.should =~ /associate/ }
	    end

	    describe "when has more than one artist" do
	      before { productable.artists << FactoryGirl.create(:artist) }
	      it { should be_valid }
	      its(:artists) { should have(2).items }
	    end

	    describe "when adding an empty artist" do
	    	before { productable.artists << Artist.new }
	    	it { should_not be_valid }
	    end
	    describe "when adding an unknown artist" do
		    it "should raise RecordNotFound" do
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