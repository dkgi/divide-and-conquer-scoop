note
	description: "Like COMPARABLE but usable with SCOOP"
	author: "Dominik Gabi"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CONCURRENT_COMPARABLE

feature is_less alias "<" (other: like Current): BOOLEAN is
		-- Compares two elements
	deferred end


end
