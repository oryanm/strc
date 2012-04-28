game = {}
game.map = {}
game.map.width = 2680 < love.graphics.getWidth() and love.graphics.getWidth() or 2680 -- must be >= to screen width
game.map.height = 500
game.gravity = 10000
game.objects = {}
game.pause = true

function game:start()
	print(game.map.width .. " " .. game.map.height)
end

function game:mapWidth()
	return self.map.width
end

function game:mapHeight()
	return self.map.height
end

function game:screenWidth()
	return love.graphics.getWidth()
end

function game:screenHeight()
	return love.graphics.getHeight()
end
