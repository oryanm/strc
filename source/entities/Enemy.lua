Enemy = class('Enemy', LivingObject)
Enemy.sequence = 0

function Enemy:initialize(shape)
	Enemy.sequence = Enemy.sequence + 1
	LivingObject.initialize(self, 'Enemy#' .. Enemy.sequence, shape or
		game.collider:addRectangle(camera._x + 1100, camera._y + 300, 20, 20))
	game.collider:addToGroup('Enemies', self.shape)
	self.forces[WALK] = vector.new(self.direction*WALKING_FORCE, 0)
	self.team = TEAMS.DARKSIDE
end

function Enemy:collide(otherObject)
	LivingObject.collide(self, otherObject)
	local f

	if otherObject == game.earth then
		-- add earth force to counter gravity
		f = FORCES.EARTH
	elseif otherObject.team ~= TEAMS.NEUTRAL and self.team ~= otherObject.team then
		-- bump back
		self.speed.x = -RESTITUTION*self.speed.x
		f = vector.new(math.sign(otherObject.shape:center() -
			self.shape:center()) * 10 * JUMPING_FORCE, JUMPING_FORCE)
	end

	-- apply otherObject's force on self
	self.forces[otherObject.name] = f
end

function Enemy:rebound(otherObject)
	self.forces[otherObject.name] = nil
	if otherObject.team ~= TEAMS.NEUTRAL and self.team ~= otherObject.team then
		LivingObject.takeHit(self, otherObject.damage)
	end
end