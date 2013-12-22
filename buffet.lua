local AVAILABLE = 1
local PENDING = 2
local GAP = 0
local SLOT_COUNT = 5
local SIZE = GAP+DIM
local WIDTH = SLOT_COUNT*SIZE - GAP
local HEIGHT = DIM

Buffet = {
	x = 0,
	y = 0,
	pending = 0,
	pipes = {},
	rotations = {},
	states = {},
	pipeX = {}
}
-- slot types
local slotType = {}
for i=1,SLOT_COUNT do
	slotType[i] = i
end

local pendingXoff = 0
local pendingYoff = 0

currentBuffet = 1

function Buffet.reset()
	-- shuffle slot types
	local n = SLOT_COUNT
	while n > 1 do
		local k = math.random(1,n)
		-- swap
		local swapper = slotType[n]
		slotType[n] = slotType[k]
		slotType[k] = swapper

		n = n - 1
	end

	for i=1,SLOT_COUNT do
		Buffet.new(i)
	end
	Buffet.pending = 0
end

function Buffet.new(_index)
	local rot = math.random(1,4)
	local pipe = slotType[_index]
	if slotType[_index] > 3 then
		pipe = math.random(1,4)
		if pipe == 4 then pipe = 6 end
	end

	-- update pipe information for this slot
	Buffet.pipes[_index] = pipe
	Buffet.rotations[_index] = rot
	Buffet.states[_index] = AVAILABLE
end

function Buffet.setPosition(_x, _y)
	Buffet.x = _x
	Buffet.y = _y
	for i=1,SLOT_COUNT do
		Buffet.pipeX[i] = Buffet.x + (i-1)*SIZE
	end
end

function Buffet.mousePressed( _x, _y, _button )
	if _x > Buffet.x and _x < Buffet.x+WIDTH and _y > Buffet.y and _y < Buffet.y+HEIGHT then
		local index = math.floor((_x-Buffet.x)/SIZE)+1
		if _x > Buffet.pipeX[index] and _x < Buffet.pipeX[index]+DIM then
			pendingYoff = _y - Buffet.y
			pendingXoff = _x - Buffet.pipeX[index]
			Buffet.states[index] = PENDING
			Buffet.pending = index
		end
	end
end

function Buffet.mouseReleased( _x, _y, _button )
	if Buffet.pending > 0 then
		Buffet.states[Buffet.pending] = AVAILABLE
		Buffet.pending = 0
	end
end

function Buffet.draw( )
	for i=1,SLOT_COUNT do
		--love.graphics.rectangle("line", Buffet.pipeX[i], Buffet.y, DIM, DIM)
		if Buffet.states[i] == AVAILABLE then
			local pipeType = Buffet.pipes[i]
			local pipeRotation = Buffet.rotations[i]
			love.graphics.drawq(pipe_sprites, pipe_quads[pipeType][pipeRotation], Buffet.pipeX[i], Buffet.y, 0, SCALE, SCALE, 0, 0)
		end
		if currentBuffet == i then
			love.graphics.rectangle("line", Buffet.pipeX[i], Buffet.y, DIM, DIM)
		end
	end
	if Buffet.pending > 0 then
		local pipeType = Buffet.pipes[Buffet.pending]
		local pipeRotation = Buffet.rotations[Buffet.pending]
		love.graphics.drawq(pipe_sprites, pipe_quads[pipeType][pipeRotation], love.mouse.getX()-pendingXoff, love.mouse.getY()-pendingYoff, 0, SCALE, SCALE, 0, 0)
	end
end

function buffetShift()
	currentBuffet = currentBuffet%5+1
end

function buffetDrawTmp(_x, _y)
	local pipeType = Buffet.pipes[currentBuffet]
	local pipeRotation = Buffet.rotations[currentBuffet]
	love.graphics.drawq(pipe_sprites, pipe_quads[pipeType][pipeRotation], (_x-1)*DIM+XOFF, (_y-1)*DIM+YOFF, 0, SCALE, SCALE, 0, 0)
end

function buffetLock()
	return Buffet.pipes[currentBuffet], Buffet.rotations[currentBuffet]
end