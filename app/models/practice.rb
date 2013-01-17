# == Schema Information
#
# Table name: practices
#
#  id      :integer          not null, primary key
#  kind_cd :integer          not null
#

class Practice < ActiveRecord::Base
	#associations
	has_and_belongs_to_many :artists

	#attributes
	attr_accessible :kind
	as_enum :kind, band: 0, writer: 1, musician: 2

	#validations
	validates_as_enum :kind

	def self.find_by_kind(kind_sym)
		return nil if kind_sym.nil?
		raise ArgumentError.new("'Practice.find_by_kind : argument should be a symbol") unless kind_sym.is_a? Symbol
		self.find_by_kind_cd self.kinds(kind_sym)
	end

	def i18n_kind
		Practice.human_enum_name(:kinds, kind)
	end
end
