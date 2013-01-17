module Exceptions
	class ArtistAssociationError < StandardError
	end

	class ContributableError < StandardError
	end

	class TrackableError < StandardError
	end

	#exception raised when the current entry has dependencies to be satisfied first
	class ImportDependencyException < StandardError
	end
end