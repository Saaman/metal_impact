# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  remember_token  :string(255)
#  password_digest :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  roles           :string(255)
#

class User < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation, :roles
	has_secure_password
	serialize :roles, ::Array

	validate :roles_should_be_consistent
	validates :name, presence: true, length: { maximum: 50 }
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: valid_email_regex },uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }

	before_save :create_remember_token

	def admin?
		has_role?(:admin)
	end

	def has_role?(role)
		roles.include?(role)
	end

	private
		def roles_should_be_consistent
			self.roles.each do |role|
				errors.add(:roles, "The value '#{role}' is not recognized as a role") unless allowed_roles.include?(role)
				errors.add(:roles, "The role #{role} can't be repeated twice") unless roles.count(role) == 1
			end
		end

		def allowed_roles
			[:admin]
		end

	  def create_remember_token
	    self.remember_token = SecureRandom.urlsafe_base64
	  end
end
