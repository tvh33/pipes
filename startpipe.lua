-- local reference to graphics library
local lg = love.graphics

StartPipe = {}
StartPipe.__index = StartPipe

-- creates a new instance of StartPipe
-- container for two orthogonal LinePipe instances
function StartPipe.create( _x, _y, _rot )
	local self = setmetatable({}, StartPipe)

	self.state = 0
	self.x = _x*DIM
	self.y = _y*DIM
	self.line = Pipe.create(_x,_y,PIPE_START)
	self.wheelAngle = 0

	if _rot > 0 then
		self.line:rotate(_rot)
	end

	return self
end

function StartPipe:update(_frame, _dt)
	self.line:update(_frame, _dt)
end

function StartPipe:updateReal( _dt )
	if self.state == 1 then
		if self.wheelAngle <= 405 then
			self.wheelAngle = self.wheelAngle + 315*_dt
		else
			self.wheelAngle = 45
			self.state = 2
		end
	end
end

function StartPipe:enterAction()
	if self.state == 0 then
		self.line:enterAction(1, 0)
		self.state = 1
	end
end

function StartPipe:getState()
	return self.line:getState()
end

function StartPipe:probe( _p, _frame )
	return false
end

-- draws the StartPipe instance
-- calls draw routine on both its LinePipe instances
function StartPipe:draw( )
	self.line:draw()
	local a = math.floor(((self.wheelAngle%360)/45)+1)
	lg.drawq(pipe_sprites, wheelQuads[a], self.x+DIM_HALF, self.y+DIM_HALF+(SCALE*4), math.rad(self.wheelAngle), SCALE, SCALE, 12, 12)
end

-- rotates the StartPipe instance
-- calls update routine on both its LinePipe instances
function StartPipe:rotate(_times)
	self.line:rotate(_times)
end