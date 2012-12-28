-- local reference to graphics library
local lg = love.graphics

LinePipe = {}
LinePipe.__index = LinePipe

function LinePipe.create( _x, _y )
	self = setmetatable({}, Pipe)
	--sself.state = STATE_EMPTY
	self.cx = _x
	self.cy = _y
	self.x = _x*DIM
	self.y = _y*DIM
	self.type = 1
	self.rotation = 1
	self.value = 42
	return self
end

function LinePipe:getValue( )
	return self.value
end