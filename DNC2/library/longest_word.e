note
	description: "Summary description for {LONGEST_WORD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LONGEST_WORD

inherit
	NODE[STRING, STRING]

feature -- Implementation

	divide(in: STRING): LIST[STRING] is
			-- Divide the string into words
		do
			Result := in.split (' ')
		end

	conquer(in: STRING): STRING is
			-- Return string
		do
			Result := in
		end

	combine(in: LIST[STRING]): STRING is
			-- Return the longest string
		do
			in.start
			Result := in.item

			from
				in.start
			until
				in.after
			loop
				if in.item.count > Result.count then
					Result := in.item
				end
				in.forth
			end
		end

	new: LONGEST_WORD is
			-- Create a new node
		do
			create Result
		end

end
