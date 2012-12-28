local lg = love.graphics

PoolUnit = {}
PoolUnit.__index = PoolUnit

function PoolUnit.create( _x, _y )
	local self = setmetatable({}, PoolUnit)
	self.x = _x
	self.y = _y
	self.radius = 3*SCALE
	self.tick = 0
	return self
end

function PoolUnit:update( dt )
	self.tick = self.tick + WATER_SPEED*dt
	if self.tick >= 1 then
		self.radius = self.radius + 1
		self.tick = 0
	end
end

function PoolUnit:draw( )
	lg.setColor(99,168,183)
	lg.circle("fill", self.x, self.y, self.radius, 10)
	lg.setColor(255,255,255)
end

Pool = {}
Pool.__index = Pool

function Pool.create( _x, _y )
	local self = setmetatable({}, Pool)
	self.x = _x
	self.y = _y
	self.active = true
	self.units = {}
	self.units[1] = PoolUnit.create(_x, _y)
	-- add more units in some genius looking way
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