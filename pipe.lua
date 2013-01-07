-- local reference to graphics library
local lg = love.graphics

Pipe = {}
Pipe.__index = Pipe

-- creates a new instance of Pipe
-- state is initialized to STATE_EMPTY, and rotation to 1
function Pipe.create( _x, _y, _type, _score )
	local self = setmetatable({}, Pipe)

	-- general pipe data
	self.state = STATE_EMPTY
	self.point = Point.create(_x, _y)
	self.x = _x*DIM
	self.y = _y*DIM
	self.rotation = 1
	self.angle = 0
	self.step = 1
	self.type = _type
	self.enter = 0
	self.activated = -1
	self.score = _score

	-- initialize neighbor points for given type of pipe
	self.entries = {}
	self.noe = 2
	if _type == PIPE_CORNER then
		self.entries[1] = Point.create(_x-1, _y)
		self.entries[2] = Point.create(_x, _y-1)
	elseif _type == PIPE_LINE then
		self.entries[1] = Point.create(_x, _y+1)
		self.entries[2] = Point.create(_x, _y-1)
	elseif _type == PIPE_JUNCTION then
		self.noe = 3
		self.entries[1] = Point.create(_x-1, _y)
		self.entries[2] = Point.create(_x+1, _y)
		self.entries[3] = Point.create(_x, _y-1)
	elseif _type == PIPE_START then
		self.entries[1] = Point.create(_x, _y+1)
		self.entries[2] = Point.create(_x, _y-1)
	elseif _type == PIPE_END then
		self.noe = 1
		self.entries[1] = Point.create(_x, _y-1)
	end
	
	-- initialize exit vector
	self.exit = {}
	for i=1,self.noe do
		self.exit[i] = 1
	end

	return self
end

function Pipe:update( _frame)
	if self.state == STATE_FILL and _frame > self.activated then
		self.step = self.step + 1
		if self.step == 7 then
			self.state = STATE_FULL
			self:exitAction()
		end
	end
end

function Pipe:enterAction( _n, _frame)
	if self.state == STATE_EMPTY or _frame == self.activated then
		self.state = STATE_FILL
		self.activated = _frame
		--self.enter[_n] = 1
		self.enter = self.enter + 2^(_n-1)
		self.exit[_n] = 0
	end
end

function Pipe:exitAction( )
	for n=1,self.noe do
		local test = true
		if self.exit[n] == 1 then
			if self.entries[n]:checkBounds() then
				if getBoardValue(self.entries[n]) ~= 0 then
					if getBoardValue(self.entries[n]):probe(self.point, globalFrame) then
						-- Add score label if pipe has score
						if self.score > 0 then
							local scoreX = self.x+DIM_HALF + (self.entries[n].x - self.point.x)*DIM_HALF
							local scoreY = self.y+DIM_HALF + (self.entries[n].y - self.point.y)*DIM_HALF
							Score.addLabel(scoreX, scoreY, self.score)
						end
						test = false
					end
				end
				if test then
					score = false
					self:leak(n)
				end
			end
		end
	end
end

function Pipe:leak(_n )
	local xoff = DIM_HALF+(self.entries[_n].x - self.point.x)*DIM_HALF
	local yoff = DIM_HALF+(self.entries[_n].y - self.point.y)*DIM_HALF
	table.insert(sfx, Pool.create(self.x+xoff, self.y+yoff))
end

function Pipe:probe( _p, _frame )
	for n=1,self.noe do
		-- compare own entry points with point being probed from
		if Point.compare(self.entries[n], _p) then
			-- if points are equal then enter this point from the n'th entry
			self:enterAction(n, _frame)
			return true
		end
	end
	return false
end

-- draws the Pipe instance
function Pipe:draw( )
	lg.drawq(pipe_sprites, pipe_quads[self.type][self.rotation], self.x, self.y, 0, SCALE, SCALE, 0, 0)
	if self.state == STATE_FILL then
		lg.drawq(pipe_sprites, water_quads[self.type][self.enter][(self.step%7)], self.x+DIM_HALF, self.y+DIM_HALF, 
			math.rad(self.angle), SCALE, SCALE, 12, 12)
	elseif self.state == STATE_FULL then
		lg.drawq(pipe_sprites, water_quads[self.type][1][6], self.x+DIM_HALF, self.y+DIM_HALF, math.rad(self.angle), SCALE, SCALE, 12, 12)
	end
end

function Pipe:getState()
	return self.state
end

function Pipe:setScore(_score)
	self.score = _score
end

-- rotates the Pipe instance
-- updates rotation variable
-- updates entry points
function Pipe:rotate(_times)
	local rot = self.rotation - 1
	rot = (rot + _times)%4
	self.rotation = rot + 1
	--self.rotation = ((self.rotation)%4)+1
	-- update angle
	self.angle = self.angle - 90*_times
	-- rotate entry points
	for n=1,self.noe do
		self.entries[n]:rotate(self.point, _times)
	end
end