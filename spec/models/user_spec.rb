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
    @user = User.new(email: "user@example.com", email_confirmation: "user@example.com", password: "foobar1", pseudo: "Roro", date_of_birth: 1.month.ago, gender: :male)
  end

  subject { @user }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:email) }
    it { should respond_to(:email_confirmation) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:pseudo) }
    it { should respond_to(:remember_me) }
    it { should respond_to(:date_of_birth) }
    it { should respond_to(:gender) }
    it { should respond_to(:role) }
    it { should respond_to(:male?) }
    it { should respond_to(:female?) }
    it { should respond_to(:male!) }
    it { should respond_to(:female!) }
    specify { User.should respond_to(:genders) }

    #methods
    it { should respond_to(:is?) }
  end
  
  describe "Validations" do

    it { should be_valid }

    describe "when email" do
      describe "is not present" do
        before { @user.email = " " }
        it { should_not be_valid }
      end

      describe "format is invalid" do
        invalid_addresses =  %w[user@foo,com user_at_foo.org example.user@foo.]
        invalid_addresses.each do |invalid_address|
          before { @user.email = @user.email_confirmation = invalid_address }
          it { should_not be_valid }
        end
      end

      describe "format is valid" do
        valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        valid_addresses.each do |valid_address|
          before { @user.email = @user.email_confirmation = valid_address }
          it { should be_valid }
        end
      end

      describe "and confirmation mismatch" do
        before { @user.email_confirmation = "toto" }
        it { should_not be_valid }
      end

      describe "address is already taken" do
        before do
          user_with_same_email = @user.dup
          user_with_same_email.email = user_with_same_email.email_confirmation = @user.email.upcase
          user_with_same_email.save
        end

        it { should_not be_valid }
      end
    end

    describe "when password" do

      describe "is not present" do
        before { @user.password = " " }
        it { should_not be_valid }
      end

      describe "is too short" do
          before { @user.password = "a" * 4 + "1" }
          it { should be_invalid }
      end

      describe "is too long" do
          before { @user.password = "a" * 128 + "1" }
          it { should be_invalid }
      end

      describe "don't have a special char" do
          before { @user.password = "a" * 7 }
          it { should be_invalid }
      end
    end

    describe "when pseudo" do
      describe "is blank" do
        before { @user.pseudo = " " }
        it { should_not be_valid }
      end
      describe "is too short" do
        before { @user.pseudo = "a" * 3 }
        it { should_not be_valid }
      end
      describe "is too long" do
        before { @user.pseudo = "a" * 130 }
        it { should_not be_valid }
      end
    end

    describe "when date of birth" do
      describe "is invalid" do
        before { @user.date_of_birth = "tata" }
        it { should_not be_valid }
      end
      describe "is in the future" do
        before { @user.date_of_birth = Date.today + 1.month }
        it { should_not be_valid }
      end
      describe "is blank" do 
        before { @user.gender = "" }
        it { should be_valid }
      end
    end

    describe "when gender" do
      describe "is invalid" do
        it "Invalid enumeration error" do
          expect { @user.gender = "tata" }.to raise_error(ArgumentError, /Invalid enumeration/)
        end
      end
      describe "is blank" do 
        before { @user.gender = "" }
        it { should be_valid }
      end
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
        before { @user.role = "tata" }
        it { should_not be_valid }
      end

      describe "when asking if is of unknown role" do
        it "raises" do
          expect { @user.is?("tata") }.to raise_error(RuntimeError, /not a valid/)
        end
      end
    end
  end
end