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
    @contribution = Contribution.new draft_object: HashWithIndifferentAccess.new(album.attributes)
    @contribution.approvable = album
    @contribution.original_date = DateTime.now
    @contribution.event = :create
    @contribution.creator = @contribution.updater = album.updater
  end

  subject { @contribution }

  it_should_behave_like "trackable model" do
    let(:trackable) { @contribution }
  end

  describe "attributes and methods" do

    #attributes
    it { should respond_to(:state) }
    it { should respond_to(:event) }
    it { should respond_to(:draft_object) }
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
    its(:pending?) { should be_true }

    describe 'when using class ctor' do
      it 'should raise when passing a new record' do
        expect { Contribution.for Album.new, {}, true }.to raise_error(ArgumentError)
      end
      it 'should raise when passing an invalid hash' do
        expect { Contribution.for album, {id: 1, updater_id: 1}, true }.to raise_error(ArgumentError)
      end

      context 'to create' do
        before { @contribution = Contribution.for album, album.attributes, true }
        its(:event_create?) { should be_true }
        its(:original_date) { should == album.updated_at }
        its(:creator) { should == album.updater }
        its(:updater) { should == album.updater }
        its(:approvable) { should == album }
      end

      context 'to update' do
        before { @contribution = Contribution.for album, album.attributes, false }
        its(:event_update?) { should be_true }
        its(:original_date) { should == album.updated_at }
        its(:creator) { should == album.updater }
        its(:updater) { should == album.updater }
        its(:approvable) { should == album }
      end
    end
  end

  describe "Validations :" do
    before { @contribution.valid? }
    it { should be_valid }

    describe "when draft_object" do
      describe "is not present" do
        before { @contribution.draft_object = nil }
        it { should_not be_valid }
      end
       describe "is not valid" do
        before { @contribution.draft_object = {id: 1, updater_id: 1} }
        it { should_not be_valid }
      end
    end

    describe 'when original_date is in the future' do
      before { @contribution.original_date = DateTime.now + 2.hours }
      it { should_not be_valid }
    end

    describe "when approvable" do
      describe "is not present" do
        before { @contribution.approvable = nil }
        it { should_not be_valid }
      end

      describe "is not of the same id as the draft object" do
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
      let(:contribution) { Contribution.for album, album.attributes, true }
      it 'approve : should apply contribution and update state' do
        album.should_receive(:apply_contribution)
        album.should_receive(:publish!)
        contribution.can_approve?.should be_true
        contribution.approve.should be_true
        contribution.should be_approved
      end
      it 'refuse : should leave album to unpublished' do
        contribution.refuse.should be_true
        contribution.should be_refused
      end
      describe 'when pending contributions exists' do
        let(:other_contribution)  do
          contribution.save!
          album.title = "Toto"
          Contribution.for album, album.attributes, false
        end
        it 'should do not be approvable' do
          other_contribution.can_approve?.should be_false
        end
      end
    end
    context 'update context :' do
      let(:contribution) do
        album.title = "Toto"
        Contribution.for album, album.attributes, false
      end
      it 'approve : should apply contribution and update state' do
        album.should_receive(:publish!)
        contribution.can_approve?.should be_true
        contribution.approve.should be_true
        contribution.should be_approved
      end
      it 'refuse : should leave album to unpublished' do
        contribution.refuse.should be_true
        contribution.should be_refused
      end
    end
  end

  describe 'Methods :' do
    its(:title) { should == album.title }
    its(:creator_pseudo) { should == album.updater.pseudo }
  end
end
