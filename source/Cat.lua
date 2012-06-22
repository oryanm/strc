require 'LivingObject'
require 'Trailable'
require 'Weapon'

Cat = class('Cat', LivingObject)
Cat:include(Trailable)

function Cat:initialize(shape)
	LivingObject.initialize(self, shape)
	self.forces[game.gravity] = {x = 0, y = game.gravity}
	self.jumpTime = 0
	self.health = 100

	self.weapon = Weapon:new(collider:addRectangle(900, 300, 5, 30), self)
	game.objects['weapon'] = self.weapon
	local x,y = self.shape:center()
	self.weapon.shape:moveTo(x, y-50)

	-- the time self has been paralyzed.
	-- -1 when self is not paralyzed
	self.paralyzeTime = -1
end

function Cat:update(dt)
	self:paralyze(dt)
	self:limitJump(dt)
	LivingObject.update(self, dt)
	self:addTrail()
end

function Cat:paralyze(dt)
	if (self.paralyzeTime >= 0) then
		-- update paralyze time
		self.paralyzeTime = self.paralyzeTime + dt

		-- paralyze self by disabling all player applied forces
		for i, force in pairs(PLAYER_APPLIED_FORCES) do
			self.forces[force] = nil
		end

		-- if time is up
		if self.paralyzeTime > HIT_PARALIZE_TIME then
			-- reset the time
			self.paralyzeTime = -1

			-- add the appropriate forces for every pressed key
			for i, force in pairs(PLAYER_APPLIED_FORCES) do
				if love.keyboard.isDown( force ) then
					self.forces[force] = FORCES[i]
				end
			end
		end
	end
end

function Cat:limitJump(dt)
	if not (self.forces[JUMP] == nil) then
		-- update jump time when jumping
		self.jumpTime = self.jumpTime + dt
		-- by the time self.jumpTime is 10%,20%,..,100% of MAX_JUMP_TIME
		-- this will reduce the jump force by 10%,20%,..,100%
		self.forces[JUMP].y = math.clamp(
			self.forces[JUMP].y - ((JUMPING_FORCE * dt) / MAX_JUMP_TIME), self.forces[JUMP].y, 0)
	end

	-- stop jump force when max jump time reached
	if (self.jumpTime > MAX_JUMP_TIME) then
		self.forces[JUMP] = nil
	end
end

function Cat:calculatePosition(dt, acceleration)
	local position = {x = 0, y = 0}
	local x1,y1, x2,y2 = self.shape:bbox()

	position.x, position.y = LivingObject.calculatePosition(self, dt, acceleration)

	-- bound the cat in the screen (horizontally)
	-- vertically the cat will be bounded by earth and gravity
	if (x1+position.x > (camera._x + game:screenWidth()) -(x2-x1)) then
		position.x=-1
		self.speed.x = -0.1*self.speed.x
	elseif (x1+position.x < camera._x) then
		position.x=1
		self.speed.x = -0.1*self.speed.x
	end

	return position.x, position.y
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
	if otherObject == earth then
		-- add earth force to counter gravity
		self.forces[otherObject] = {x = 0, y = -game.gravity}

		-- apply collision affect on speed
		self.speed.y = -0.1*self.speed.y
		self.speed.x = SURFACE_FRICTION*self.speed.x

		-- reset jumping
		self.jumpTime = 0
	elseif instanceOf(Enemy, otherObject) then
		local fx = 10*JUMPING_FORCE
		if ((self.shape:center() > otherObject.shape:center()))then fx = -fx end
		self.speed.x = -0.1*self.speed.x
		-- apply otherObject's force on self
		self.forces[otherObject] = {x = fx, y = JUMPING_FORCE}
	elseif otherObject == turtle then
		local ccx, ccy = self.shape:center()
		local x1, y1, x2, y2 = self.shape:bbox()
		local ch = y2 - y1
		local tcx, tcy = otherObject.shape:center()
		local x1, y1, x2, y2 = otherObject.shape:bbox()
		local th = y2 - y1
		local fx, fy = 0, 0

		-- if cat is directly above turtle
		if ((ccy + (ch/2) - 5) < (tcy - (th/2))) then
			-- add force to counter gravity
			fy = -game.gravity
			-- apply collision affect on speed
			self.speed.y = -0.1*self.speed.y
			self.speed.x = SURFACE_FRICTION*self.speed.x

			-- reset jumping
			self.jumpTime = 0

			-- start walking
			turtle.forces[WALK] = {x = WALKING_FORCE, y = 0}
			self.forces[RIDE] = {x = WALKING_FORCE, y = 0}
		-- if cat is to turtle's side
		else
			fx = RUNNING_FORCE
			if ccx < tcx then fx = -fx end
			self.speed.x = -0.1*self.speed.x
		end

		-- apply otherObject's force on self
		self.forces[otherObject] = {x = fx, y = fy}
	end
end

function Cat:rebound(otherObject)
	-- remove otherObject's force on self
	self.forces[otherObject] = nil

	if otherObject == turtle then
		-- stop walking
		turtle.forces[WALK] = nil
		self.forces[RIDE] = nil
	elseif instanceOf(Enemy, otherObject) then
		-- paralyze self
		self.paralyzeTime = 0
		LivingObject.takeHit(self, otherObject.damage)
	end
end

function Cat:__tostring()
	return "Cat"
end