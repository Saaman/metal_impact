# == Schema Information
#
# Table name: contributions
#
#  id              :integer          not null, primary key
#  approvable_type :string(255)      not null
#  approvable_id   :integer          not null
#  event_cd        :integer          not null
#  state           :string(255)      not null
#  object          :text
#  original        :text
#  reason          :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :integer
#  updater_id      :integer
#

require 'spec_helper'

describe Contribution do

  let(:album) { FactoryGirl.create :album_with_artists }
  let(:not_contributable_obj) { FactoryGirl.create(:music_label) }
  let!(:owner) { FactoryGirl.create(:user) }

  before do
    @contribution = Contribution.new object: album, approvable: album
    @contribution.creator = owner
    @contribution.updater = owner
  end

  subject { @contribution }

  it_should_behave_like "trackable model" do
    let(:trackable) { @contribution }
  end

  describe "attributes and methods" do

    #attributes
    it { should respond_to(:state) }
    it { should respond_to(:event) }
    it { should respond_to(:object) }
    it { should respond_to(:original) }
    it { should respond_to(:approvable_type) }
    it { should respond_to(:approvable_id) }
    it { should respond_to(:approvable) }
    it { should respond_to(:reason) }

    #transitions
    it { should respond_to(:pending?) }
    it { should respond_to(:approved?) }
    it { should respond_to(:approve) }
    it { should respond_to(:can_approve?) }
    it { should respond_to(:refused?) }
    it { should respond_to(:refuse) }
    it { should respond_to(:can_refuse?) }

    #methods
    it { should respond_to(:event_create?) }
    it { should respond_to(:event_create!) }
    it { should respond_to(:event_update?) }
    it { should respond_to(:event_update!) }
  end

  describe "Validations :" do
    before(:each) { @contribution.valid? }
    it { should be_valid }

    #calculates data
    its(:event_create?) { should be_true }
    its(:pending?) { should be_true }
    its(:original) { should be_nil }

    describe "when object" do
      describe "is not present" do
        before { @contribution.object = nil }
        it { should_not be_valid }
      end
    end

    describe "when approvable" do
      describe "is not present" do
        before { @contribution.approvable = nil }
        it { should_not be_valid }
      end

      describe "is not of the same class as the object" do
        before { @contribution.approvable = not_contributable_obj }
        it { should_not be_valid }
      end

      describe "is not of the same id as the object" do
        let(:other_album) {FactoryGirl.create :album_with_artists}
        before { @contribution.approvable = other_album }
        it { should_not be_valid }
      end
    end

    describe "when original" do
      describe "and event does not match" do
        before do
          @contribution.event = :update
          @contribution.original = nil
          @contribution.valid?
        end
        it { should_not be_valid }
      end

      describe "is not nil and event does not match" do
        before do
          @contribution.event = :create
          @contribution.original = album
          @contribution.valid?
        end
        it { should_not be_valid }
      end

      describe "is not of the same class as the object" do
        before { @contribution.original = not_contributable_obj }
        it { should_not be_valid }
      end

      describe "is not of the same id as the object" do
        let(:other_album) {FactoryGirl.create :album_with_artists}
        before { @contribution.original = other_album }
        it { should_not be_valid }
      end
    end
  end

  describe "callbacks before save :" do
    describe "on event" do
      describe " when original is nil" do
        before do
          @contribution.event = nil
          @contribution.original = nil
          @contribution.valid?
        end
        it { should be_valid }
        its(:event) { should == :create }
      end
      describe " when original is not nil" do
        before do
          @contribution.event = nil
          @contribution.original = album
          @contribution.valid?
        end
        it { should be_valid }
        its(:event) { should == :update }
      end
    end
  end

  describe "class methods :" do
    describe "new_from" do
      describe "with nil object" do
        it "should raise ContributableError" do
          expect { Contribution.new_from nil }.to raise_error(Exceptions::ContributableError)
        end
      end
      describe "with invalid object" do
        it "should raise ContributableError" do
          expect { Contribution.new_from not_contributable_obj }.to raise_error(Exceptions::ContributableError)
        end
      end
      describe "with valid object" do
        before do
          @contribution = Contribution.new_from album
          @contribution.valid?
        end
        it { should be_valid }
        its(:pending?) { should be_true }
        its(:event_create?) { should be_true }
        its(:original) { should be_nil }
        its(:approvable) { should == album }
        its(:object) { should == album }
      end

      describe "with valid object and original" do
        let(:modified_album) do
          modified_album = album.dup
          modified_album.title = "toto"
          modified_album.id = album.id
          modified_album
        end
        before do
          @contribution = Contribution.new_from modified_album, album
          @contribution.valid?
        end
        it { should be_valid }
        its(:pending?) { should be_true }
        its(:event_update?) { should be_true }
        its(:original) { should == album }
        its(:approvable) { should == album }
        its(:object) { should == modified_album }
      end
    end
  end

  describe 'state machine' do
    it 'should be approvable and refusable' do
      @contribution.can_approve?.should be_true
      @contribution.can_refuse?.should be_true
    end

    context 'creation contribution' do
      let(:unpublished_album) { FactoryGirl.create :album_with_artists, published: false }
      let(:contribution) { Contribution.new_from unpublished_album }
      describe 'approve contribution' do
        before { contribution.approve }
        it 'should set album to published' do
          unpublished_album.reload.should be_published
        end
        it 'should set contribution to approved' do
          contribution.should be_approved
        end
      end
      describe 'refuse contribution' do
        before { contribution.refuse }
        it 'should leave album to unpublished' do
          unpublished_album.reload.should_not be_published
        end
        it 'should set contribution to refused' do
          contribution.should be_refused
        end
      end
    end
    context 'update contribution' do
      let(:published_album) { FactoryGirl.create :album_with_artists, published: true }
      let(:artist) { FactoryGirl.create(:artist) }
      let(:album_changes) { FactoryGirl.build(:album, artists: [artist]) }
      let(:contribution) { Contribution.new_from album_changes, published_album }
      describe 'approve contribution' do
        before { contribution.approve }
        it 'should set album to published and update infos' do
          published_album.reload.should be_published
          published_album.title.should == album_changes.title
          published_album.artist_ids.should == [artist.id]
        end
        it 'should set contribution to approved' do
          contribution.should be_approved
        end
      end
      describe 'refuse contribution' do
        before { contribution.refuse }
        it 'should leave album to published with old data' do
          published_album.reload.should be_published
          published_album.title.should_not == album_changes.title
          published_album.artist_ids.should_not == [artist.id]
        end
        it 'should set contribution to refused' do
          contribution.should be_refused
        end
      end
    end
  end
end
