require 'LivingObject'

Cat = class('Cat', LivingObject)

function Cat:initialize(shape)
	LivingObject.initialize(self, shape)
	self.forces[game.gravity] = {x = 0, y = game.gravity}
	self.jumpTime = 0
end

function Cat:update(dt)
	-- limit jump
	self.jumpTime = self.jumpTime + dt
	if (self.jumpTime > MAX_JUMP_TIME) then self.forces[SPACE] = nil end

	LivingObject.update(self, dt)
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

		local ccx, ccy = self.shape:center()
		local x1, y1, x2, y2 = self.shape:bbox()
		local cw , ch = x2 - x1, y2 - y1
		local tcx, tcy = otherObject.shape:center()
		local x1, y1, x2, y2 = otherObject.shape:bbox()
		local tw , th = x2 - x1, y2 - y1
		local fx, fy = 0, 0

		if ((ccx > tcx) and ((ccx - cw/2) < (tcx + tw/2))) then
			fx = -50*JUMPING_FORCE
			fy = 50*JUMPING_FORCE
			self.speed.x = -self.speed.x
		elseif ((ccx < tcx) and ((ccx + cw/2) > (tcx - tw/2))) then
			fx = 50*JUMPING_FORCE
			fy = 50*JUMPING_FORCE
			self.speed.x = -self.speed.x
		end

		-- apply otherObject's force on self
		self.forces[otherObject] = {x = fx, y = fy}


	elseif otherObject == turtle then
		local ccx, ccy = self.shape:center()
		local x1, y1, x2, y2 = self.shape:bbox()
		local cw , ch = x2 - x1, y2 - y1
		local tcx, tcy = otherObject.shape:center()
		local x1, y1, x2, y2 = otherObject.shape:bbox()
		local tw , th = x2 - x1, y2 - y1
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
			turtle.forces["walk"] = {x = WALKING_FORCE, y = 0}
			self.forces["ride"] = {x = WALKING_FORCE, y = 0}
			-- if cat is to turtle's right
		elseif ((ccx > tcx) and ((ccx - cw/2) < (tcx + tw/2))) then
			fx = RUNNING_FORCE
			self.speed.x = -0.1*self.speed.x
			-- if cat is to turtle's left
		elseif ((ccx < tcx) and ((ccx + cw/2) > (tcx - tw/2))) then
			fx = -RUNNING_FORCE
			self.speed.x = -0.1*self.speed.x
		end

		-- apply otherObject's force on self
		self.forces[otherObject] = {x = fx, y = fy}
	end
end

function Cat:rebound(otherObject)
	-- remove otherObject's force on self
	if otherObject == earth then
		self.forces[otherObject] = nil
	elseif instanceOf(Enemy, otherObject) then
		self.forces[otherObject] = nil
	elseif otherObject == turtle then
		self.forces[otherObject] = nil
		-- stop walking
		turtle.forces["walk"] = nil
		self.forces["ride"] = nil
	end
end

function Cat:__tostring()
	return "Cat"
end