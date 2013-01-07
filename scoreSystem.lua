Score = {
	score = 0,
	labelsCount = 15,
	labelsPivot = 1,
	labelsX = {},
	labelsY = {},
	labelsTime = {},
	labelsValue = {},
	labelsActive = {}
}

function Score.init( )
	for i=1,Score.labelsCount do
		Score.labelsX[i] = 0
		Score.labelsY[i] = 0
		Score.labelsTime[i] = 0
		Score.labelsValue[i] = 0
		Score.labelsActive[i] = false
	end
end

function Score.addLabel( _x, _y, _value)
	local i = Score.labelsPivot
	Score.labelsX[i] = _x
	Score.labelsY[i] = _y
	Score.labelsTime[i] = 0
	Score.labelsValue[i] = _value
	Score.labelsActive[i] = true
	Score.labelsPivot = (i%15) + 1
	Score.addScore(_value)
end

function Score.addScore( _score )
	Score.score = Score.score + _score
end

function Score.update( dt )
	for i=1,Score.labelsCount do
		if Score.labelsActive[i] then
			Score.labelsY[i] = Score.labelsY[i] - 40*dt
			Score.labelsTime[i] = Score.labelsTime[i] + dt
			if Score.labelsTime[i] > 2.0 then
				Score.labelsActive[i] = false
			end
		end
	end
end

function Score.draw( )
	for i=1,Score.labelsCount do
		if Score.labelsActive[i] then
			love.graphics.print(""..Score.labelsValue[i], Score.labelsX[i], Score.labelsY[i])
		end
	end
	love.graphics.print(""..Score.score, 500, 620)
end