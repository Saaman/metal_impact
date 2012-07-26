# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  encrypted_password     :string(255)      not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_cd                :integer          default(0), not null
#  pseudo                 :string(127)      default(""), not null
#  date_of_birth          :date
#  gender_cd              :integer
#

class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :validatable, :encryptable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :lockable, :timeoutable,:confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :email_confirmation, :password, :pseudo, :date_of_birth, :gender, :remember_me, :role

	as_enum :gender, [:male, :female]
	as_enum :role, admin: 1, basic: 0

  after_initialize :default_values

  VALID_PASSWORD_PATTERN = '^(?=^.{7,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[a-z]).*$'
	VALID_EMAIL_PATTERN = '\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}\b'

	validates :email, presence: true, format: { with: /#{VALID_EMAIL_PATTERN}/ }, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
	validates :email, custom_confirmation: true, on: :create
	validates :email_confirmation, presence: true, on: :create
	validates :password, length: { :in => 7..127 }, format: { with: /#{VALID_PASSWORD_PATTERN}/ }, on: :create
	validates :pseudo, presence: true, length: { :in => 4..127 }
	validates :date_of_birth, :timeliness => { :before => :today, :type => :date }, :allow_blank => true
	validates_as_enum :gender, allow_blank: true
	validates_as_enum :role

	def update_without_password(params={})
	  params.delete(:email)
	  super(params)
	end

	private
    def default_values
      self.role ||= :basic
    end
end
