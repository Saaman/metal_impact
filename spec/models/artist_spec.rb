# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  name       :string(127)      not null
#  published  :boolean          default(FALSE), not null
#  creator_id :integer
#  updater_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  countries  :string(127)
#

require 'spec_helper'

describe Artist do

  let!(:owner) { FactoryGirl.create(:user, :role => :admin) }
  before do
    @artist = Artist.new name: "Metallica", :countries => ["FR"]
    @artist.practices = [Practice.find_by_kind(:band)]
    @artist.creator = owner
    @artist.updater = owner
  end

  subject { @artist }

  it_should_behave_like "contributable model" do
    let(:contributable) { @artist }
  end

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:name) }
    it { should respond_to(:albums) }
    it { should_not respond_to(:products) }
    it { should respond_to(:practices) }
    it { should respond_to(:practice_ids) }
    it { should respond_to(:album_ids) }
    it { should respond_to(:biography) }
    it { should respond_to(:translations) }
    it { should_not respond_to(:product_ids) }
    it { should respond_to(:practice_ids) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }

    #methods
    it { should respond_to(:get_countries_string) }
    it { should respond_to(:get_practices_string) }
    it { should respond_to(:is_suitable_for_product_type) }
  end

  describe "Validations" do

    it { should be_valid }
    its(:practices) { should_not be_empty }

    describe "when name" do
      describe "is not present" do
        before { @artist.name = " " }
        it { should_not be_valid }
      end

      describe "is too long" do
        before { @artist.name = 'a'*128 }
        it { should_not be_valid }
      end
    end

    describe "when practices" do
      describe "is empty" do
        before { @artist.practices = [] }
        it { should_not be_valid }
        its(:practices) { should be_empty }
      end

      describe "has more than one practice" do
        before { @artist.practices.build :kind => :musician }
        it { should be_valid }
        its(:practices) { should have(2).items }
      end
    end

    describe "when countries" do
      describe "is empty" do
        before { @artist.countries = nil }
        it { should_not be_valid }
      end
      describe "contains unknown code" do
        before do
          @artist.countries << "XX"
          @artist.valid?
        end
        it { should_not be_valid }
        it { should satisfy {|a| a.errors[:countries].blank? == false} }
        it { should satisfy {|a| a.errors[:countries][0].include?("XX")} }
      end
      describe "contains duplicates" do
        before do
          @artist.countries << "FR"
          @artist.valid?
        end
        it { should be_valid }
        it { should satisfy {|a| a.countries.length == 1} }
      end
      describe "has more than seven values" do
        before { @artist.countries += ["AD", "AE", "AF", "AG", "AW", "AX", "AZ"] }
        it { should_not be_valid }
      end
    end

    describe "when biography" do
      describe "exists" do
        before { @artist.biography = "tatatoto" }
        it { should be_valid }
      end
    end
  end

  describe "callbacks before save" do
    describe "on name" do
      before do
        @artist.name = "CANNIBAL CORPSE"
        @artist.save
      end
      it { should be_valid }
      its(:name) { should == "Cannibal Corpse" }
    end
    describe "on countries" do
      before do
        @artist.countries << "FR" << "fr" << "de" << "GB"
        @artist.save
      end
      it { should be_valid }
      its(:countries) { should == ["FR", "DE", "GB"] }
    end
  end

  describe "cascading saves" do
    describe "on practices" do
      describe "when practices are valid" do
        before { @artist.save }
        its(:practices) { should have(1).items}
        it { should satisfy {|a| a.practices[0].artists = [a] } }
      end
      describe "when practices are not valid, they are forgotten" do
        before do
          @artist.practices << Practice.new
          @artist.save
        end
        it { should satisfy {|a| a.persisted? == true} }
        it { should satisfy {|a| a.practices[0].persisted? == true} }
        it { should satisfy {|a| a.practices[1].persisted? == false} }
      end
      describe "when practices can't be created" do
        let (:artist) { FactoryGirl.create(:artist) }
        it "saving will raise an error" do
          expect { artist.practices = [Practice.new] }.to raise_error
        end
      end
    end

    describe "on biography" do
      describe "should be saved and accessible" do
        before do
          @artist.biography = "tatatoto"
          @artist.save
        end
        it { should satisfy {|a| a.persisted? == true} }
        its(:translations)  { should have(1).items }
      end
      describe "should be saved and rendered even for a different culture" do
        before do
          @artist.biography = "tatatoto"
          @artist.save
          #I18n.locale = 'en'
        end
        it { should satisfy {|a| a.persisted? == true} }
        its(:translations)  { should have(1).items }
        its(:biography) { should == "tatatoto" }
      end
    end
  end


  describe "scopes :" do
    describe "operates_as(:band) should not get writers" do
      let(:writer) { FactoryGirl.create(:artist, :practice_kind => :writer) }
      specify { Artist.operates_as(:band).pluck("artists.id").should_not include(writer.id) }
    end
  end

  describe "helper methods :" do
    describe "get_countries_string" do
      before { @artist.countries << "GB" << "DE" }
      it { should satisfy { |a| a.get_countries_string() == "France / United Kingdom / Germany" } }
    end
    describe "get_practices_string" do
      before { @artist.practices.build(:kind => :writer) }
      it { should satisfy { |a| a.get_practices_string() == "band / writer" } }
    end
    describe "is_suitable_for_product_type" do
      describe "arguments validations" do
        it { should satisfy { |a| a.is_suitable_for_product_type(nil) == true} }
        it "should raise exception in case argument is of invalid type or has invalid value" do
          expect { @artist.is_suitable_for_product_type(45) }.to raise_error(ArgumentError)
          expect { @artist.is_suitable_for_product_type([45, "tata"]) }.to raise_error(ArgumentError)
          expect { @artist.is_suitable_for_product_type(:interviw) }.to raise_error(ArgumentError)
        end
      end
      describe 'band example' do
        let (:band) { FactoryGirl.build(:artist)}
        it { should satisfy { band.is_suitable_for_product_type("album") == true} }
        it { should satisfy { band.is_suitable_for_product_type(:interview) == true} }
      end
      describe 'writer example' do
        let (:writer) { FactoryGirl.create(:artist, :practice_kind => :writer)}
        it { should satisfy { writer.is_suitable_for_product_type(:interview) == true} }
        it { should satisfy { writer.is_suitable_for_product_type(:album) == false} }
        describe "should add a error on the artist" do
          before { writer.is_suitable_for_product_type(:album) }
          it { should satisfy { writer.errors[:practice_ids].size > 0 } }
        end
      end

    end
  end
end
