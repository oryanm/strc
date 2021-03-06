Cat = class('Cat', LivingObject)
Cat:include(Trailable)

function Cat:initialize(shape)
	LivingObject.initialize(self, 'Cat', shape or
		game.collider:addRectangle(400, 100, 44, 67))
	game.collider:addToGroup('Cats', self.shape)
	self.forces[GRAVITY] = FORCES.GRAVITY
	self.health = 100
	self.damage = 40
	self.team = TEAMS.GOODSIDE

	-- the time cat has been in the air
	self.jumpTime = 0

	self.weapons.long = Gun:new(self)
	game.collider:addToGroup('Cats', self.weapons.long.shape)
	self.weapons.melee = MeleeWeapon:new(self)
	game.collider:addToGroup('Cats', self.weapons.melee.shape)
	self.weapon = self.weapons.melee

	-- set the trail
	self.trail = {}
	self.maxSizeOfTrail = 100

	self.paralyzed = false
	self.locked = false
end

function Cat:update(dt)
	self:limitJump(dt)
	LivingObject.update(self, dt)
	self:checkForLock()
	self:addTrail()
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

function Cat:checkForLock()
	local x, y = game.turtle.shape:center()
	self.locked = self.shape:intersectsRay(x, y, 0, -1)
	if self.locked then
		local _, cy = self.shape:center()
		self:moveTo(x, cy)
		self.weapon = self.weapons.long
	end
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

function Cat:draw()
--	self.shape:draw("fill")
	self:drawTrail()

	local x1,y1, x2,y2 = self.shape:bbox()
	love.graphics.draw(cati, math.floor(x1), math.floor(y1))

	love.graphics.print("(" ..
		string.format("%.1f", x2) .. ", " ..
		string.format("%.1f", y2) .. ")", x2, y2)
end

function Cat:collide(otherObject)
	if LivingObject.collide(self, otherObject) == "UP" then
		-- reset jumping
		self.jumpTime = 0

		if otherObject == game.turtle then
			-- start walking
			game.turtle.forces[WALK] = FORCES.WALK
			self.forces[RIDE] = FORCES.RIDE
		end
	end

	if otherObject.team ~= TEAMS.NEUTRAL and self.team ~= otherObject.team then
		-- bump back
		self.speed.x = -RESTITUTION*self.speed.x
		self.forces[otherObject.name] = vector.new(math.sign(otherObject.shape:center() -
			self.shape:center()) * 10 * JUMPING_FORCE, JUMPING_FORCE)
	end
end

function Cat:rebound(otherObject)
	-- remove otherObject's force on self
	self.forces[otherObject.name] = nil

	if otherObject == game.turtle and not self.locked then
		-- stop walking
		game.turtle.forces[WALK] = nil
		self.forces[RIDE] = nil
	elseif otherObject.team ~= TEAMS.NEUTRAL and self.team ~= otherObject.team then
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

function Cat:destroy()
	LivingObject.destroy(self)
	game.cat = nil
end

function Cat:moveRight()
	if not self.paralyzed then
		if self.locked and self.jumpTime == 0 then
			self:unlock()
		end

		self.forces[MOVE_RIGHT] = FORCES.MOVE_RIGHT
		self.direction = DIRECTION.RIGHT
	end
end

function Cat:unlock()
	local x = game.turtle.shape:center()
	local _, cy = self.shape:center()
	-- launch cat off of turtle
	self:moveTo(x + 50, cy)
	self.forces[JUMP] = FORCES.JUMP
	game.timer.add(MAX_JUMP_TIME, function() self:afterJump() end)
	-- release the trigger and switch weapons
	self.weapon:safe()
	self.weapon = self.weapons.melee
	self.locked = false
	speakers:jumpSound()
end

function Cat:moveLeft()
	if not self.paralyzed then
		self.forces[MOVE_LEFT] = FORCES.MOVE_LEFT
		self.direction = DIRECTION.LEFT
	end
end

function Cat:jump()
	if not self.paralyzed and self.jumpTime == 0 then
		self.forces[JUMP] = FORCES.JUMP
		if self.jumpTime == 0 then
			speakers:jumpSound()
		end
	end
end

function Cat:afterMoveRight()
	self.forces[MOVE_RIGHT] = nil
end

function Cat:afterMoveLeft()
	self.forces[MOVE_LEFT] = nil
end

function Cat:afterJump()
	self.forces[JUMP] = nil
end

-- Trailable methods
function Cat:getTrail()
	return self.trail
end

function Cat:getMaxSizeOfTrail() return
	self.maxSizeOfTrail
end
