Enemy = class('Enemy', LivingObject)
Enemy.sequence = 0

function Enemy:initialize(shape)
	Enemy.sequence = Enemy.sequence + 1
	LivingObject.initialize(self, 'Enemy#' .. Enemy.sequence, shape or
		collider:addRectangle(camera._x + 1100, camera._y + 300, 20, 20))
	collider:addToGroup('Enemies', self.shape)
	self.forces[WALK] = vector.new(self.direction*WALKING_FORCE, 0)
--	self.weapon = MeleeWeapon:new(self)
--	collider:addToGroup('Enemies', self.weapon.shape)
end

function Enemy:draw()
	self.shape:draw('line')
end

function Enemy:collide(otherObject)
	if otherObject == earth then
		-- add earth force to counter gravity
		self.forces[otherObject.name] = FORCES.EARTH

		-- apply collision affect on speed
		local restitution = 0.1
		self.speed.y = -restitution*self.speed.y
		self.speed.x = SURFACE_FRICTION*self.speed.x
	elseif otherObject == turtle or otherObject == cat or instanceOf(Weapon, otherObject) then
		local fx = 10*WALKING_FORCE
		if ((self.shape:center() < otherObject.shape:center()))then fx = -fx end
		self.speed.x = -0.1*self.speed.x
		-- apply otherObject's force on self
		self.forces[otherObject.name] = vector.new(fx, -WALKING_FORCE)
	end
end

function Enemy:rebound(otherObject)
	self.forces[otherObject.name] = nil
	if otherObject == turtle or otherObject == cat or instanceOf(Weapon, otherObject) then
		LivingObject.takeHit(self, otherObject.damage)
	end
end