require 'GameObject'

Turtle = class('Turtle', GameObject)

function Turtle:initialize(shape)
	GameObject.initialize(self, shape)
	self.forces[game.gravity] = {x = 0, y = game.gravity}
end

function Turtle:update(dt)
	-- calculate acceleration
	local acceleration = {x = 0, y = 0}

	for k in pairs(self.forces) do
		acceleration.x = acceleration.x + self.forces[k].x
		acceleration.y = acceleration.y + self.forces[k].y
	end

	-- move to new position
	local position = {x = 0, y = 0}
	position.x = self.speed.x * dt + (acceleration.x * dt * dt)/2
	position.y = self.speed.y * dt + (acceleration.y * dt * dt)/2
	self.shape:move(position.x, position.y)

	-- calculate new speed
	self.speed.x = math.clamp(AIR_FRICTION*self.speed.x + acceleration.x * dt, -self.maxSpeed, self.maxSpeed)
	self.speed.y = math.clamp(AIR_FRICTION*self.speed.y + acceleration.y * dt, -self.maxSpeed, self.maxSpeed)
end

function Turtle:draw()
	self.shape:draw("fill")
end

function Turtle:collide(otherObject)
	if otherObject == earth then
		-- add earth force to counter gravity
		self.forces[otherObject] = {x = 0, y = -game.gravity}

		-- apply collision affect on speed
		local restitution = 0.1
		self.speed.y = -restitution*self.speed.y
		self.speed.x = SURFACE_FRICTION*self.speed.x
	end
end

function Turtle:rebound(otherObject)
	if otherObject == earth then
		self.forces[otherObject] = nil
	end
end

function Turtle:__tostring()
	return "Turtle"
end