# == Schema Information
#
# Table name: import_source_files
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  source        :string(255)      not null
#  sha1_checksum :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Import::SourceFile < ActiveRecord::Base

	#attributes
  attr_accessible :name, :sha1_checksum, :source

  #validations
  validates :name, :sha1_checksum, :source, :presence => true
  validates :sha1_checksum, :length => { :is => 40 }

  #callbacks
  before_save do |source_file|
  	#"metal_impact" becomes "Metal Impact"
    source_file.source = source_file.source.titleize
  end
end
