game = {}
game.map = {}
game.map.width = -1
game.map.height = -1
game.gravity = 10000
game.objects = {}
game.pause = false
game.timer = require('lib.hump.timer')

function game:start()
	self:setMapBounds()
	self:setCameraBounds()

	earth = Earth:new()
	turtle = Turtle:new()
	cat = Cat:new()

	speakers:load()
end

function game:togglePause()
	self.pause = not self.pause
	if self.pause then
		speakers.sound.pause('music')
	else
		speakers.sound.resume('music')
	end
end

function game:stop()
	for k,v in pairs(self.objects) do
		v:destroy()
	end

	collider:clear()

	speakers:silence()
end

function game:reset()
	self:stop()
	self:start()
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

function game:setMapBounds()
	-- must be >= to screen width
	self.map.width = 2680 < love.graphics.getWidth() and love.graphics.getWidth() or 2680
	self.map.height = love.graphics.getHeight()
end

function game:setCameraBounds()
	-- the camera can move between 0 and the map's width minus the screen's width
	camera:setBounds(0, 0, self:mapWidth() - self:screenWidth(),
		self:mapHeight() - self:screenHeight())
end

function game:toggleFullscreen()
	local w, h, fullscreen, v, f = love.graphics.getMode()

	if fullscreen then
		love.graphics.setMode(1000, 500, not fullscreen, v, f)
	else
		-- this should set the resolution to it's current one in fullscreen
		love.graphics.setMode(0, 0, not fullscreen, v, f)
		-- a bug in LOVE 0.8 makes it necessary to set the mode again
		love.graphics.setMode(love.graphics.getWidth(), love.graphics.getHeight(), not fullscreen, v, f)
	end

	self.map.height = love.graphics.getHeight()
	-- reset the camera to fit the new screen size
	self:setCameraBounds()
	local x = earth.shape:center()
	earth.shape:moveTo(x, self:mapHeight() - 10)
end