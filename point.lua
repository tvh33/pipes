Point = {}
Point.__index = Point

-- Creates a new Point instance
-- _x: X-coordinate of the instance
-- _y: Y-coordiante of the instance
function Point.create( _x, _y )
	local self = setmetatable({}, Point)
	self.x = _x
	self.y = _y
	return self
end

-- Rotates the point 90 degrees counter-clockwise around
-- a specified number of times around a given point
-- _p: The point to rotate about
-- _n: The number of times to rotate 90 degress
function Point:rotate( _p, _n)
	local a = ((_n-1)%4) + 1
	local sin,cos
	if a == 1 then
		sin = 1
		cos = 0
	elseif a == 2 then
		sin = 0
		cos = -1
	elseif a == 3 then
		sin = -1
		cos = 0
	elseif a == 4 then
		sin = 0
		cos = 1
	end
	local dx, dy = (self.x-_p.x), (self.y-_p.y)
	self.x = _p.x + cos*dx + sin*dy
	self.y = _p.y - sin*dx + cos*dy
end

-- Tests whether or not the point instance is in the board grid
-- Returns true if inside grid, false otherwise
function Point:checkBounds()
	if self.x <= 0 or self.x > GRID_WIDTH or self.y <= 0 or self.y > GRID_HEIGHT then
		return false
	end
	return true
end

-- Simply returns the coordinates of the point
-- Order is x, y
function Point:coords( )
	return self.x, self.y
end

-- Compares two given point instances
-- _p1: The first point instance
-- _p2: The second point instance
-- True if equal, false otherwise
function Point.compare( _p1, _p2 )
	if _p1.x == _p2.x and _p1.y == _p2.y then
		return true
	end
	return false
end

-- Returns a string description of the point
-- Mainly (probably only) for debugging purposes
function Point:print( )
	return "("..self.x..", "..self.y..")"
end