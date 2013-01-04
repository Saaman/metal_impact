# == Schema Information
#
# Table name: import_entries
#
#  id                    :integer          not null, primary key
#  target_model_cd       :integer
#  source_id             :integer
#  target_id             :integer
#  import_source_file_id :integer
#  data                  :text             not null
#  state                 :string(255)      default("new"), not null
#  type                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Import::MetalImpactEntry < Import::Entry
	def discover
		puts "auto-discovering metal impact item #{self.id}"
		return self.errors.add(:data, :is_not_a_hash) unless self.data.is_a? Hash
		self.source_id = self.data["id"]
		self.target_model = self.data["model"].to_sym if self.data.has_key?("model")
	end
end
