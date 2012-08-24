require 'GameObject'

LivingObject = class("LivingObject", GameObject)

function LivingObject:initialize(shape)
	GameObject.initialize(self, shape)
	self.health = 50
	self.damage = 10
	self.direction = DIRECTION.RIGHT
end

function LivingObject:update(dt)
	-- calculate acceleration
	local acceleration = self:calculateAcceleration()
	-- move to new position
	local delta = self:calculatePositionDelta(dt, acceleration)
	self.shape:move(delta.x, delta.y)

	if self.weapon ~= nil then
		self.weapon.shape:move(delta.x, delta.y)
	end

	-- calculate new speed
	self.speed = self:calculateSpeed(dt, acceleration)
end

function LivingObject:calculateAcceleration()
	local acceleration = {x = 0, y = 0}

	for k in pairs(self.forces) do
		acceleration.x = acceleration.x + self.forces[k].x
		acceleration.y = acceleration.y + self.forces[k].y
	end

	return acceleration
end

function LivingObject:calculatePositionDelta(dt, acceleration)
	local position = {x = 0, y = 0}

	position.x = self.speed.x * dt + (acceleration.x * dt * dt)/2
	position.y = self.speed.y * dt + (acceleration.y * dt * dt)/2

	return position
end

function LivingObject:calculateSpeed(dt, acceleration)
	local speed = {x = 0, y = 0}

	speed.x = math.clamp(AIR_FRICTION*self.speed.x + acceleration.x * dt, -self.maxSpeed.x, self.maxSpeed.x)
	speed.y = math.clamp(AIR_FRICTION*self.speed.y + acceleration.y * dt, -self.maxSpeed.y, self.maxSpeed.y)

	return speed
end

function LivingObject:attack()
	if self.weapon ~= nil then
		self.weapon:attack()
	end
end

function LivingObject:takeHit(damage)
	self.health = self.health - damage

	if self.health < 1 then
		self:die()
	end
end

function LivingObject:die()
	-- remove self from the world (the collider) and from the game
	collider:remove(self.shape)
	game.objects[tostring(self)] = nil

	if self.weapon ~= nil then
		collider:remove(self.weapon.shape)
		game.objects['weapon'] = nil
	end
end

function LivingObject:__tostring()
	return "this is an abstarct living object"
end
