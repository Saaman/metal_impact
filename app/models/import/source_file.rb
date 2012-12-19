# == Schema Information
#
# Table name: import_source_files
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  source     :string(255)      not null
#  status_cd  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Import::SourceFile < ActiveRecord::Base

	#attributes
  attr_accessible :name, :status, :source
  as_enum :status, {:not_started => 0, :in_progress => 1, :partial => 2, :complete => 3, :has_errors => 4 }, prefix: 'import'

  #validations
  validates_as_enum :status
  validates :name, :status, :source, :presence => true

  #callbacks
  before_validation do |source_file|
    source_file.status ||= :not_started
  end

  before_save do |source_file|
  	#"metal_impact" becomes "Metal Impact"
    source_file.source = source_file.source.titleize
  end
end
