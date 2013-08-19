mouse = {}
mouse.keys = {}
mouse.keys.r = {}
mouse.keys.l = {}

local function attack()
	if not cat or game.paused then return end
	cat:attack()
end

local function afterAttack()
	if not cat then return end
	cat:afterAttack()
end

mouse.keys.l.pressed	= attack
mouse.keys.l.released	= afterAttack

function mouse:press(key)
	local key = mouse.keys[key]
	if key ~= nil and key.pressed ~= nil then key.pressed() end
end

function mouse:release(key)
	local key = mouse.keys[key]
	if key ~= nil and key.released ~= nil then key.released() end
end

function mouse.getPosition()
	return (vector.new(love.mouse.getPosition()) - canvas.offset) / canvas.scale
end
