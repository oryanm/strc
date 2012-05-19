require 'LivingObject'

Enemy = class('Enemy', LivingObject)

function Enemy:initialize(shape)
	LivingObject.initialize(self, shape)
	self.forces[game.gravity] = {x = 0, y = game.gravity}
	self.forces['walk'] = {x = -3000, y = 0}
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
	elseif otherObject == turtle then
		self:die()
	end
end

function Enemy:rebound(otherObject)
	if otherObject == earth then
		self.forces[otherObject] = nil
	end
end

function Enemy:__tostring()
	return "Enemy"
end
