# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Create test users
User.roles.each do |symbol, value|
	pseudo = "Test_#{symbol.to_s.camelize}"

	if (existing_user = User.find_by_pseudo pseudo)
		puts "deleting user #{pseudo}..."
		existing_user.destroy
	end

	user = User.new(	email: "#{symbol}@metal-impact.com",
										email_confirmation: "#{symbol}@metal-impact.com",
										password: "#{symbol}#{value}MI",
										pseudo: pseudo,
										role: symbol)

  user.skip_confirmation!
  user.save!
end

puts "#{User.roles.length} test users have been created."