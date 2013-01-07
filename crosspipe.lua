-- local reference to graphics library
local lg = love.graphics

CrossPipe = {}
CrossPipe.__index = CrossPipe

-- creates a new instance of CrossPipe
-- container for two orthogonal LinePipe instances
function CrossPipe.create( _x, _y, _type, _rot )
	local self = setmetatable({}, CrossPipe)

	self.line1 = Pipe.create(_x,_y,_type,100)
	self.line2 = Pipe.create(_x,_y,_type,100)
	self.line2:rotate(_rot)

	return self
end

function CrossPipe:update(_frame)
	self.line1:update(_frame)
	self.line2:update(_frame)
	if self.line1.state == STATE_FULL then
		self.line2:setScore(1000)
	elseif self.line2.state == STATE_FULL then
		self.line1:setScore(1000)
	end
end

function CrossPipe:enterAction(_n, _frame)
	self.line1:enterAction(_n, _frame)
	self.line2:enterAction(_n, _frame)
end

function CrossPipe:getState()
	local s1 = self.line1:getState()
	local s2 = self.line2:getState()
	if s1 == STATE_FILL or s2 == STATE_FILL or (s1 == STATE_FULL or state ==STATE_FULL) then
		return STATE_FILL
	elseif s1 == STATE_FULL and s2 == STATE_FULL then
		return STATE_FULL
	elseif s1 == STATE_FULL or s2 == STATE_FULL then
		return STATE_FILL
	end
	return STATE_EMPTY
end

function CrossPipe:probe( _p, _frame )
	if self.line1:probe(_p, _frame) then
		return true
	end
	return self.line2:probe(_p, _frame)
end

-- draws the CrossPipe instance
-- calls draw routine on both its LinePipe instances
function CrossPipe:draw( )
	self.line1:draw()
	self.line2:draw()
end

-- rotates the CrossPipe instance
-- calls update routine on both its LinePipe instances
function CrossPipe:rotate(_times)
	self.line1:rotate(_times)
	self.line2:rotate(_times)
end