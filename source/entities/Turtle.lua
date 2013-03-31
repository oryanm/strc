Turtle = class('Turtle', LivingObject)

function Turtle:initialize(shape)
	LivingObject.initialize(self, 'Turtle', shape or
		collider:addRectangle(50, 300, 100, 70))
	self.direction = DIRECTION.RIGHT
	self.health = 50
	self.team = TEAMS.GOODSIDE
end

function Turtle:draw()
	self.shape:draw("fill")
end

function Turtle:collide(otherObject)
	if otherObject == earth then
		-- add earth force to counter gravity
		self.forces[otherObject.name] = FORCES.EARTH
		-- apply collision affect on speed
		self.speed = self.speed:permul(vector.new(SURFACE_FRICTION, -RESTITUTION))
	end
end

function Turtle:rebound(otherObject)
	self.forces[otherObject.name] = nil

	if otherObject.team ~= TEAMS.NEUTRAL and self.team ~= otherObject.team then
		self:takeHit(otherObject.damage)
	end
end