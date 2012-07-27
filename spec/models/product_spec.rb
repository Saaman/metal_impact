# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  title              :string(511)      not null
#  type               :string(7)        not null
#  release_date       :date             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#

require 'spec_helper'

describe Product do

	describe "base class" do
		let!(:artist) { FactoryGirl.create(:artist) }
	  before do
	    @product = Product.new title: "Ride The Lightning", release_date: 1.month.ago
	    @product.artists << artist
	  end

	  subject { @product }

	  describe "attributes and methods" do
	    #attributes
	    it { should respond_to(:title) }
	    it { should respond_to(:release_date) }
	    it { should respond_to(:artists) }
	    it { should respond_to(:artist_ids) }
	    it { should respond_to(:type) }
	    it { should respond_to(:cover) }
	    it { should respond_to(:cover_file_name) }
	    it { should respond_to(:cover_content_type) }
	    it { should respond_to(:cover_file_size) }
	    it { should respond_to(:cover_updated_at) }
	    it { should respond_to(:created_at) }
	    it { should respond_to(:updated_at) }

	    describe "Validations" do
	    	it { should_not be_valid }
	    end
	  end
	end

	describe "Child class" do
		let!(:artist) { FactoryGirl.create(:artist) }
	  before do
	    @product = Album.new title: "Ride The Lightning", release_date: 1.month.ago
	    @product.artists << artist
	  end

	  subject { @product }
	  
	  describe "Validations" do

	  	it { should be_valid }
	    its(:artists) { should_not be_empty }

	    describe "when title" do
	      describe "is not present" do
	        before { @product.title = " " }
	        it { should_not be_valid }
	      end

	      describe "is too long" do
	        before { @product.title = 'a'*512 }
	        it { should_not be_valid }
	      end
	    end

	    describe "when release_date" do
	      describe "is not present" do
	        before { @product.release_date = nil }
	        it { should_not be_valid }
	      end
	    end

	    describe "when artists" do
	      describe "is empty" do
	        before { @product.artists = [] }
	        it { should_not be_valid }
	        its(:artists) { should be_empty }
	      end

	      describe "has more than one artist" do
	        before { @product.artists << FactoryGirl.create(:artist) }
	        it { should be_valid }
	        its(:artists) { should have(2).items }
	      end

	      describe "has an invalid artist" do
	        before { @product.artists << Artist.new }
	        it { should_not be_valid }
	      end
	    end
	  end

	  describe "Cascading saves" do
	  	describe "artists" do
	  		before { @product.save }
	  		it { should satisfy {|p| p.artists(true).size == 1} }
	  		it { should satisfy {|p| p.artists(true)[0].persisted?} }
	  	end
	  end
  end
end