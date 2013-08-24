Projectile = class('Projectile', GameObject)
Projectile.sequence = 0

function Projectile:initialize(owner, target, shape)
	Projectile.sequence = Projectile.sequence + 1
	GameObject.initialize(self, 'Projectile' .. '#' .. Projectile.sequence,
		shape or collider:addPoint(camera._x + 100, camera._y + 300))
	collider:copyGroups(owner.shape, self.shape)
	self.team = owner.team
	self.damage = 10
	-- the position self wants to go to
	self.target = target
	self.range = PROJECTILE_RANGE
	self.startingPosition = vector.new(self.shape:center())
	-- a step is the product of the normalized direction vector and the projectile speed
	-- i.e the projectile takes a step every frame in said direction and speed
	self.step = (self.target - self.startingPosition):normalized()*PROJECTILE_SPEED
end

function Projectile:update(dt)
	if vector.new(self.shape:center()):dist(self.startingPosition) > self.range then
		self:destroy()
	else
		-- move towards the target
		self.shape:move((self.step * dt):unpack())
	end
end

function Projectile:collide(otherObject)
end

function Projectile:rebound(otherObject)
	self:destroy()
end

