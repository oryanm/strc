LivingObject = class("LivingObject", GameObject)

function LivingObject:initialize(name, shape)
	GameObject.initialize(self, name, shape)
	-- a living object has hp, dp and a direction in life
	self.health = 50
	self.damage = 10
	self.direction = DIRECTION.LEFT
	self.forces[GRAVITY] = FORCES.GRAVITY
	self.weapons = {}
end

function LivingObject:update(dt)
	-- calculate acceleration
	local acceleration = self:calculateAcceleration()
	-- calculate new speed
	self.speed = self:calculateSpeed(dt, acceleration)
	-- move to new position
	self:move(self:calculatePositionDelta(dt, acceleration))
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
	-- (s = s + a*t) and s is in [-max s, max s]
	return math.clampv(self.speed + acceleration * dt, -self.maxSpeed, self.maxSpeed)
end

function LivingObject:move(vector)
	local x, y = vector:unpack()
	self.shape:move(x, y)

	-- move all attached objects as well
	for _, v in pairs(self.weapons) do
		v.shape:move(x, y)
	end
end

function LivingObject:moveTo(x, y)
	local cx, cy = self.shape:center()
	self:move(vector.new(x - cx, y - cy))
end

function LivingObject:attack()
	if self.weapon ~= nil then
		self.weapon:attack()
	end
end

function LivingObject:afterAttack()
	if self.weapon ~= nil then
		self.weapon:afterAttack()
	end
end

function LivingObject:takeHit(damage)
	self.health = self.health - damage
	speakers:hitSound()

	if self.health < 1 then
		self:destroy()
		speakers:deathSound()
	end
end

function LivingObject:destroy()
	for _, v in pairs(self.weapons) do
		v:destroy()
	end

	GameObject.destroy(self)
end