# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  name       :string(127)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before do
    @user = Artist.new(name: "Metallica", email_confirmation: "user@example.com", password: "foobar1", pseudo: "Roro", date_of_birth: 1.month.ago, gender: :male)
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
    
    specify { User.should respond_to(:genders) }
    specify { User.should respond_to(:roles) }

    #methods
    it { should respond_to(:male?) }
    it { should respond_to(:female?) }
    it { should respond_to(:male!) }
    it { should respond_to(:female!) }
    it { should respond_to(:basic?) }
    it { should respond_to(:admin?) }
    it { should respond_to(:basic!) }
    it { should respond_to(:admin!) }
  end
  
  describe "Validations" do

    it { should be_valid }
