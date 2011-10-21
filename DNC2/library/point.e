note
	description: "Represents a point in the 2d plane"
	author: "Dominik Gabi"
	date: "$Date$"
	revision: "$Revision$"

class
	POINT

inherit
	CONCURRENT_COMPARABLE

create
	make


feature -- Initialization

	make(nx, ny: REAL) is
			-- Initializes `x' and `y' with `nx' and `ny'
		do
			x := nx
			y := ny
		end

feature -- Basic operations

	str: STRING is
			-- Returns a string describing the point
		do
			Result := "(" + x.out + "," + y.out + ")"
		end

	is_less alias "<" (other: like Current): BOOLEAN is
			-- Compares the x coordinates
		do
			Result := x < other.x
		end

	squared_distance(other: POINT): REAL is
			-- The squared distance between two points
		local
			dx, dy: REAL
		do
			dx := x - other.x
			dy := y - other.y
			Result := dx*dx + dy*dy
		end


feature -- Access

	x: REAL assign set_x
			-- The x coordinate of the point

	set_x(nx: REAL) is
			-- Assigns `nx' to `x'
		do
			x := nx
		end

	y: REAL assign set_y
			-- The y coordinate of the point

	set_y(ny: REAL) is
			-- Assigns `ny' to `y'
		do
			y := ny
		end

end
