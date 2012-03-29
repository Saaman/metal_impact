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
#  role                   :string(255)
#

class User < ActiveRecord::Base
	#roles list
	ROLES = [:admin]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable,:confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles

	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: valid_email_regex },uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }, allow_blank: true
	validates :role, :inclusion => { :in => ROLES}, :allow_blank => true

	def is?(role)
		self.role == role
	end
end
