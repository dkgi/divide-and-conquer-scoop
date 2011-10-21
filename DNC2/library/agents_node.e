note
	description: "Summary description for {DIVIDE_AND_CONQUER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AGENTS_NODE[I,O]

create
	make,
	make_with_agents

feature -- Basic operations

	make(i: I) is
			-- Create new problem instance with input `i'
		do
			input := i
			create children.make
			create outputs.make
		end

	make_with_agents(i: I;
					div: FUNCTION[ANY, TUPLE[I], LIST[I]];
					con: FUNCTION[ANY, TUPLE[I], O];
					com: FUNCTION[ANY, TUPLE[LIST[O]], O]) is
			-- Create new problem with input `i', divide function `d'
			-- and conquer function `c'
		do
			input := i
			divide := div
			conquer := con
			combine := com
			create children.make
			create outputs.make
		ensure
			ready
		end


	run is
			-- Run the algorithm
		require
			ready
		local
			division: LIST[I]
		do
			-- Divide input
			divide.call ([input])
			division ?= divide.last_result

			if division.count = 1 then
				-- Cannot divide problem further
				conquer.call ([division.first])
				output ?= conquer.last_result
			else
				-- Create new children
				division.do_all (agent new_child)

				-- Run children
				children.do_all (agent run_child)

				-- Collect results
				children.do_all (agent collect_result)

				-- Combine
				combine.call ([outputs])
				output ?= combine.last_result
			end

			done := true
		ensure
			done
		end

feature -- Access

	divide: FUNCTION[ANY, TUPLE[I], LIST[I]] assign set_divide
			-- The divide function

	set_divide(d: FUNCTION[ANY, TUPLE[I], LIST[I]]) is
			-- Sets the divide function
		do
			divide := d
		end

	conquer: FUNCTION[ANY, TUPLE[I], O] assign set_conquer
			-- The conquer function

	set_conquer(c: FUNCTION[ANY, TUPLE[I], O]) is
			-- Sets the conquer function
		do
			conquer := c
		end

	combine: FUNCTION[ANY, TUPLE[LIST[O]], O] assign set_combine
			-- The combine function

	set_combine(c: FUNCTION[ANY, TUPLE[LIST[O]], O]) is
			-- Sets the combine function
		do
			combine := c
		end

	input: I
			-- The input

	output: O
			-- The output

feature -- Status

	ready: BOOLEAN is
			-- Is the node ready to start computing?
		do
			Result := divide /= Void and then conquer /= Void and then combine /= Void
		end


	done: BOOLEAN
			-- Is the computation on this node complete?

feature {NONE} -- Implementation

	children: LINKED_LIST[AGENTS_NODE[I,O]]
			-- Child nodes

	outputs: LINKED_LIST[O]
			-- Collected results from children

	new_child (i: I) is
			-- Create a new child node with input `i'
		local
			new: AGENTS_NODE[I,O]
		do
			create new.make_with_agents (i, divide, conquer, combine)
			children.extend (new)
		end

	run_child (child: AGENTS_NODE[I,O]) is
			-- Runs a child
		do
			child.run
		end


	collect_result (child: AGENTS_NODE[I,O]) is
			-- Collects the result from a child
		require
			child.done
		do
			outputs.extend (child.output)
		end

end
