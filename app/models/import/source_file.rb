# == Schema Information
#
# Table name: import_source_files
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  source_type_cd :integer
#  state          :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Import::SourceFile < ActiveRecord::Base

	#attributes
  attr_accessible :name, :source_type
  as_enum :source_type, {:metal_impact => 0}, prefix: 'is_of_type'

  #validations
  validates_as_enum :source_type, :allow_nil => true
  validates :name, :presence => true

  #state machine
  state_machine :initial => :new do
    before_transition :new => :discovering, :do => :discover_entries

    event :discover_entries do
      transition :new => :discovering, :if => lambda {|source_file| !source_file.source_type.nil?}
    end
  end

  private
    def discover_entries
      puts "I'm discovering!"
    end
end
