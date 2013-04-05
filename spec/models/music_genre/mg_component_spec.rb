require 'spec_helper'


describe MusicGenre::MGComponent do
  before do
    @mg_component = MusicGenre::MGComponent.new keyword: "tata", type: "toto"
  end

  subject { @mg_component }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:keyword) }
    it { should respond_to(:type) }
    it { should respond_to(:music_genres) }
    it { should respond_to(:music_genre_ids) }
  end

  describe "Validations :" do
  	it { should be_valid }

    describe "when keyword is not present" do
      before { @mg_component.keyword = " " }
      it { should_not be_valid }
    end

    describe "when type is not present" do
      before { @mg_component.type = " " }
      it { should_not be_valid }
    end

    describe 'keyword uniqueness' do
      let(:music_type) { FactoryGirl.create :music_type }
      it 'is not required for components of different types' do
        main_style = FactoryGirl.build :main_style, keyword: music_type.keyword
        main_style.should be_valid
      end
      it 'is enforced for components of the same types' do
        dup_music_type = FactoryGirl.build :music_type, keyword: music_type.keyword
        dup_music_type.should_not be_valid
      end
    end
  end

  describe 'Inheritance :' do
    let(:style_alteration) { FactoryGirl.build :style_alteration }
    it 'should have a correct type' do
      style_alteration.type.should == style_alteration.class.name
    end
  end

  describe 'Methods :' do
    describe 'from_keywords' do
      let(:music_type) { FactoryGirl.create :music_type }
      it 'should retrieve existing component if already exists, or create new one' do
        res = MusicGenre::MusicType.from_keywords [music_type.keyword, 'toto']
        res.count.should == 2
        res.first.should == music_type
        res.second.class.should == MusicGenre::MusicType
      end
      it 'should create a new main_style' do
        res = MusicGenre::MainStyle.from_keywords ['toto']
        res.count.should == 1
        res.first.class.should == MusicGenre::MainStyle
        res.first.keyword.should == 'toto'
      end
    end
  end
end