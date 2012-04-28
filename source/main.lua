HardonCollider = require ('hardoncollider')
require('camera')
require('const')
require('game')
require('object')

function love.load()
	-- create a collider
	collider = HardonCollider(100, on_collide, done_collide)

	background = love.graphics.newImage("back.png")

	game:start()

	earth = Object:new(collider:addRectangle(0, game:mapHeight() - 20, game:mapWidth(), 20))
	turtle = Turtle:new(collider:addRectangle(50, 300, 50, 50))
	cat = Cat:new(collider:addRectangle(200, 200, 20, 20))

	-- todo: remove this from here
	turtle.forces[game.gravity] = {x = 0, y = game.gravity}
	--turtle.forces["walk"] = {x = 3000, y = 0}
	cat.forces[game.gravity] = {x = 0, y = game.gravity}

	-- the camera can move between 0 and the map's width minus the screen's width
	camera:setBounds(0, 0, game:mapWidth() - game:screenWidth(),
		game:mapHeight() - game:screenHeight())
end

function love.update(dt)
	-- pause the game by not updating
	if game.pause then return end

	-- dont know what it does but it helps
	dt = math.min(dt, 0.01)
	--print(dt)
	--love.timer.sleep(500)
	--if dt < 1/60 then
	--	love.timer.sleep(1000 * (1/60 - dt))
	--end

	-- check for collisions
	collider:update(dt)

	-- move stuff around
	cat:update(dt)
	turtle:update(dt)

	positionCamera(20, 50)
end

function on_collide(dt, shape_a, shape_b)
	-- todo: change the API so that everyone implements collide() and rebound()
	if shape_a.object == earth then
		shape_b.object:collide(earth)
	elseif shape_b.object == earth then
		shape_a.object:collide(earth)
	elseif shape_a.object == cat and shape_b.object == turtle then
		cat:collide(turtle)
	elseif shape_b.object == cat and shape_a.object == turtle then
		cat:collide(turtle)
	end
end

function done_collide(dt, shape_a, shape_b)
	if shape_a.object == earth then
		shape_b.object:rebound(earth)
	elseif shape_b.object == earth then
		shape_a.object:rebound(earth)
	elseif shape_a.object == cat and shape_b.object == turtle then
		cat:rebound(turtle)
	elseif shape_b.object == cat and shape_a.object == turtle then
		cat:rebound(turtle)
	end
end

-- the camera is positioned xPercent of the screen's width behind turtle's center
-- sot that it fallows turtle when he moves
function positionCamera(xPercent, yPercent)
	local turtleXCenter,turtleYCenter = turtle.shape:center()
	camera:setPosition(
		(turtleXCenter - ((xPercent * game:screenWidth())/100)),
		(turtleYCenter - ((yPercent * game:screenHeight())/100)))
end

function love.draw()
	camera:set()

	--love.graphics.draw(background, 0, 0)

	earth:draw()

	--love.graphics.setColor(255,255,255,150)
	turtle:draw()
	--love.graphics.setColor(255,255,255,255)
	cat:draw()
	drawHUD()

	camera:unset()
end

function drawHUD()
	local x1, y1, x2, y2 = cat.shape:bbox()

	love.graphics.print("w : " .. game:screenWidth(), 0, 0)
	love.graphics.print("h : " .. game:screenHeight(), 0, 10)
	--love.graphics.print("cx : " .. camera._x, camera._x, camera._y + 20)
	--love.graphics.print("cy : " .. camera._y, camera._x, camera._y + 30)
	love.graphics.print("px : " .. x1, camera._x, camera._y + 40)
	love.graphics.print("py : " .. y1, camera._x, camera._y + 50)
	love.graphics.print("fps : " .. love.timer.getFPS(), camera._x, camera._y + 60)
	love.graphics.print("v : " .. cat.speed.x .. ":" .. cat.speed.y, camera._x, camera._y + 70)

	local fx,fy= 0, 0
	for k in pairs(cat.forces) do
		fx = fx + cat.forces[k].x
		fy = fy + cat.forces[k].y
	end
	love.graphics.print("f : " .. fx .. ":" .. fy, camera._x, camera._y + 80)

	love.graphics.print("We choose to go to the moon. We choose to go to the moon in this decade and do the other things, not because they are easy, but because they are hard, because that goal will serve to organize and measure the best of our energies and skills, because that challenge is one that we are willing to accept, one we are unwilling to postpone, and one which we intend to win, and the others, too.", 100, 150)
end

function love.keypressed(key, unicode)
	if key == 'right' then
		cat.forces[key] = {x = RUNNING_FORCE, y = 0}
	elseif key == 'left' then
		cat.forces[key] = {x = -RUNNING_FORCE, y = 0}
	elseif key == ' '  then
		cat.forces[key] = {x = 0, y = JUMPING_FORCE}
	elseif key == 'p' then
		game.pause = not game.pause
	elseif key == "escape" then
      love.event.push("quit")
	end
end

function love.keyreleased(key)
   if key == 'left' then
		cat.forces[key] = nil
	elseif key == 'right' then
		cat.forces[key] = nil
	elseif key == ' ' then
		cat.forces[key] = nil
	end
end

function love.focus(f)
	-- pause the game when out of facus
    game.pause = not f
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end
