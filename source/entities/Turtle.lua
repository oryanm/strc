Turtle = class('Turtle', LivingObject)

function Turtle:initialize(shape)
	LivingObject.initialize(self, 'Turtle', shape or
		game.collider:addRectangle(50, 300, 200, 100))
	self.direction = DIRECTION.RIGHT
	self.health = 50
	self.team = TEAMS.GOODSIDE
end

function Turtle:draw()
	self.shape:draw("fill")
end

function Turtle:collide(otherObject)
	-- turtle is a mostly passive and only collides with the earth
	if otherObject == game.earth then
		LivingObject.collide(self, otherObject)
	end
end

function Turtle:rebound(otherObject)
	self.forces[otherObject.name] = nil

	if otherObject.team ~= TEAMS.NEUTRAL and self.team ~= otherObject.team then
		self:takeHit(otherObject.damage)
	end
end

function Turtle:destroy()
	if game.cat then game.cat:destroy() end
	LivingObject.destroy(self)
	game.turtle = nil
end