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
	local f

	if otherObject == earth then
		-- add earth force to counter gravity
		f = FORCES.EARTH
		-- apply collision affect on speed
		self.speed = self.speed:permul(vector.new(SURFACE_FRICTION, -RESTITUTION))
	elseif otherObject == turtle or otherObject == cat or
		instanceOf(Weapon, otherObject) or instanceOf(Projectile, otherObject) then
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
	if otherObject == turtle or otherObject == cat or
		instanceOf(Weapon, otherObject) or instanceOf(Projectile, otherObject) then
		LivingObject.takeHit(self, otherObject.damage)
	end
end