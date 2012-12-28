require "const"
require "resources"
require "effects"
require "point"
require "pipe"
require "crosspipe"
require "tools"
require "board"


function love.load( )
	love.graphics.setBackgroundColor(68,61,51)
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
	end
end