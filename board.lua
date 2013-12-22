-- local graphics library reference
local lg = love.graphics

local timer = 0
globalFrame = 0
local timeSinceLastTick = 0
stateting = 0

-- time until water flows
local time = 60
timeRemaining = time

-- number of end pipes
local endNumber = 3
local endPipes = {}
local endPipesDone = 0

-- number of start pipes
local startNumber = 2
local startPipes = {}

-- two-dimensional array to store board data
-- initialized with zero entries
board_data = {}
for j=1,GRID_HEIGHT do
	board_data[j] = {}
	for i=1,GRID_WIDTH do
		board_data[j][i] = 0
	end
end

local current_x = 1
local current_y = 1

function init_board()
	reset_board()
end

function reset_board()
	-- clear board grid
	for j=1,GRID_HEIGHT do
		for i=1,GRID_WIDTH do
			board_data[j][i] = 0
		end
	end
	-- Insert random start pipe(s)
	for i=1,startNumber+endNumber do
		local xCoord = math.random(1, GRID_WIDTH)
		local yCoord = math.random(1, GRID_HEIGHT)
		while false == checkCoordinates(xCoord, yCoord) do
			xCoord = math.random(1, GRID_WIDTH)
			yCoord = math.random(1, GRID_HEIGHT)
		end
		local rot = math.random(0, 3)

		if i > startNumber then
			-- insert start pipe
			board_data[yCoord][xCoord] = EndPipe.create(xCoord, yCoord, rot, 0)
		else 
			-- insert end pipe
			board_data[yCoord][xCoord] = StartPipe.create(xCoord, yCoord, rot, 0)
		end
		correctRotation(board_data[yCoord][xCoord])
		startPipes[i] = board_data[yCoord][xCoord]
	end
	-- set remaining time
	timeRemaining = time+1
	-- set start state
	gameState = STATE_TIME_LEFT
	-- set water speed
	WATER_SPEED = 1.5
end

function checkCoordinates(_x, _y)
	for j=-1,1 do
		for i=-1,1 do
			local point = Point.create(_x+i, _y+j)
			if (j == 0 or i == 0) and point:checkBounds() then
				if board_data[_y+j][_x+i] ~= 0 then
					return false
				end
			end
		end
	end
	return true
end

function correctRotation(_pipe)
	for n=1,_pipe.line.noe do
		while false == _pipe.line.entries[n]:checkBounds() do
			_pipe:rotate(1)
		end
	end
end

-- updates the board
-- iterates through board matrix and calls update routine on
-- individual pipe instances
function update_board(_dt)

	if gameState == STATE_WATER_RUNNING then
		-- update wheel animations (may be finished)
		for i=1,startNumber do
			startPipes[i]:updateReal(_dt)
		end
		-- record delta time
		timeSinceLastTick = timeSinceLastTick+WATER_SPEED*_dt
		-- check if time to tick pipes
		if timeSinceLastTick >= 1 then
			-- increment global tick count
			globalFrame = globalFrame + 1
			for j=1,GRID_HEIGHT do
				for i=1,GRID_WIDTH do
					if board_data[j][i] ~= 0 then
						board_data[j][i]:update(globalFrame)
					end
				end
			end
			timeSinceLastTick = 0
		end
	elseif gameState == STATE_TIME_LEFT then
		timeRemaining = timeRemaining - _dt
		if timeRemaining <= 0 then
			timeRemaining = 0
			startBoard()
		end
	end
end

function boardEndPipe()
	endPipesDone = endPipesDone + 1
	--print("End pipes done = "..endPipesDone)
end

function startBoard()
	gameState = STATE_WATER_RUNNING
	for i=1,startNumber do
		startPipes[i]:enterAction()
	end
end

function getBoardValue(_p)
	return board_data[_p.y][_p.x]
end

function boardClick(_x, _y, _button)
	if _x > XOFF and _x < XOFF+GRID_WIDTH*DIM and _y > YOFF and _y < YOFF+GRID_HEIGHT*DIM then
		-- quantize points
		local x = math.floor((_x-XOFF)/DIM)+1
		local y = math.floor((_y-YOFF)/DIM)+1
		if _button == "l" then
			if Buffet.pending > 0 then
				if board_data[y][x] == 0 or (board_data[y][x] ~= 0 and board_data[y][x]:getState() == STATE_EMPTY) then
					local pipeType = Buffet.pipes[Buffet.pending]
					if pipeType == PIPE_CROSSLINE then
						board_data[y][x] = CrossPipe.create(x,y,PIPE_LINE,1)
					else
						board_data[y][x] = Pipe.create(x,y,pipeType,100)
					end
					board_data[y][x]:rotate(Buffet.rotations[Buffet.pending]-1)
					Buffet.reset()
				end
			end
		end
	end
end

-- draws the board
-- iterates through board matrix and calls draw routines on
-- individual pipe instances
function draw_board()
	for j=1,GRID_HEIGHT do
		for i=1,GRID_WIDTH do
			if board_data[j][i] ~= 0 then
				board_data[j][i]:draw()
			end
			if current_y == j and current_x == i then
				lg.rectangle("line", (i-1)*DIM+XOFF, (j-1)*DIM+YOFF, DIM, DIM)
				buffetDrawTmp(i,j)
			end
		end
	end
end

function drawBoardBase()
	for j=0,GRID_HEIGHT-1 do
		for i=0,GRID_WIDTH-1 do
			lg.drawq(pipe_sprites, tileQuad, i*DIM+XOFF, j*DIM+YOFF, 0, SCALE, SCALE, 0, 0)
		end
	end
end

function boardKey(_key)
	if _key == "down" then
		current_y = current_y%GRID_HEIGHT + 1
	elseif _key == "up" then
		current_y = current_y%GRID_HEIGHT - 1
	elseif _key == "left" then
		current_x = current_x%GRID_WIDTH - 1
	elseif _key == "right" then
		current_x = current_x%GRID_WIDTH + 1
	end
end

function boardLock()
	local pipeType, rot = buffetLock()
	if pipeType == PIPE_CROSSLINE then
		board_data[current_y][current_x] = CrossPipe.create(current_x,current_y,PIPE_LINE,1)
	else
		board_data[current_y][current_x] = Pipe.create(current_x,current_y,pipeType,100)
	end
	board_data[current_y][current_x]:rotate(rot-1)
	Buffet.reset()
end