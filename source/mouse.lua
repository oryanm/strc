mouse = {}
mouse.keys = {}
mouse.keys.r = {}
mouse.keys.l = {}

local function attack()
	cat:attack()
end

local function afterAttack()
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
