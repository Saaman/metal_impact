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
			save!
		rescue ArgumentError => ex
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

		artist.activity owner: User.find(dependencies[:reviewer_id])

		finalize_import artist
	end

	def import_as_music_label
		music_label = MusicLabel.new name: data[:name], distributor: data[:distributor]

	  music_label.updated_at = DateTime.parse(data[:updated_at])
	  music_label.created_at = DateTime.parse(data[:created_at])

		finalize_import music_label
	end

	def import_as_album
		album = Album.new title: data[:title], published: true, kind: data[:album_type]

	  album.updated_at = DateTime.parse(data[:updated_at])
	  album.created_at = DateTime.parse(data[:created_at])
	  album.release_date = DateTime.parse(data[:release_date])
	  album.remote_cover_url = data[:cover]

		album.activity owner: User.find(dependencies[:reviewer_id])
		album.music_label_id = dependencies[:music_label_id]
		album.artist_ids = dependencies[:artist_ids]

		#TODO : add music genre on album
		album.music_genre = add_music_genre data[:music_genre], data[:music_genre_music_types], data[:music_genre_main_styles], data[:music_genre_style_alterations]

		finalize_import album
	end

	protected
		def get_dependencies
			case target_model
				when :user then nil
				when :music_label then nil
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
			{ reviewer_id: retrieve_dependency_id(:user, data[:created_by]) }
		end
		def get_dependencies_for_album
			res = { reviewer_id: retrieve_dependency_id(:user, data[:created_by]) }
			res.merge!({ music_label_id: retrieve_dependency_id(:music_label, data[:music_label_id]) })
			artist_ids = []
			data[:artist_ids].each do |artist_id|
				artist_ids << retrieve_dependency_id(:artist, artist_id)
			end
			res.merge!({ artist_ids: artist_ids })
		end

		def add_music_genre(music_genre_name, music_types, main_styles, style_alterations)

			#build new music genre
			music_genre = MusicGenre.new

			music_genre.music_types = MusicGenre::MusicType.from_keywords music_types
			music_genre.main_styles = MusicGenre::MainStyle.from_keywords main_styles
			music_genre.style_alterations = MusicGenre::StyleAlteration.from_keywords style_alterations

			music_genre.name = music_genre_name

			#if genre already exists, return it
			existing_music_genre = MusicGenre.find_by_computed_name(music_genre.computed_name)
			return existing_music_genre unless existing_music_genre.nil?

			#return the newly created genre
			if music_genre.valid?
				 return music_genre if music_genre.save
			end

			return nil

		end
end
