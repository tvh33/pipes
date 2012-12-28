local lg = love.graphics

PoolUnit = {}
PoolUnit.__index = PoolUnit

function PoolUnit.create( _x, _y, _speed )
	local self = setmetatable({}, PoolUnit)
	self.x = _x
	self.y = _y
	self.active = true
	self.frame = 3*SCALE
	self.speed = _speed
	self.tick = 0
	return self
end

function PoolUnit:update( dt )
	self.tick = self.tick + WATER_SPEED*dt
	if self.tick >= 1 then
		self.frame = self.frame + 1
		self.tick = 0
	end
end

function PoolUnit:draw( )
	lg.setColor(99,168,183)
	lg.circle("fill", self.x, self.y, self.frame, 10)
	lg.setColor(255,255,255)
end

Pool = {}
Pool.__index = Pool

function Pool.create( _x, _y )
	local self = setmetatable({}, Pool)
	self.x = _x
	self.y = _y
	self.active = true
	self.frame = 0
	self.units = {}
	self.units[1] = PoolUnit.create(_x, _y, 4)
	--for i=2,5 do
	--	self.units[i] = PoolUnit.create(_x+math.random(-1,1)*math.random(1,40), _y+math.random(-10,10), 4+math.random(2,4))
	--end
	return self
end

function Pool:update( dt )
	for i=1,1 do
		self.units[i]:update(dt)
	end
	
end

function Pool:draw( )
	for i=1,1 do
		self.units[i]:draw()
	end
end