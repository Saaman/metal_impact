require 'spec_helper'

describe ContributionsHelper do
	let(:contributable_obj) { FactoryGirl.create(:album_with_artists) }
  let(:not_contributable_obj) { FactoryGirl.create(:music_label) }
  stub_abilities

  describe "add_contribution" do
    context "(can bypass_validation)" do
      before(:each) { @ability.can :bypass_validation, Album }
      describe "should save the object" do
        expect { add_contribution contributable_obj }.to change(contributable_obj, :updated_dt)
      end
    end
  end
end