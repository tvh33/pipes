require "const"
require "resources"
require "effects"
require "point"
require "pipe"
require "crosspipe"
require "tools"
require "board"
require "startpipe"
require "endpipe"


function love.load( )
	love.graphics.setBackgroundColor(23,16,7)
	init_board()
	sfx = {}
end

function love.update( dt )
	update_board(dt)
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
	toolboxDraw()
end

function love.mousepressed( _x, _y, _button )
	boardClick(_x, _y, _button)
	toolboxClick(_x, _y, _button)
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
	end
end