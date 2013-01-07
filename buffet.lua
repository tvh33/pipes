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

local pendingXoff = 0
local pendingYoff = 0

function Buffet.reset( )
	for i=1,SLOT_COUNT do
		Buffet.new(i)
	end
	Buffet.pending = 0
end

function Buffet.new( _index )
	local pipe = PIPE_CROSSLINE
	local rot = math.random(1,4)
	if math.random() > 0.10 then
		pipe = math.random(1,3)
	end

	-- update pipe information for this slot
	Buffet.pipes[_index] = pipe
	Buffet.rotations[_index] = rot
	Buffet.states[_index] = AVAILABLE
end

function Buffet.setPosition( _x, _y )
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
		love.graphics.rectangle("line", Buffet.pipeX[i], Buffet.y, DIM, DIM)
		if Buffet.states[i] == AVAILABLE then
			local pipeType = Buffet.pipes[i]
			local pipeRotation = Buffet.rotations[i]
			love.graphics.drawq(pipe_sprites, pipe_quads[pipeType][pipeRotation], Buffet.pipeX[i], Buffet.y, 0, SCALE, SCALE, 0, 0)
		end
	end
	if Buffet.pending > 0 then
		local pipeType = Buffet.pipes[Buffet.pending]
		local pipeRotation = Buffet.rotations[Buffet.pending]
		love.graphics.drawq(pipe_sprites, pipe_quads[pipeType][pipeRotation], love.mouse.getX()-pendingXoff, love.mouse.getY()-pendingYoff, 0, SCALE, SCALE, 0, 0)
	end
end