require "const"
require "resources"
require "effects"
require "point"
require "pipe"
require "crosspipe"
require "board"
require "startpipe"
require "endpipe"
require "buffet"
require "scoreSystem"


function love.load( )
	math.randomseed( os.time() )
	math.random(); math.random(); math.random()
	love.graphics.setBackgroundColor(23,16,7)
	ORIGIN = Point.create(0,0)
	gameState = STATE_TIME_LEFT
	init_board()
	sfx = {}
	Buffet.setPosition(XOFF, (GRID_HEIGHT)*DIM+YOFF+DIM_HALF)
	Buffet.reset()
	Score.init()
end

function love.update( dt )
	update_board(dt)
	Score.update(dt)
	for	i,v in ipairs(sfx) do
		if v.active then
			v:update(dt)
		else
			table.remove(sfx,i)
		end
	end
end

function love.draw( )
	drawBoardBase()
	for	i,v in ipairs(sfx) do
		if v.active then
			v:draw()
		else
			table.remove(sfx,i)
		end
	end
	draw_board()
	Buffet.draw()
	Score.draw()
end

function clearLeaks( )
	for	i,v in ipairs(sfx) do
		table.remove(sfx,i)
	end
end

function love.mousepressed( _x, _y, _button )
	Buffet.mousePressed(_x,_y,_button)
end

function love.mousereleased( _x, _y, _button )
	boardClick(_x, _y, _button)
	Buffet.mouseReleased(_x, _y, _button)
end

function love.keypressed( _key )
	if _key == " " then
		startBoard()
	elseif _key == "escape" then
		os.exit()
	elseif _key == "+" then
		WATER_SPEED = WATER_SPEED + 1
	elseif _key == "-" then
		if WATER_SPEED > 1 then
			WATER_SPEED = WATER_SPEED - 1
		end
	elseif _key == "r" then
		reset_board()
		clearLeaks()
		Buffet.reset()
	elseif _key == "w" then
		if gameState == STATE_WATER_RUNNING then
			WATER_SPEED = SPEED_FAST
		end
	end
end