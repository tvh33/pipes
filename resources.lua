pipe_sprites = love.graphics.newImage("res/sprites.png")
pipe_sprites:setFilter("nearest", "nearest")

pipe_quads = {}
for j=1,3 do
	pipe_quads[j] = {}
	for i=1,4 do
		pipe_quads[j][i] = love.graphics.newQuad((i-1)*BASE_DIM, (j-1)*BASE_DIM, BASE_DIM, BASE_DIM, 512, 512)
	end
end

water_quads = {}
local x_base = 4*BASE_DIM
for j=1,5 do
	water_quads[j] = {}
	for i=1,6 do
		water_quads[j][i] = love.graphics.newQuad(x_base+(i-1)*BASE_DIM, (j-1)*BASE_DIM, BASE_DIM, BASE_DIM, 512, 512)
	end
end

tileQuad = love.graphics.newQuad(0, 3*BASE_DIM, BASE_DIM, BASE_DIM, 512, 512)

testSprites = {}
y_base = {}
y_base[1] = 0
y_base[2] = 3*BASE_DIM
y_base[3] = 6*BASE_DIM
local js = {3,3,7}
for n=1,3 do
	testSprites[n] = {}
	for j=1,js[n] do
		testSprites[n][j] = {}
		for i=1,6 do
			testSprites[n][j][i] = love.graphics.newQuad(x_base+(i-1)*BASE_DIM, y_base[n]+(j-1)*BASE_DIM, BASE_DIM, BASE_DIM, 512, 512)
		end
	end
end