indexing
	description : "DNC2 application root class"
	date        : "$Date: 2009-08-13 17:21:36 +0200 (Do, 13 Aug 2009) $"
	revision    : "$Revision: 80244 $"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			-- longest_word_example
			closest_points_example
		end

feature {NONE} -- Examples

	longest_word_example is
			-- An example of how to use the CONCURRENT_LONGEST_WORD class
		local
			n: CONCURRENT_LONGEST_WORD
			s: STRING
		do
			s := "This is a sentece with a very long word that has length 7"
			create n
			n.initialize (s)
			n.run

			io.put_string ("The longest word is " + n.output + "%N")
		end

	longest_word_with_agents_example is
			-- An example of how to use the AGENTS_NODE class
			-- This time, instead of the longest word, the length
			-- of the longest word is returned

			-- Unfortunately, uncommenting this method crashes EVE
		local
--			n: AGENTS_NODE[STRING,INTEGER]
--			s: STRING
		do
--			s := "This is a sentece with a very long word that has length 7"
--			create n.make_with_agents (s,
--										agent {STRING}.split (' '),
--										agent {STRING}.count,
--										agent max
--										)
--			n.run
--			io.put_string ("The longest word is ")
--			io.put_integer (n.output)
--			io.put_string (" characters long")
		end

	closest_points_example is
			-- An example of how to use CLOSEST_POINTS
		local
			x, y: REAL
			p: LIST[POINT]
			p1, p2: POINT
			r: TUPLE[POINT,POINT]
			c: INTEGER
			rand: RANDOM
			cp: CONCURRENT_CLOSEST_POINTS
			ms: CONCURRENT_MERGESORT[POINT]
		do
			create {LINKED_LIST[POINT]} p.make
			create rand.set_seed (1034)

			-- Create 100 random points
			from
				c := 1
				rand.start
			until
				c > 100
			loop
				x := rand.real_item * 1
				rand.forth
				y := rand.real_item
				rand.forth
				p.extend (create {POINT}.make (x, y))
				c := c + 1
			end

			-- Sort the points (on the x-axis)
			create ms
			ms.initialize (p)
			ms.run
			p := ms.output

			create cp
			cp.initialize (p)
			cp.run
			r := cp.output

			p1 ?= r[1]
			p2 ?= r[2]

			io.put_string ("The closest points are " + p1.str + " and " + p2.str + "%N")
		end

feature {NONE} -- Implementation

	max(list: LIST[INTEGER]): INTEGER is
			-- Returns the maximum
		do
			Result := {INTEGER_32}.Min_value
			from
				list.start
			until
				list.after
			loop
				if list.item > Result then
					Result := list.item
				end
			end
		end

end
