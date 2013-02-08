# == Schema Information
#
# Table name: contributions
#
#  id              :integer          not null, primary key
#  approvable_type :string(255)      not null
#  approvable_id   :integer          not null
#  event_cd        :integer          not null
#  state           :string(255)      not null
#  object          :text             not null
#  original_date   :datetime         not null
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

  before do
    @contribution = Contribution.new object: album
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
    it { should respond_to(:original_date) }
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
    it { should respond_to :creator_pseudo }
    it { should respond_to :title }
    it { should respond_to(:event_create?) }
    it { should respond_to(:event_create!) }
    it { should respond_to(:event_update?) }
    it { should respond_to(:event_update!) }
  end

  describe 'Initialization behavior' do
    #calculates data
    its(:event_update?) { should be_true }
    its(:pending?) { should be_true }
    its(:original_date) { should == album.updated_at }
    its(:creator) { should == album.updater }
    its(:updater) { should == album.updater }
    its(:approvable) { should == album }

    describe 'when initializing from a new record' do
      let(:artist) { FactoryGirl.build(:artist) }
      before { @contribution = Contribution.new object: artist }

      its(:event_create?) { should be_true }
      its(:pending?) { should be_true }
      its(:original_date) { should == artist.updated_at }
      its(:creator) { should == artist.updater }
      its(:updater) { should == artist.updater }
      its(:approvable) { should == artist }

      it 'should save the approvable as unpublished' do
        artist.should_not be_new_record
        artist.should_not be_published
      end
    end
  end

  describe "Validations :" do
    before(:each) { @contribution.valid? }
    it { should be_valid }

    describe "when object" do
      describe "is not present" do
        before { @contribution.object = nil }
        it { should_not be_valid }
      end
    end

    describe 'when original_date' do
      before { @contribution.original_date = DateTime.now + 2.hours }
      it { should_not be_valid }
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
  end

  describe 'state machine' do
    it 'should be approvable and refusable' do
      @contribution.can_approve?.should be_true
      @contribution.can_refuse?.should be_true
    end

    context 'creation context :' do
      let(:unpublished_album) { FactoryGirl.create :album_with_artists, published: false }
      let(:contribution) { Contribution.new object: unpublished_album }
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
    context 'update context :' do
      let(:published_album) { FactoryGirl.create :album_with_artists, published: true }
      let(:artist) { FactoryGirl.create(:artist) }
      let(:contribution) do
        published_album.title = "Toto"
        published_album.artists = [artist]
        Contribution.new object: published_album
      end
      describe 'approve contribution' do
        it 'should set album to published and update infos' do
          contribution.can_approve?.should be_true
          contribution.approve.should be_true
          published_album.reload.should be_published
          published_album.title.should == "Toto"
          published_album.artist_ids.should == [artist.id]
        end
        it 'should set contribution to approved' do
          contribution.approve.should be_true
          contribution.should be_approved
        end
      end
      describe 'refuse contribution' do
        it 'should leave album to published with old data' do
          contribution.refuse.should be_true
          published_album.reload.should be_published
          published_album.title.should_not == "Toto"
          published_album.artist_ids.should_not == [artist.id]
        end
        it 'should set contribution to refused' do
          contribution.refuse.should be_true
          contribution.should be_refused
        end
      end
    end
  end

  describe 'Methods :' do
    its(:title) { should == album.title }
  end
end
