-- local graphics library reference
local lg = love.graphics

local timer = 0
globalFrame = 0
local clock = 0
stateting = 0
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
	board_data[6][3] = Pipe.create(3,6,PIPE_CORNER)
end

-- updates the board
-- iterates through board matrix and calls update routine on
-- individual pipe instances
function update_board( dt )
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
	board_data[6][3]:enterAction(1, 0)
end

function getBoardValue(_p)
	return board_data[_p.y][_p.x]
end

function boardClick( _x, _y, _button )
	if _x > DIM and _x < DIM+GRID_WIDTH*DIM and _y > DIM and _y < DIM+GRID_HEIGHT*DIM then
		local x = math.floor((_x-DIM)/DIM)+1
		local y = math.floor((_y-DIM)/DIM)+1
		if _button == "l" then
			if board_data[y][x] == 0 then
				if toolLast == 1 then
					board_data[y][x] = Pipe.create(x,y,PIPE_CORNER)
				elseif toolLast == 2 then
					board_data[y][x] = Pipe.create(x,y,PIPE_LINE)
				elseif toolLast == 3 then
					board_data[y][x] = Pipe.create(x,y,PIPE_JUNCTION)
				elseif toolLast == 4 then
					board_data[y][x] = CrossPipe.create(x,y,PIPE_LINE,1)
				end
			else
				if board_data[y][x]:getState() == STATE_EMPTY then
					board_data[y][x]:rotate(1)
				end
			end
		elseif _button == "r" then
			board_data[y][x] = 0
		end
	end
end

-- draws the board
-- iterates through board matrix and calls draw routines on
-- individual pipe instances
function draw_board()
	for j=1,GRID_HEIGHT do
		for i=1,GRID_WIDTH do
			--lg.drawq(pipe_sprites, tileQuad, i*DIM, j*DIM, 0, SCALE, SCALE, 0, 0)
			lg.rectangle("line", i*DIM, j*DIM, DIM, DIM)
			if board_data[j][i] ~= 0 then
				board_data[j][i]:draw()
			end
		end
	end
end