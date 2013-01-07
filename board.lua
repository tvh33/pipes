-- local graphics library reference
local lg = love.graphics

local timer = 0
globalFrame = 0
local clock = 0
stateting = 0
local startPipes = {}
local endPipes = {}
local endNumber = 2
local startNumber = 1
-- two-dimensional array to store board data
-- initialized with zero entries
board_data = {}
for j=1,GRID_HEIGHT do
	board_data[j] = {}
	for i=1,GRID_WIDTH do
		board_data[j][i] = 0
	end
end

function init_board( )
	reset_board()
end

function reset_board( )
	-- clear board grid
	for j=1,GRID_HEIGHT do
		for i=1,GRID_WIDTH do
			board_data[j][i] = 0
		end
	end
	-- Insert random start pipe(s)
	for i=1,startNumber do
		local rot = math.random(0,3)
		local xCoord = math.random(2,GRID_WIDTH-1)
		local yCoord = math.random(2,GRID_HEIGHT-1)
		board_data[yCoord][xCoord] = StartPipe.create(xCoord, yCoord, rot, 0)
		startPipes[i] = board_data[yCoord][xCoord]
	end
	-- Insert random end pipe(s)
	for i=1,endNumber do
		local rot = math.random(0,3)
		local xCoord = math.random(2,GRID_WIDTH-1)
		local yCoord = math.random(2,GRID_HEIGHT-1)
		board_data[yCoord][xCoord] = EndPipe.create(xCoord, yCoord, rot, 100)
		endPipes[i] = board_data[yCoord][xCoord]
	end
end

-- updates the board
-- iterates through board matrix and calls update routine on
-- individual pipe instances
function update_board( dt )
	for i=1,startNumber do
		startPipes[i]:updateReal(dt)
	end
	if stateting > 0 then
		clock = clock + WATER_SPEED*dt
		if clock >= 1 then
			globalFrame = globalFrame + 1
			--print("Global clock = "..globalFrame)
			for j=1,GRID_HEIGHT do
				for i=1,GRID_WIDTH do
					if board_data[j][i] ~= 0 then
						board_data[j][i]:update(globalFrame)
						
					end
				end
			end
			clock = 0
		end
	end
end

function startBoard( )
	stateting = 1
	for i=1,startNumber do
		startPipes[i]:enterAction()
	end
end

function getBoardValue(_p)
	return board_data[_p.y][_p.x]
end

function boardClick( _x, _y, _button )
	if _x > DIM and _x < DIM+GRID_WIDTH*DIM and _y > DIM and _y < DIM+GRID_HEIGHT*DIM then
		-- quantize points
		local x = math.floor((_x-DIM)/DIM)+1
		local y = math.floor((_y-DIM)/DIM)+1
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
		end
	end
end

function drawBoardBase( )
	for j=1,GRID_HEIGHT do
		for i=1,GRID_WIDTH do
			lg.drawq(pipe_sprites, tileQuad, i*DIM, j*DIM, 0, SCALE, SCALE, 0, 0)
		end
	end
end