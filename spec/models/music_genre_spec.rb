require 'spec_helper'

describe MusicGenre do
  before do
    @music_genre = FactoryGirl.build :music_genre
  end

  subject { @music_genre }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:name) }
    it { should respond_to(:computed_name) }
    it { should respond_to(:music_types) }
    it { should respond_to(:music_type_ids) }
    it { should respond_to(:main_styles) }
    it { should respond_to(:main_style_ids) }
    it { should respond_to(:style_alterations) }
    it { should respond_to(:style_alteration_ids) }
  end

  describe "Validations :" do
  	before { @music_genre.valid? }
  	it { should be_valid }

    describe "when name is not present" do
      before { @music_genre.name = " " }
      it { should_not be_valid }
    end

    describe 'when music_types : ' do
    	describe 'is nil' do
	    	before { @music_genre.music_types = nil }
	    	it { should_not be_valid }
	    end
	    describe 'is empty' do
	    	before { @music_genre.music_types = [] }
	    	it { should_not be_valid }
	    end
	    describe 'contains more than 2 music types' do
	    	before { @music_genre.music_types = FactoryGirl.create_list(:music_type, 3) }
	    	it { should_not be_valid }
	    end
	  end
	  describe 'when main_styles : ' do
	    describe 'contains more than 2 music types' do
	    	before { @music_genre.main_styles = FactoryGirl.create_list(:main_style, 3) }
	    	it { should_not be_valid }
	    end
	  end
	  describe 'when style_alterations : ' do
	    describe 'contains more than 2 music types' do
	    	before { @music_genre.style_alterations = FactoryGirl.create_list(:style_alteration, 3) }
	    	it { should_not be_valid }
	    end
	  end
  end

  describe 'Behaviors :' do
  	describe 'should be saved correctly' do
  		specify { @music_genre.save.should == true }
  	end

  	describe 'computed_name ' do
  		let(:music_types) { FactoryGirl.create_list(:music_type, 2) }
  		let(:main_styles) { FactoryGirl.create_list(:main_style, 2) }
  		let(:style_alterations) { FactoryGirl.create_list(:style_alteration, 2) }
  		before do
  			@music_genre.music_types = music_types
  			@music_genre.main_styles = main_styles
  			@music_genre.style_alterations = style_alterations
  		end
  		it 'should be calculated before validation' do
  			@music_genre.should be_valid
  			part_one = main_styles.sort{|x, y| x.id <=> y.id}.collect{|x| x.keyword}.join('/')
  			part_two = music_types.sort{|x, y| x.id <=> y.id}.collect{|x| x.keyword}.join('/')
  			part_three = style_alterations.sort{|x, y| x.id <=> y.id}.collect{|x| x.keyword}.join('/')
  			@music_genre.computed_name.should == "#{part_one} #{part_two} #{part_three}"
  		end
  	end
  end
end