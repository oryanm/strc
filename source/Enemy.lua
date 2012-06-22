require 'LivingObject'

Enemy = class('Enemy', LivingObject)
Enemy.sequence = 0

function Enemy:initialize(shape)
	LivingObject.initialize(self, shape)
	self.forces[game.gravity] = {x = 0, y = game.gravity}
	self.direction = DIRECTION.LEFT
	self.forces[WALK] = {x = self.direction*3000, y = 0}
	Enemy.sequence = Enemy.sequence + 1
	self.id = Enemy.sequence
end

function Enemy:draw()
	self.shape:draw("line")
end

function Enemy:collide(otherObject)
	if otherObject == earth then
		-- add earth force to counter gravity
		self.forces[otherObject] = {x = 0, y = -game.gravity}

		-- apply collision affect on speed
		local restitution = 0.1
		self.speed.y = -restitution*self.speed.y
		self.speed.x = SURFACE_FRICTION*self.speed.x
	elseif otherObject == turtle or otherObject == cat or instanceOf(Weapon, otherObject) then
		local fx = 10*WALKING_FORCE
		if ((self.shape:center() < otherObject.shape:center()))then fx = -fx end
		self.speed.x = -0.1*self.speed.x
		-- apply otherObject's force on self
		self.forces[otherObject] = {x = fx, y = -WALKING_FORCE}
	end
end

function Enemy:rebound(otherObject)
	self.forces[otherObject] = nil
	if otherObject == turtle or otherObject == cat or instanceOf(Weapon, otherObject) then
		LivingObject.takeHit(self, otherObject.damage)
	end
end

function Enemy:__tostring()
	return "Enemy#" .. self.id
end
