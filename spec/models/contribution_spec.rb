# == Schema Information
#
# Table name: contributions
#
#  id              :integer          not null, primary key
#  approvable_type :string(255)      not null
#  approvable_id   :integer          not null
#  event_cd        :integer          not null
#  state           :string(255)      not null
#  draft_object    :text             not null
#  reason          :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Contribution do

  let(:album) { FactoryGirl.create :album_with_artists }
  let(:not_contributable_obj) { FactoryGirl.create(:music_label) }
  let(:contributor) { FactoryGirl.create :user }

  before do
    @contribution = Contribution.new draft_object: HashWithIndifferentAccess.new(album.attributes)
    @contribution.approvable = album
    @contribution.event = :create
    @contribution.whodunnit = contributor
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
    it { should respond_to(:approvable_type) }
    it { should respond_to(:approvable_id) }
    it { should respond_to(:approvable) }
    it { should respond_to(:reason) }
    it { should respond_to(:whodunnit) }
    it { should respond_to(:whodunnit_id) }

    #transitions
    it { should respond_to(:pending?) }
    it { should respond_to(:approved?) }
    it { should respond_to(:approve) }
    it { should respond_to(:can_approve?) }
    it { should respond_to(:refused?) }
    it { should respond_to(:refuse) }
    it { should respond_to(:can_refuse?) }

    #methods
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
        expect { Contribution.for Album.new, {}, contributor }.to raise_error(ArgumentError)
      end
      it 'should raise when passing an invalid contributor' do
        expect { Contribution.for Album.new, {}, nil }.to raise_error(ArgumentError)
        expect { Contribution.for Album.new, {}, User.new }.to raise_error(ArgumentError)
      end
      it 'should raise when passing an invalid hash' do
        expect { Contribution.for album, {tata: 1, updater_id: 1}, contributor }.to raise_error(ArgumentError)
      end

      context 'to create' do
        before { @contribution = Contribution.for album, album.attributes, contributor, true }
        its(:event_create?) { should be_true }
        its(:whodunnit) { should == contributor }
        its(:approvable) { should == album }
      end

      context 'to update' do
        before { @contribution = Contribution.for album, album.attributes, contributor }
        its(:event_update?) { should be_true }
        its(:whodunnit) { should == contributor }
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
        before { @contribution.draft_object = {tata: 1, updater_id: 1} }
        it { should_not be_valid }
      end
    end

    describe 'when contributor is not present' do
      before { @contribution.whodunnit = nil }
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
      let(:contribution) { Contribution.for album, album.attributes, contributor, true }
      it 'approve : should update state' do
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
        let(:new_user) { FactoryGirl.create :user }
        let(:other_contribution)  do
          contribution.save!
          album.title = "Toto"
          Contribution.for album, album.attributes, new_user
        end
        it 'should not be approvable' do
          other_contribution.can_approve?.should be_false
        end
      end
    end
    context 'update context :' do
      let(:contribution) do
        album.title = "Toto"
        Contribution.for album, album.attributes, contributor
      end
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
    end
  end

  describe 'Methods :' do
    its(:title) { should == album.title }
  end
end
