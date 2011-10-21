note
	description: "Summary description for {NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CONCURRENT_NODE[I,O]

inherit
	CONVERTER[I,O]

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

	new: attached separate CONCURRENT_NODE[I,O] is
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
				division.start
				output := conquer (division.item)
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
		end

	initialize(in: separate I) is
			-- Sets the input to `in'
			-- prepares for execution
		do
			input := import_i (in)
			create {LINKED_LIST[separate CONCURRENT_NODE[I,O]]} children.make
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

feature {CONCURRENT_NODE} -- Implementation

	outputs: LIST[O]
			-- The collected results of the children

	new_child(in: I) is
			-- Creates a new child and appends it to `children'
		local
			child: attached separate CONCURRENT_NODE[I,O]
		do
			child := new
			initialize_child(child, in)
			children.extend (child)
		end

	initialize_child(child: attached separate CONCURRENT_NODE[I,O]; in: I) is
			-- Calls child.initialize
		do
			child.initialize(in)
		end

	run_child(child: attached separate CONCURRENT_NODE[I,O]) is
			-- Runs the childs algorithm
		do
			child.run
		end

	collect_child(child: attached separate CONCURRENT_NODE[I,O]) is
			-- Collects the result of a child
		do
			outputs.extend (import_o(child.output))
		end


	children: LIST[separate CONCURRENT_NODE[I,O]]
			-- A list of children

end
