local lg = love.graphics
local x = (GRID_WIDTH+1)*DIM + 20
local y = DIM
toolLast = 0
local h = 4*DIM

function toolboxClick( _x, _y, _button )
	if _x > x and _x < x+DIM and _y > y and _y < y+h then
		local index = math.floor((_y-y)/DIM)+1
		toolLast = index
	end
end

function toolboxDraw( )
	for i=1,3 do
		lg.drawq(pipe_sprites,pipe_quads[i][1],x,i*DIM,0,SCALE,SCALE,0,0) 
	end
	lg.drawq(pipe_sprites,pipe_quads[2][1],x,4*DIM,0,SCALE,SCALE,0,0) 
	lg.drawq(pipe_sprites,pipe_quads[2][2],x,4*DIM,0,SCALE,SCALE,0,0)
	if toolLast > 0 then
		lg.rectangle("line", x, y+(toolLast-1)*DIM, DIM, DIM)
	end
end