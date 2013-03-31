keyboard = {}
keyboard.keys = {}
keyboard.keys.right		= {}
keyboard.keys.left 		= {}
keyboard.keys.up 			= {}
keyboard.keys[' '] 		= {}
keyboard.keys.e 			= {}
keyboard.keys.p				= {}
keyboard.keys.w				= {}
keyboard.keys.a				= {}
keyboard.keys.s				= {}
keyboard.keys.d				= {}
keyboard.keys.r				= {}
keyboard.keys.f11			= {}
keyboard.keys.lshift	= {}
keyboard.keys.escape 	= {}

local function moveRight()
	if not cat or game.paused then return end
	cat:moveRight()
end

local function moveLeft()
	if not cat or game.paused then return end
	cat:moveLeft()
end

local function jump()
	if not cat or game.paused then return end
	cat:jump()
end

local function afterMoveRight()
	if not cat then return end
	cat:afterMoveRight()
end

local function afterMoveLeft()
	if not cat then return end
	cat:afterMoveLeft()
end

local function afterJump()
	if not cat then return end
	cat:afterJump()
end

local function attack()
	if not cat or game.paused then return end
	cat:attack()
end

local function afterAttack()
	if not cat then return end
	cat:afterAttack()
end

local function toggleFullscreen()
	game:toggleFullscreen()
end

local function pauseGame()
	game:togglePause()
end

local function quitGame()
	game:quit()
end

local function spawnEnemy()
	Enemy:new()
end

local function resetGame()
	game:reset()
end

keyboard.keys.right.pressed		= moveRight
keyboard.keys.left.pressed 		= moveLeft
keyboard.keys.up.pressed 			= jump
keyboard.keys[' '].pressed 		= jump
keyboard.keys.e.pressed 			= attack
keyboard.keys.p.pressed				= pauseGame
keyboard.keys.w.pressed				= jump
keyboard.keys.a.pressed				= moveLeft
keyboard.keys.s.pressed				= spawnEnemy
keyboard.keys.d.pressed				= moveRight
keyboard.keys.r.pressed				= resetGame
keyboard.keys.escape.pressed 	= quitGame

keyboard.keys.right.released	= afterMoveRight
keyboard.keys.left.released		= afterMoveLeft
keyboard.keys.up.released			= afterJump
keyboard.keys[' '].released		= afterJump
keyboard.keys.e.released			= afterAttack
keyboard.keys.w.released			= afterJump
keyboard.keys.a.released			= afterMoveLeft
keyboard.keys.d.released			= afterMoveRight
keyboard.keys.f11.released		= toggleFullscreen

function keyboard:press(key)
	local key = keyboard.keys[key]
	if key ~= nil and key.pressed ~= nil then key.pressed() end
end

function keyboard:release(key)
	local key = keyboard.keys[key]
	if key ~= nil and key.released ~= nil then key.released() end
end