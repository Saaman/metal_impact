require "rspec/expectations"
require "set"

shared_examples "productable model" do

	describe "attributes and methods" do
    #attributes
    it { should respond_to(:title) }
    it { should respond_to(:release_date) }
    it { should respond_to(:artists) }
    it { should respond_to(:artist_ids) }
    it { should respond_to(:cover) }
    it { should respond_to(:cover_file_name) }
    it { should respond_to(:cover_content_type) }
    it { should respond_to(:cover_file_size) }
    it { should respond_to(:cover_updated_at) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }

    #validators
    it { should have_attached_file(:cover) }
    it { should validate_attachment_content_type(:cover).
      allowing('image/png', 'image/jpg').
      rejecting('text/plain', 'text/xml') }
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

	    describe "has an invalid artist" do
	      before { productable.artists << Artist.new }
	      it { should_not be_valid }
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

end