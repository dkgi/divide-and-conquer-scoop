note
	description: "Represents a node in a sequential divide and conquer tree."
	author: "Dominik"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NODE[I,O]

feature -- Subclass interface

	divide(in: I): LIST[I] is
			-- Divide the input
		deferred
		ensure
			Result.count > 0
		end

	conquer(in: I): O is
			-- Conquer subproblem
		deferred end

	combine(ou: LIST[O]): O is
			-- Combine outputs
		deferred end

	new: NODE[I,O] is
			-- Create a new instance
		deferred end

feature -- Algorithm

	run is
			-- Run the algorithm
		require
			ready
		local
			division: LIST[I]
		do
			division := divide(input)

			if division.count = 1 then
				-- We have reached a leaf
				output := conquer (division.first)
			else
				-- Create children
				division.do_all (agent new_child)

				-- Run children
				children.do_all (agent run_child)

				-- Collect results
				children.do_all (agent collect_child)

				-- Combine the results
				output := combine(outputs)
			end

			done := true
		ensure
			done
		end

	initialize(in: I) is
			-- Sets the input to `in'
			-- prepares for execution
		do
			input := in
			create {LINKED_LIST[NODE[I,O]]} children.make
			create {LINKED_LIST[O]} outputs.make
			ready := true
		ensure
			ready
		end

	input: I
			-- The input for the current node

	output: O
			-- The output after the node has been run

feature -- Status

	ready: BOOLEAN
			-- Is the algorithm ready to be run?

	done: BOOLEAN
			-- Has the algorithm completed?

feature {NODE} -- Implementation

	outputs: LIST[O]
			-- The collected results of the children

	new_child(in: I) is
			-- Creates a new child and appends it to `children'
		local
			child: NODE[I,O]
		do
			child := new
			child.initialize (in)
			children.extend (child)
		end

	run_child(child: NODE[I,O]) is
			-- Runs the childs algorithm
		do
			child.run
		end

	collect_child(child: NODE[I,O]) is
			-- Collects the result of a child
		do
			outputs.extend (child.output)
		end


	children: LIST[NODE[I,O]]
			-- A list of children

end
