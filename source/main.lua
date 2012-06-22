HardonCollider = require ('hardoncollider')
require('camera')
require('const')
require('game')
require('GameObject')
require('LivingObject')
require('Turtle')
require('Cat')
require('Enemy')
require('Weapon')

collider = nil

earth = nil
turtle = nil
cat = nil

function love.load()
	-- create a collider
	collider = HardonCollider(100, on_collide, done_collide)

--	background = love.graphics.newImage("back.png")

	game:start()

	earth = GameObject:new(collider:addRectangle(0, game:mapHeight() - 20, game:mapWidth(), 20))
	collider:setPassive(earth.shape)
	turtle = Turtle:new(collider:addRectangle(50, 300, 100, 70))
	cat = Cat:new(collider:addRectangle(900, 300, 20, 20))

	game.objects['earth'] = earth
	game.objects[tostring(turtle)] = turtle
	game.objects[tostring(cat)] = cat

	local enemy = Enemy:new(collider:addRectangle(camera._x + 930, camera._y + 300, 100, 20))
	game.objects[tostring(enemy)] = enemy
	collider:addToGroup("Enemies", enemy.shape)
end

function love.update(dt)
	-- pause the game by not updating
	if game.pause then return end

	-- don't know what it does but it helps
	-- if something takes too long we also suspend game logic. i think
	dt = math.min(dt, 0.01)

	-- check for collisions
	collider:update(dt)

	-- move stuff around
	for k,v in pairs(game.objects) do
		v:update(dt)
	end

	spawnEnemies(dt)

	positionCamera(20, 50)
end

local spawnTime = 0

function spawnEnemies(dt)
	spawnTime = spawnTime + dt

	if (spawnTime > 0.5) then
		spawnTime = 0
		local enemy = Enemy:new(collider:addRectangle(camera._x + 930, camera._y + 300, 20, 20))
		collider:addToGroup("Enemies", enemy.shape)
		game.objects[tostring(enemy)] = enemy
	end
end

function on_collide(dt, shape_a, shape_b)
	-- collide the two objects with each other
	shape_b.object:collide(shape_a.object)
	shape_a.object:collide(shape_b.object)
end

function done_collide(dt, shape_a, shape_b)
	-- rebound the two objects from each other
	shape_b.object:rebound(shape_a.object)
	shape_a.object:rebound(shape_b.object)
end

-- the camera is positioned xPercent of the screen's width behind turtle's center
-- so that it fallows turtle when he moves
function positionCamera(xPercent, yPercent)
	local turtleXCenter,turtleYCenter = turtle.shape:center()
	camera:setPosition(
		(turtleXCenter - ((xPercent * game:screenWidth())/100)),
		(turtleYCenter - ((yPercent * game:screenHeight())/100)))
end

function love.draw()
	camera:set()

--	love.graphics.setColor(0,255,0,255)
--	love.graphics.draw(background, 0, 0)

	for k,v in pairs(game.objects) do
		v:draw()
	end

	drawHUD()

	camera:unset()
end

function drawHUD()
	local x1, y1, x2, y2 = cat.shape:bbox()

	love.graphics.print("w : " .. game:screenWidth(), 0, 0)
	love.graphics.print("h : " .. game:screenHeight(), 0, 10)
	--love.graphics.print("cx : " .. camera._x, camera._x, camera._y + 20)
	--love.graphics.print("cy : " .. camera._y, camera._x, camera._y + 30)
	love.graphics.print("p : (" ..
		string.format("%06.2f", x1) .. ", " ..
		string.format("%06.2f", y1) .. ")", camera._x, camera._y + 40)
	love.graphics.print("fps : " .. love.timer.getFPS(), camera._x, camera._y + 30)
	love.graphics.print("v : (" ..
		string.format("%07.3f", cat.speed.x) .. ", " ..
		string.format("%07.3f", cat.speed.y) .. ")", camera._x, camera._y + 50)

	local fx,fy= 0, 0
	for k in pairs(cat.forces) do
		fx = fx + cat.forces[k].x
		fy = fy + cat.forces[k].y
	end
	love.graphics.print("f : (" ..
		string.format("%012.3f", fx) .. ", " ..
		string.format("%012.3f", fy) .. ")", camera._x, camera._y + 60)

	love.graphics.print("We choose to go to the moon. We choose to go to the moon in this decade and do the other things, not because they are easy, but because they are hard, because that goal will serve to organize and measure the best of our energies and skills, because that challenge is one that we are willing to accept, one we are unwilling to postpone, and one which we intend to win, and the others, too.", 100, 150)
end

function love.keypressed(key, unicode)
	if key == 'right' then
		cat.forces[MOVE_RIGHT] = {x = RUNNING_FORCE, y = 0 }
		cat.direction = DIRECTION.RIGHT
	elseif key == 'left' then
		cat.forces[MOVE_LEFT] = {x = -RUNNING_FORCE, y = 0}
		cat.direction = DIRECTION.LEFT
	elseif key == ' ' or key == 'up' then
		cat.forces[JUMP] = {x = 0, y = JUMPING_FORCE}
	elseif key == 'z' then
		cat:attack()
	elseif key == 'p' then
		game.pause = not game.pause
	elseif key == "escape" then
      love.event.push("quit")
	end
end

function love.keyreleased(key)
	if key == 'left' then
		cat.forces[MOVE_LEFT] = nil
	elseif key == 'right' then
		cat.forces[MOVE_RIGHT] = nil
	elseif key == ' ' or key == 'up' then
		cat.forces[JUMP] = nil
	elseif key == 'z' then
	elseif key == 'f11' then
		toggleFullscreen()
	end
end

function love.focus(f)
	-- pause the game when out of focus
	game.pause = not f
end

function toggleFullscreen()
	local w, h, fullscreen, v, f = love.graphics.getMode()

	if fullscreen then
		love.graphics.setMode( 1000, 500, not fullscreen,  v, f)
	else
		--TODO: need to find a way to get monitor resolution
		love.graphics.setMode( 1280, 1024, not fullscreen,  v, f)
	end

	game.map.height = love.graphics.getHeight()
	-- reset the camera to fit the new screen size
	game:setCameraBounds()
	earth.shape:moveTo(0, game:mapHeight() - 10)
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end
