require 'GameObject'

LivingObject = class("LivingObject", GameObject)

function LivingObject:initialize(shape)
	GameObject.initialize(self, shape)
	self.health = 10
end

function LivingObject:update(dt)
	-- calculate acceleration
	local acceleration = self:calculateAcceleration()
	-- move to new position
	self.shape:move(self:calculatePosition(dt, acceleration))
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

function LivingObject:calculatePosition(dt, acceleration)
	local position = {x = 0, y = 0}

	position.x = self.speed.x * dt + (acceleration.x * dt * dt)/2
	position.y = self.speed.y * dt + (acceleration.y * dt * dt)/2

	return position.x, position.y
end

function LivingObject:calculateSpeed(dt, acceleration)
	local speed = {x = 0, y = 0}

	speed.x = math.clamp(AIR_FRICTION*self.speed.x + acceleration.x * dt, -self.maxSpeed, self.maxSpeed)
	speed.y = math.clamp(AIR_FRICTION*self.speed.y + acceleration.y * dt, -self.maxSpeed, self.maxSpeed)

	return speed
end

function LivingObject:die()
	collider:remove(self.shape)
	game.objects[self:__tostring()] = nil
end

function LivingObject:__tostring()
	return "this is an abstarct living object"
end
