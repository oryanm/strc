Turtle = class('Turtle', LivingObject)

function Turtle:initialize(shape)
	LivingObject.initialize(self, 'Turtle', shape or
		collider:addRectangle(50, 300, 100, 70))
	self.direction = DIRECTION.RIGHT
end

function Turtle:draw()
	self.shape:draw("fill")
end

function Turtle:collide(otherObject)
	if otherObject == earth then
		-- add earth force to counter gravity
		self.forces[otherObject.name] = FORCES.EARTH

		-- apply collision affect on speed
		local restitution = 0.1
		self.speed.y = -restitution*self.speed.y
		self.speed.x = SURFACE_FRICTION*self.speed.x
	end
end

function Turtle:rebound(otherObject)
	self.forces[otherObject.name] = nil
end