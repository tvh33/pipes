Score = {
	score = 0,
	labelsCount = 15,
	labelsPivot = 1,
	labelsX = {},
	labelsY = {},
	labelsTime = {},
	labelsValue = {},
	labelsActive = {},
	labelsOpacity = {},
	y = (GRID_HEIGHT)*DIM+YOFF+DIM_HALF
}

local FADE_TIME = 1.0
local LABEL_TIME = 1.5
local FADE_DELAY = LABEL_TIME-FADE_TIME

function Score.init()
	for i=1,Score.labelsCount do
		Score.labelsX[i] = 0
		Score.labelsY[i] = 0
		Score.labelsTime[i] = 0
		Score.labelsValue[i] = 0
		Score.labelsActive[i] = false
		Score.labelsOpacity[i] = 255
	end
end

function Score.addLabel(_x, _y, _value)
	local i = Score.labelsPivot
	Score.labelsX[i] = _x
	Score.labelsY[i] = _y
	Score.labelsTime[i] = 0
	Score.labelsValue[i] = _value
	Score.labelsActive[i] = true
	Score.labelsOpacity[i] = 255
	Score.labelsPivot = (i%15) + 1
	Score.addScore(_value)
end

function Score.addScore(_score)
	Score.score = Score.score + _score
end

function Score.update(_dt)
	for i=1,Score.labelsCount do
		if Score.labelsActive[i] then
			Score.labelsY[i] = Score.labelsY[i] - 40*_dt
			Score.labelsTime[i] = Score.labelsTime[i] + _dt
			if Score.labelsTime[i] > FADE_DELAY then
				Score.labelsOpacity[i] = (LABEL_TIME - Score.labelsTime[i])*255 
			end
			if Score.labelsTime[i] > LABEL_TIME then
				Score.labelsActive[i] = false
			end
		end
	end
end

function Score.draw()
	for i=1,Score.labelsCount do
		if Score.labelsActive[i] then
			love.graphics.setColor(255,255,255,Score.labelsOpacity[i])
			love.graphics.print(""..Score.labelsValue[i], Score.labelsX[i], Score.labelsY[i])
		end
	end
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("SCORE", 450, Score.y)
	love.graphics.print(Score.score, 450, Score.y+15)
	love.graphics.print("TIME LEFT", 550, Score.y)
	love.graphics.print(math.floor(timeRemaining), 550, Score.y+15)
end