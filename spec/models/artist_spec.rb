# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  name       :string(127)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Artist do

  before do
    @artist = Artist.new name: "Metallica"
    @artist.practices.build :kind => :band
  end

  subject { @artist }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:name) }
    it { should respond_to(:albums) }
    it { should_not respond_to(:products) }
    it { should respond_to(:practices) }
    it { should respond_to(:album_ids) }
    it { should_not respond_to(:product_ids) }
    it { should respond_to(:practice_ids) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }

    #methods
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

      describe "has an invalid practice" do
        before { @artist.practices << Practice.new }
        it { should_not be_valid }
      end
    end
  end

  describe "cascading saves" do
    describe "on practices" do
      describe "when practices are valid" do
        before { @artist.save }
        its(:practices) { should have(1).items}
        specify { Practice.find_by_artist_id(@artist.id).nil?.should be_false }
      end
      describe "when practices are not valid" do
        before do
          @artist.practices << Practice.new
          @artist.save
        end
        it { should satisfy {|a| a.persisted? == false} }
        it { should satisfy {|a| a.practices[0].persisted? == false} }
        it { should satisfy {|a| a.practices[1].persisted? == false} }
      end
    end
  end

  describe "cascading deletes" do
    describe "on artist" do
      before do
        @artist.save!
        @artist_id = @artist.id
        @artist.destroy
      end
      it { should satisfy {|a| a.persisted? == false} }
      specify { Practice.find_by_artist_id(@artist_id).nil?.should be_true }
    end
    describe "on practices" do
      before do
        new_practice = @artist.practices.build :kind => :musician
        @artist.save!
        @artist.attributes = { :practices_attributes => [{:id => new_practice.reload.id, _destroy: '1'}] }
        @artist.save!
      end
      it { should satisfy {|a| a.persisted? == true} }
      specify { Practice.where(artist_id: @artist.id).should have(1).items }
    end
  end
end