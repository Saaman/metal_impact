module HelperMacros
  def stub_abilities
    before do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      helper.stub(:current_ability).and_return(@ability)
    end
  end
end