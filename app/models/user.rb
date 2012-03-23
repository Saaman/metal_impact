# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer         default(0)
#  locked_at              :datetime
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  roles                  :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles

  serialize :roles, ::Array

	validate :roles_should_be_consistent
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: valid_email_regex },uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }

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
end
