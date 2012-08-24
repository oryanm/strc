require 'LivingObject'

Turtle = class('Turtle', LivingObject)

function Turtle:initialize(shape)
	LivingObject.initialize(self, shape)
	self.forces[GRAVITY] = FORCES.GRAVITY
end

function Turtle:draw()
	self.shape:draw("fill")
end

function Turtle:collide(otherObject)
	if otherObject == earth then
		-- add earth force to counter gravity
		self.forces[tostring(otherObject)] = FORCES.EARTH

		-- apply collision affect on speed
		local restitution = 0.1
		self.speed.y = -restitution*self.speed.y
		self.speed.x = SURFACE_FRICTION*self.speed.x
	end
end

function Turtle:rebound(otherObject)
	self.forces[tostring(otherObject)] = nil
end

function Turtle:__tostring()
	return "Turtle"
end