note
	description: "{CONVERTER} is the base class that provides import and export functions for the parametric arguments."
	author: "Dominik Gabi"
	date: "$Date$"
	revision: "$Revision$"

class
	CONVERTER[I,O]

feature -- Conversion

	import_i(i: separate I): I is
			-- Import i
		do
			Result := i
		end

	export_i(i: separate I): I is
			-- Export i
		do
			Result := i
		end

	import_o(o: separate O): O is
			-- Import o
		do
			Result := o
		end

	export_o(o: separate O): O is
			-- Export o
		do
			Result := o
		end

end
