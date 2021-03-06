# == Schema Information
#
# Table name: import_failures
#
#  id              :integer          not null, primary key
#  description     :text             not null
#  import_entry_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Import::Failure < ActiveRecord::Base
	#associations
	belongs_to :entry, class_name: 'Import::Entry', foreign_key: 'import_entry_id'
	has_one :source_file, :through => :entry

	#attributes
  attr_accessible :description, :entry

  #validations
	validates_presence_of :import_entry_id, :description
end
