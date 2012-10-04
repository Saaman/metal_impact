def requires_registration_string
	"You need to sign in or sign up before continuing."
end

def already_signed_in_string
	"You are already signed in."
end

def reset_abilities
	@ability = Object.new
  @ability.extend(CanCan::Ability)
  controller.stub(:current_ability).and_return(@ability)
end

def uploaders_fixtures_path
	File.join([Rails.root, 'spec', 'uploaders', 'fixtures'])
end