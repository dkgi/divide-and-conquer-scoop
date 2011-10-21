note
	description: "Summary description for {CONCURRENT_CLOSEST_POINTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONCURRENT_CLOSEST_POINTS

inherit
	NODE[LIST[POINT], TUPLE[POINT,POINT]]

feature -- Implementation

	divide(in: LIST[POINT]): LIST[LIST[POINT]] is
			-- Divide the string in two strings
		local
			left, right: LIST[POINT]
			m, i: INTEGER
			p, lp, rp: POINT
			d: REAL
		do
			create {LINKED_LIST[LIST[POINT]]} Result.make

			if in.count < 2 then
				Result.extend (in)
			else
				create {LINKED_LIST[POINT]} left.make
				create {LINKED_LIST[POINT]} right.make

				m := in.count // 2

				from
					in.start
					i := 1
				until
					in.after
				loop
					if i <= m then
						left.extend (in.item)
					else
						right.extend (in.item)
					end
					i := i + 1
					in.forth
				end

				-- Find closest pair that has one point on the left side
				-- and the other one on the right
				d := 123412351234.213	-- Really big number ;)

				from
					left.start
				until
					left.after
				loop
					from
						right.start
					until
						right.after
					loop
						if left.item.squared_distance (right.item) < d then
							lp := left.item
							rp := right.item
						end
						right.forth
					end
					left.forth
				end

				Result.extend (left)
				Result.extend (right)
				cross_pair := [lp, rp]
			end
		end

	conquer(in: LIST[POINT]): TUPLE[POINT,POINT] is
			-- A tuple with a single point
		do
			Result := [in.first, Void]
		end

	combine(in: LIST[TUPLE[POINT,POINT]]): TUPLE[POINT,POINT] is
			-- Returns the tuple with the pair that is the closest
			-- There are 3 possible choices:
			-- 1. The pair we determined during the divide stage.
			-- 2. The pair from the left subproblem
			-- 3. The pair from the right subproblem
		local
			p1, p2: TUPLE[POINT,POINT]
		do
			p1 := in[1]
			p2 := in[2]

			Result := min(p1, p2)
			Result := min(Result, cross_pair)
		end

	new: CONCURRENT_CLOSEST_POINTS is
			-- Create a new node
		do
			create Result
		end

feature {NONE} -- Private Access

	cross_pair: TUPLE[POINT,POINT]
			-- The pair of points that are closest and lie
			-- on different sides of the division

feature {NONE} -- Private Implementation

	min(p1, p2: TUPLE[POINT,POINT]): TUPLE[POINT, POINT] is
			-- Returns the pair that has minimum distance
			-- This considers also the pair containing only one point
			-- from the conquer stage
		local
			p11, p12, p21, p22: POINT
		do
			p11 ?= p1[1]
			p12 ?= p1[2]
			p21 ?= p2[1]
			p22 ?= p2[2]

			if p12 = Void then
				Result := p2
			elseif p22 = Void then
				Result := p1
			else
				if p11.squared_distance (p12) < p21.squared_distance (p22) then
					Result := p1
				else
					Result := p2
				end
			end
		end
		

end
