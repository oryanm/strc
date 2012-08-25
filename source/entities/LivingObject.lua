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
	self.shape:move(delta:unpack())

	if self.weapon ~= nil then
		self.weapon.shape:move(delta:unpack())
	end

	-- calculate new speed
	self.speed = self:calculateSpeed(dt, acceleration)
end

function LivingObject:calculateAcceleration()
	local acceleration = vector.new()

	for k, force in pairs(self.forces) do
		acceleration = acceleration + force
	end

	return acceleration
end

function LivingObject:calculatePositionDelta(dt, acceleration)
	return self.speed * dt + (acceleration * dt * dt)/2
end

function LivingObject:calculateSpeed(dt, acceleration)
	local speed = self.speed + acceleration * dt
	speed.x = math.clamp(speed.x, -self.maxSpeed.x, self.maxSpeed.x)
	speed.y = math.clamp(speed.y, -self.maxSpeed.y, self.maxSpeed.y)

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
	GameObject.destroy(self)

	if self.weapon ~= nil then
		collider:remove(self.weapon.shape)
		game.objects['weapon'] = nil
	end
end

function LivingObject:__tostring()
	return "this is an abstarct living object"
end
