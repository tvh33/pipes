-- local reference to graphics library
local lg = love.graphics

EndPipe = {}
EndPipe.__index = EndPipe

-- creates a new instance of EndPipe
-- container for two orthogonal LinePipe instances
function EndPipe.create( _x, _y, _rot, _score )
	local self = setmetatable({}, EndPipe)

	self.state = 0
	self.x = _x*DIM
	self.y = _y*DIM
	self.line = Pipe.create(_x,_y,PIPE_END,_score)
	self.wheelAngle = 0

	if _rot > 0 then
		self.line:rotate(_rot)
	end

	return self
end

function EndPipe:update(_frame)
	self.line:update(_frame)
end

function EndPipe:enterAction()
	self.line:enterAction()
end

function EndPipe:getState()
	return self.line:getState()
end

function EndPipe:probe(_p, _frame)
	won = self.line:probe(_p, _frame)
	if won then
		boardEndPipe()
		local scoreX = self.line.x + DIM_HALF
		local scoreY = self.line.y + DIM_HALF
		Score.addLabel(scoreX, scoreY, 250)
	end
	return won
end

-- draws the EndPipe instance
-- calls draw routine on both its LinePipe instances
function EndPipe:draw()
	self.line:draw()
end

-- rotates the EndPipe instance
-- calls update routine on both its LinePipe instances
function EndPipe:rotate(_times)
	self.line:rotate(_times)
end