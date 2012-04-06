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

require 'spec_helper'

describe User do

  before do
    @user = User.new(email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:email) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:remember_me) }
    it { should respond_to(:role) }

    #methods
    it { should respond_to(:is?) }
  end
  
  describe "Validations" do

    it { should be_valid }

    describe "when email is not present" do
      before { @user.email = " " }
      it { should_not be_valid }
    end

    describe "when email format is invalid" do
      invalid_addresses =  %w[user@foo,com user_at_foo.org example.user@foo.]
      invalid_addresses.each do |invalid_address|
        before { @user.email = invalid_address }
        it { should_not be_valid }
      end
    end

    describe "when email format is valid" do
      valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      valid_addresses.each do |valid_address|
        before { @user.email = valid_address }
        it { should be_valid }
      end
    end

    describe "when email address is already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end

    describe "roles :" do
      describe "default role should be 'basic'" do
        its(:role) {should == "basic"}
      end
      describe "when having a role" do
        before { @user.role = "admin" }
        it { should be_valid }
        specify { @user.is?("admin").should be_true }
      end

      describe "when assigning an unknown role" do
        before { @user.role = :tata }
        it { should_not be_valid }
      end

      describe "when asking if is of unknown role" do
        it "raises" do
          expect { @user.is?("tata") }.to raise_error(RuntimeError, /not a valid/)
        end
      end
    end

    describe "has_role" do
      it "should raises exception when role is unknown" do
        expect { @user.has_role(:toto) }.to raise_error
      end
    end
  end

  describe "password & authentication" do

    describe "when password is not present" do
      before { @user.password = @user.password_confirmation = " " }
      it { should_not be_valid }
    end

    describe "when password doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch" }
      it { should_not be_valid }
    end

    describe "with a password that's too short" do
        before { @user.password = @user.password_confirmation = "a" * 5 }
        it { should be_invalid }
    end
  end
end
