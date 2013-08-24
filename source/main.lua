require('extendedMath')
HardonCollider = require('lib.hardoncollider')
vector = require('lib.hump.vector')
require('lib.middleclass')
require('canvas')
require('camera')
require('const')
require('game')
require('keyboard')
require('mouse')
require('speakers')
require('force')
require('Trailable')
require('entities.GameObject')
require('entities.LivingObject')
require('entities.Turtle')
require('entities.Cat')
require('entities.Enemy')
require('entities.Weapon')
require('entities.MeleeWeapon')
require('entities.Gun')
require('entities.Projectile')

function love.load()
	cati = love.graphics.newImage(IMAGE_RESOURCES_PATH .. "cat5.png")
	pointer = love.graphics.newImage(IMAGE_RESOURCES_PATH .. "pointer.png")

	speakers:load()
	canvas:load()
	game:start()
end

local accumulator	= 0
function love.update(dt)
	-- pause the game by not updating
	if game.paused then return end

	local frameTime = math.min(dt, 0.166666667)
	accumulator = accumulator + frameTime

	while accumulator >= DELTA do
		speakers.sound.cleanup()
		-- update timers in the game, wherever they are
		game.timer.update(DELTA)
		-- check for collisions
		game.collider:update(DELTA)

		-- move stuff around
		for k,v in pairs(game.objects) do
			v:update(DELTA)
		end

		spawnEnemies(DELTA)

		camera:positionCamera(20, 50)

		accumulator = accumulator - DELTA
	end
end

local spawnTime = 0
local x =  0
function spawnEnemies(dt)
	spawnTime = spawnTime + dt

	if (spawnTime > x) then
		x = math.random()*4.55
		spawnTime = 0
		Enemy:new()
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

function love.draw()
	canvas:set()
	camera:set()

--	love.graphics.setColor(0,255,0,255)
--	love.graphics.draw(background, 0, 0)
	love.graphics.draw(pointer, 0, 200)

	for k,v in pairs(game.objects) do
		v:draw()
	end

	drawHUD()
	--print('Memory actually used (in kB): ' .. collectgarbage('count'))

	camera:unset()
	canvas:unset()
end

local row = 0

-- TODO: have a real HUD
function drawHUD()
	if not game.cat then return end
	local x1, y1, x2, y2 = game.cat.shape:bbox()

	printToHUD("w : " .. game:screenWidth())
	printToHUD("h : " .. game:screenHeight())
	printToHUD("p : (" ..
		string.format("%06.2f", x1) .. ", " ..
		string.format("%06.2f", y1) .. ")")
	printToHUD("fps : " .. love.timer.getFPS())
	printToHUD("v : (" ..
		string.format("%07.3f", game.cat.speed.x) .. ", " ..
		string.format("%07.3f", game.cat.speed.y) .. ")")

	local vector = vector.new()
	for k, force in pairs(game.cat.forces) do
		vector = vector + force
	end
	printToHUD("f : (" ..
		string.format("%012.3f", vector.x) .. ", " ..
		string.format("%012.3f", vector.y) .. ")")

	love.graphics.print("We choose to go to the moon. We choose to go to the moon in this decade and do the other things, not because they are easy, but because they are hard, because that goal will serve to organize and measure the best of our energies and skills, because that challenge is one that we are willing to accept, one we are unwilling to postpone, and one which we intend to win, and the others, too.", 100, 150)
	row = 0
end

function printToHUD(text)
	love.graphics.print(text, camera._x, camera._y + row)
	row = row + 10
end

function love.keypressed(key, unicode)
	keyboard:press(key)
end

function love.keyreleased(key)
	keyboard:release(key)
end

function love.mousepressed(x, y, button)
	mouse:press(button)
end

function love.mousereleased(x, y, button)
	mouse:release(button)
end

function love.focus(f)
	-- pause the game when out of focus
	game:pause(not f)
end