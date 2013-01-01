pipe_sprites = love.graphics.newImage("res/sprites.png")
pipe_sprites:setFilter("nearest", "nearest")

-- pipe sprites
pipe_quads = {}
for j=1,5 do
	pipe_quads[j] = {}
	for i=1,4 do
		pipe_quads[j][i] = love.graphics.newQuad((i-1)*BASE_DIM, (j-1)*BASE_DIM, BASE_DIM, BASE_DIM, 512, 512)
	end
end

-- tile sprite
tileQuad = love.graphics.newQuad(0, 5*BASE_DIM, BASE_DIM, BASE_DIM, 512, 512)

-- wheel animation sprites
wheelQuads = {}
for i=1,8 do
	wheelQuads[i] = love.graphics.newQuad((9+i)*BASE_DIM, 0, BASE_DIM, BASE_DIM, 512, 512)
end

-- water animation sprites for each pipe
water_quads = {}
y_base = {}
y_base[1] = 0
y_base[2] = 3*BASE_DIM
y_base[3] = 6*BASE_DIM
y_base[4] = 13*BASE_DIM
y_base[5] = 14*BASE_DIM
local js = {3,3,7,1,1}
local x_base = 4*BASE_DIM
for n=1,5 do
	water_quads[n] = {}
	for j=1,js[n] do
		water_quads[n][j] = {}
		for i=1,6 do
			water_quads[n][j][i] = love.graphics.newQuad(x_base+(i-1)*BASE_DIM, y_base[n]+(j-1)*BASE_DIM, BASE_DIM, BASE_DIM, 512, 512)
		end
	end
end