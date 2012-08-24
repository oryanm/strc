require('Enemy')

keyboard = {}
keyboard.keys = {}
keyboard.keys.right		= {}
keyboard.keys.left 		= {}
keyboard.keys.up 			= {}
keyboard.keys[' '] 		= {}
keyboard.keys.z 			= {}
keyboard.keys.p				= {}
keyboard.keys.s				= {}
keyboard.keys.f11			= {}
keyboard.keys.escape 	= {}

local function moveRight()
	cat.forces[MOVE_RIGHT] = vector.new(RUNNING_FORCE, 0)
	cat.direction = DIRECTION.RIGHT
end

local function moveLeft()
	cat.forces[MOVE_LEFT] = vector.new(-RUNNING_FORCE, 0)
	cat.direction = DIRECTION.LEFT
end

local function jump()
	cat.forces[JUMP] = vector.new(0, JUMPING_FORCE)
end

local function afterMoveRight()
	cat.forces[MOVE_RIGHT] = nil
end

local function afterMoveLeft()
	cat.forces[MOVE_LEFT] = nil
end

local function afterJump()
	cat.forces[JUMP] = nil
end

local function attack()
	cat:attack()
end

local function toggleFullscreen()
	game:toggleFullscreen()
end

local function pauseGame()
	game.pause = not game.pause
end

local function quitGame()
	love.event.push('quit')
end

local function spawnEnemy()
	Enemy.spawn()
end

keyboard.keys.right.pressed		= moveRight
keyboard.keys.left.pressed 		= moveLeft
keyboard.keys.up.pressed 			= jump
keyboard.keys[' '].pressed 		= jump
keyboard.keys.z.pressed 			= attack
keyboard.keys.p.pressed				= pauseGame
keyboard.keys.s.pressed				= spawnEnemy
keyboard.keys.escape.pressed 	= quitGame

keyboard.keys.right.released	= afterMoveRight
keyboard.keys.left.released		= afterMoveLeft
keyboard.keys.up.released			= afterJump
keyboard.keys[' '].released		= afterJump
keyboard.keys.f11.released		= toggleFullscreen

function keyboard:press(key)
	local key = keyboard.keys[key]
	if key ~= nil and key.pressed ~= nil then key.pressed() end
end

function keyboard:release(key)
	local key = keyboard.keys[key]
	if key ~= nil and key.released ~= nil then key.released() end
end