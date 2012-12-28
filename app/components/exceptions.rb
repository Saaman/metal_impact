module Exceptions
	class ArtistAssociationError < StandardError
	end

	class ContributableError < StandardError
	end

	class TrackableError < StandardError
	end

	class ImportException < StandardError
	end
end