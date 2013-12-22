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

	menuXOff = {0,-16,-16,-32,16}

	menu = true;
	menu_item = 0
	fadeTime = 1;
end

function love.update( dt )
	if menu then
		fadeTime = fadeTime - dt
		if fadeTime < 0 then
			fadeTime = 0
		end
	else
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
end

function love.draw( )
	if menu then
		drawMenu()
	else
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
end

function drawMenu()
	love.graphics.setFont(fontBold);
	love.graphics.drawq(pipe_sprites, q_main_menu_bg, 0, 0, 0, SCALE, SCALE, 0, 0)
	love.graphics.push()
	love.graphics.scale(SCALE, SCALE)
	local gap = 12
	local xBase = 188
	local yBase = 120
	love.graphics.print("ARCADE", xBase+menuXOff[1], yBase)
	love.graphics.print("CREATIVE", xBase+menuXOff[2], yBase+gap)
	love.graphics.print("SETTINGS", xBase+menuXOff[3], yBase+2*gap)
	love.graphics.print("HIGHSCORES", xBase+menuXOff[4], yBase+3*gap)
	love.graphics.print("EXIT", xBase+menuXOff[5], yBase+4*gap)
	love.graphics.drawq(pipe_sprites, q_arrow, xBase+menuXOff[menu_item+1]-8, yBase+menu_item*gap, 0, 1, 1, 0, 0)
	love.graphics.pop()
	if fadeTime > 0 then
		love.graphics.push()
		local r,g,b,a = love.graphics.getColor()
		love.graphics.setColor(0, 0, 0, 255*fadeTime)
		love.graphics.rectangle("fill", 0, 0, 765, 648)
		love.graphics.setColor(r,g,b,a)
		love.graphics.pop()
	end
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
	if menu then
		if _key == "down" then
			menu_item = (menu_item + 1)%5
		elseif _key == "up" then
			menu_item = (menu_item + 4)%5
		elseif _key == "return" then
			if menu_item == 0 then
				menu = false
			elseif menu_item == 4 then
				os.exit()
			end
		elseif _key == "escape" then
			os.exit()
		end
	else
		if _key == "up" or _key == "down" or _key == "left" or _key == "right" then
			boardKey(_key)
		elseif _key == "lctrl" then
			buffetShift()
		elseif _key == " " then
			boardLock()
		elseif _key == "q" then
			startBoard()
		elseif _key == "escape" then
			menu = true
			-- restart
			reset_board()
			clearLeaks()
			Buffet.reset()
		elseif _key == "+" then
			WATER_SPEED = WATER_SPEED + 1
		elseif _key == "-" then
			if WATER_SPEED > 1 then
				WATER_SPEED = WATER_SPEED - 1
			end
		elseif _key == "r" then
			-- restart
			reset_board()
			clearLeaks()
			Buffet.reset()
		elseif _key == "w" then
			if gameState == STATE_WATER_RUNNING then
				WATER_SPEED = SPEED_FAST
			end
		end
	end
end