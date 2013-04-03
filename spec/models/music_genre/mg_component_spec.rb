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
  end
end

describe MusicGenre::MusicType do
  before do
    @music_type = FactoryGirl.build :music_type
  end

  subject { @music_type }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:keyword) }
    it { should respond_to(:type) }
  end

  its(:type) { should == 'MusicGenre::MusicType' }

  describe "Validations :" do
  	it { should be_valid }

    describe "when keyword is not present" do
      before { @music_type.keyword = " " }
      it { should_not be_valid }
    end
  end
end

describe MusicGenre::MainStyle do
  before do
    @main_style = FactoryGirl.build :main_style
  end

  subject { @main_style }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:keyword) }
    it { should respond_to(:type) }
  end

  its(:type) { should == 'MusicGenre::MainStyle' }

  describe "Validations :" do
  	it { should be_valid }

    describe "when keyword is not present" do
      before { @main_style.keyword = " " }
      it { should_not be_valid }
    end
  end
end

describe MusicGenre::StyleAlteration do
  before do
    @style_alteration = FactoryGirl.build :style_alteration
  end

  subject { @style_alteration }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:keyword) }
    it { should respond_to(:type) }
  end

  its(:type) { should == 'MusicGenre::StyleAlteration' }

  describe "Validations :" do
  	it { should be_valid }

    describe "when keyword is not present" do
      before { @style_alteration.keyword = " " }
      it { should_not be_valid }
    end
  end
end