note
	description: "Summary description for {CONCURRENT_MERGESORT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONCURRENT_MERGESORT[T -> CONCURRENT_COMPARABLE]

inherit
	CONCURRENT_NODE[LIST[T], LIST[T]]

feature -- Implementation

	divide(in: LIST[T]): LIST[LIST[T]] is
			-- Divide the list into two parts, one containing all items
			-- smaller than the pivot, on containing all items larger
			-- than the pivot
		local
			left, right: LIST[T]
			pivot: T
		do
			create {LINKED_LIST[LIST[T]]} Result.make
			create {LINKED_LIST[T]} left.make
			create {LINKED_LIST[T]} right.make

			if in.count < 2 then
				Result.extend (in)
			else
				pivot := in.first

				from
					in.start
				until
					in.after
				loop
					if in.item /= pivot then
						if in.item < pivot then
							left.extend (in.item)
						else
							right.extend (in.item)
						end
					end
					in.forth
				end

				-- Put the pivot where there are less elements
				if left.count < right.count then
					left.extend (pivot)
				else
					right.extend (pivot)
				end

				Result.extend (left)
				Result.extend (right)
			end
		end

	conquer(in: LIST[T]): LIST[T] is
			-- Return identity
		do
			Result := in
		end

	combine(in: LIST[LIST[T]]): LIST[T] is
			-- Merge the two lists into a sorted list
		local
			l, r, i: INTEGER
			left, right: LIST[T];
		do
			create {LINKED_LIST[T]} Result.make
			in.start
			left := in.item
			in.forth
			right := in.item

			from
				i := 1	-- Result index
				l := 1	-- Left index
				r := 1 	-- Right index
			until
				i > left.count + right.count or i > left.count or r > right.count
			loop
				if left[l] < right[r] then
					Result.extend(left[l])
					l := l + 1
				else
					Result.extend(right[r])
					r := r + 1
				end
				i := i + 1
			end

			-- Finish up
			from
			until
				l > left.count
			loop
				Result.extend (left[l])
				l := l + 1
			end

			from
			until
				r > right.count
			loop
				Result.extend (right[r])
				r := r + 1
			end
		end

	new: attached separate CONCURRENT_MERGESORT[T] is
			-- Create a new node
		do
			create Result
		end
end
