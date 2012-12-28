Point = {}
Point.__index = Point

function Point.create( _x, _y )
	local self = setmetatable({}, Point)
	self.x = _x
	self.y = _y
	return self
end

function Point:rotate( _p, _angle )
	local a = ((_angle-1)%4) + 1
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
	local tmpx = self.x
	self.x = _p.x + cos*(self.x - _p.x) + sin*(self.y - _p.y)
	self.y = _p.y - sin*(tmpx - _p.x) + cos*(self.y - _p.y)
	--self.x = _p.x + sin*(self.y - _p.y)
	--self.y = _p.y - cos*(tmpx - _p.x)
end

function Point:checkBounds( )
	if self.x <= 0 or self.x > GRID_WIDTH or self.y <= 0 or self.y > GRID_HEIGHT then
		return false
	end
	return true
end

function Point:coords( )
	return self.x, self.y
end

function Point.compare( _p1, _p2 )
	if _p1.x == _p2.x and _p1.y == _p2.y then
		return true
	end
	return false
end

function Point:print( )
	return "("..self.x..", "..self.y..")"
end