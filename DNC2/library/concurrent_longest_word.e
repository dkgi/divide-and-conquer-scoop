note
	description: "Summary description for {CONCURRENT_LONGEST_WORD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONCURRENT_LONGEST_WORD

inherit
	CONCURRENT_NODE[STRING, STRING]

feature -- Implementation

	divide(in: STRING): LIST[STRING] is
			-- Divide the string in two strings
		local
			split: LIST[STRING]
			m, i: INTEGER
			left, right: STRING
		do
			input.prune_all_leading (' ')
			input.prune_all_trailing (' ')

			create {LINKED_LIST[STRING]} Result.make
			split := input.split (' ')

			if split.count = 1 then
				Result.extend (input)
			else
				-- Divide in the middle
				m := split.count // 2

				create left.make_empty
				create right.make_empty

				from
					i := 1
					split.start
				until
					split.after
				loop
					if i <= m then
						left.append (split.item + " ")
					else
						right.append (split.item + " ")
					end
					split.forth
					i := i + 1
				end

				Result.extend (left)
				Result.extend (right)
			end
		end

	conquer(in: STRING): STRING is
			-- Return identity
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

	new: attached separate CONCURRENT_LONGEST_WORD is
			-- Create a new node
		do
			create Result
		end

end
