# == Schema Information
#
# Table name: import_failures
#
#  id              :integer          not null, primary key
#  description     :text
#  code            :string(255)
#  import_entry_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Import::Failure < ActiveRecord::Base
	#associations
	belongs_to :entry, class_name: 'Import::Entry', foreign_key: 'import_entry_id'

	#attributes
  attr_accessible :code, :description, :entry

  #validations
	validates_presence_of :import_entry_id, :description
end
