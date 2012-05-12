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
	ROLES = %w[admin basic]
	GENDERS = %w[male female]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :validatable, :encryptable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :lockable, :timeoutable,:confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :email_confirmation, :password, :pseudo, :date_of_birth, :gender, :remember_me, :role

  after_initialize :default_values

	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	valid_password_regex = /\A[\w+\-.]*[^a-zA-Z]+[\w+\-.]*\z/i
	validates :email, presence: true, format: { with: valid_email_regex }, uniqueness: { case_sensitive: false }
	validates :email, confirmation: true, on: :create
	validates :email_confirmation, presence: true, on: :create
	validates :password, length: { :in => 6..128 }, format: { with: valid_password_regex }, on: :create
	
	validates :pseudo, presence: true, length: { :in => 4..128 }
	validates :date_of_birth, :timeliness => { :before => :today, :type => :date }, :allow_blank => true
	validates :gender, allow_blank: true, inclusion: { :in => GENDERS }
	validates :role, :inclusion => { :in => ROLES }

	def is?(role)
		raise "'#{role}' is not a valid role" unless ROLES.include?(role)
		self.role == role
	end

	def update_without_password(params={})
	  params.delete(:email)
	  super(params)
	end

	private
    def default_values
      self.role ||= "basic"
    end
end
