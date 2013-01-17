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
		begin
			return self.errors.add(:data, :is_not_a_hash) unless self.data.is_a? Hash
			self.source_id = self.data[:id]
			self.target_model = self.data[:model].to_sym if self.data.has_key?(:model)
			save()
		rescue Exception => ex
      self.errors.add(:base, ex.message)
    end
	end

	def import_as_user
		user = User.new(email: data[:email], email_confirmation: data[:email],
										password: data[:password], pseudo: data[:pseudo], role: data[:role])
	  user.skip_confirmation!
	  user.updated_at = DateTime.parse(data[:updated_at])
	  user.created_at = DateTime.parse(data[:created_at])

	  finalize_import user
	end

	def import_as_artist
		artist = Artist.new(name: data[:name], published: true, countries: data[:countries], practices: [Practice.find_by_kind(:band)])

	  artist.updated_at = DateTime.parse(data[:updated_at])
	  artist.created_at = DateTime.parse(data[:created_at])

		artist.creator_id = artist.updater_id = @dependencies[:reviewer_id]

		finalize_import artist
	end

	protected
		def get_dependencies
			case target_model
				when :user then nil
			else
				self.send "get_dependencies_for_#{target_model}"
			end
		end

	private
		def finalize_import(obj)
			obj.save_without_timestamping
	  	update_entry_target_id obj
		end

		def get_dependencies_for_artist
			result = {}
			{ reviewer_id: retrieve_dependency_id(:user, data[:created_by]) }
		end
end
