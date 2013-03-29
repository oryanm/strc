Cat = class('Cat', LivingObject)
Cat:include(Trailable)

function Cat:initialize(shape)
	LivingObject.initialize(self, 'Cat', shape or
		collider:addRectangle(400, 100, 20, 20))
	collider:addToGroup('Cats', self.shape)
	self.forces[GRAVITY] = FORCES.GRAVITY
	self.health = 100
	self.damage = 40

	-- the time cat has been in the air
	self.jumpTime = 0

	self.weapons.long = Gun:new(self)
	collider:addToGroup('Cats', self.weapons.long.shape)
	self.weapons.melee = MeleeWeapon:new(self)
	collider:addToGroup('Cats', self.weapons.melee.shape)
	self.weapon = self.weapons.melee

	-- set the trail
	self.trail = {}
	self.maxSizeOfTrail = 100

	self.paralyzed = false
	self.locked = false
end

function Cat:update(dt)
	LivingObject.update(self, dt)
	self:checkForLock()
	self:limitJump(dt)
	self:addTrail()
end

function Cat:checkForLock()
	local x, y = turtle.shape:center()
	self.locked = self.shape:intersectsRay(x, y, 0, -1)
	if self.locked then
		local _, cy = self.shape:center()
		self:moveTo(x, cy)
		self.weapon = self.weapons.long
	end
end

function Cat:unlock()
	local x = turtle.shape:center()
	local _, cy = self.shape:center()
	-- launch cat off of turtle
	self:moveTo(x + 20, cy)
	self.forces[JUMP] = FORCES.JUMP
	-- release the trigger and switch weapons
	self.weapon:safe()
	self.weapon = self.weapons.melee
	self.locked = false
	speakers:jumpSound()
end

function Cat:limitJump(dt)
	if (self.forces[JUMP] ~= nil) then
		-- update jump time when jumping
		self.jumpTime = self.jumpTime + dt
		-- by the time self.jumpTime is 10%,20%,..,100% of MAX_JUMP_TIME
		-- this will reduce the jump force by 10%,20%,..,100%
		local y = self.forces[JUMP].y - ((JUMPING_FORCE * dt) / MAX_JUMP_TIME)
		self.forces[JUMP] = vector.new(self.forces[JUMP].x, math.min(y, 0))
	end

	-- stop jump force when max jump time reached
	if (self.jumpTime > MAX_JUMP_TIME) then
		self.forces[JUMP] = nil
	end
end

function Cat:calculatePositionDelta(dt, acceleration)
	return self:boundToScreen(
		LivingObject.calculatePositionDelta(self, dt, acceleration))
end

-- bound the cat in the screen (horizontally)
-- vertically the cat will be bounded by earth and gravity
function Cat:boundToScreen(positionDelta)
	local x1, y1, x2, y2 = self.shape:bbox()

	-- if out of bounds
	if ((x1 + positionDelta.x) < camera._x) or
		((x2 + positionDelta.x) > (camera._x + game:screenWidth())) then
		-- reverse and reduce speed
		self.speed.x = -RESTITUTION*self.speed.x
		-- bump cat back against the screen
		positionDelta.x = self.speed.x > 0 and 1 or -1
	end

	return positionDelta
end

function Cat:draw()
	self.shape:draw("fill")
	self:drawTrail()

	local x1,y1, x2,y2 = self.shape:bbox()
	love.graphics.print("(" ..
		string.format("%.1f", x1) .. ", " ..
		string.format("%.1f", y1) .. ")", x2, y2)
end

function Cat:collide(otherObject)
	local f

	if otherObject == earth then
		f = self:collideWithEarth()
	elseif instanceOf(Enemy, otherObject) or instanceOf(Weapon, otherObject) or
		instanceOf(Projectile, otherObject) then
		-- bump back
		self.speed.x = -RESTITUTION*self.speed.x
		f = vector.new(math.sign(otherObject.shape:center() -
			self.shape:center()) * 10 * JUMPING_FORCE, JUMPING_FORCE)
	elseif otherObject == turtle then
		f = self:collideWithTurtle(otherObject)
	end

	-- apply otherObject's force on self
	self.forces[otherObject.name] = f
end

function Cat:collideWithEarth()
	-- apply collision affect on speed
	self.speed = self.speed:permul(vector.new(SURFACE_FRICTION, -RESTITUTION))
	-- reset jumping
	self.jumpTime = 0

	-- add earth force to counter gravity
	return FORCES.EARTH
end

function Cat:collideWithTurtle(otherObject)
	local ccx, ccy = self.shape:center()
	local _, y1, _, y2 = self.shape:bbox()
	local ch = y2 - y1
	local tcx, tcy = otherObject.shape:center()
	local _, y1, _, y2 = otherObject.shape:bbox()
	local th = y2 - y1

	-- if cat is directly above turtle
	if ((ccy + (ch/2) - 6) < (tcy - (th/2))) then
		-- start walking
		turtle.forces[WALK] = FORCES.WALK
		self.forces[RIDE] = FORCES.RIDE

		-- same effect as colliding with earth
		return self:collideWithEarth()
	-- if cat is to turtle's side
	else
		self.speed.x = -RESTITUTION*self.speed.x

		return ccx < tcx and FORCES.MOVE_LEFT or FORCES.MOVE_RIGHT
	end
end

function Cat:rebound(otherObject)
	-- remove otherObject's force on self
	self.forces[otherObject.name] = nil

	-- TODO: bug: unlocking while jumping doesn't stop turtle's walking
	if otherObject == turtle and not self.locked then
		-- stop walking
		turtle.forces[WALK] = nil
		self.forces[RIDE] = nil
	elseif instanceOf(Enemy, otherObject) or instanceOf(Projectile, otherObject) then
		self:takeHit(otherObject.damage)
	end
end

function Cat:takeHit(damage)
	LivingObject.takeHit(self, damage)
	self:paralyze()
end

function Cat:paralyze()
	-- paralyze self for HIT_PARALYZE_TIME
	self.paralyzed = true
	game.timer.add(HIT_PARALYZE_TIME, function() self.paralyzed = false end)

	-- disable all player applied forces
	for _, force in pairs(PLAYER_APPLIED_FORCES) do
		self.forces[force.key] = nil
	end
end

-- Trailable methods
function Cat:getTrail()
	return self.trail
end

function Cat:getMaxSizeOfTrail() return
	self.maxSizeOfTrail
end
