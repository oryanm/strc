Object = {}
Object.forces = {}
Object.speed =
{
	x = 0,
	y = 0
}
Object.maxSpeed = 300

function Object:new(shape)
	local object = {}
	setmetatable(object, self)
	self.__index = self
	shape = shape or {}
	shape.object = object
	object.shape = shape
	return object
end

function Object:update(dt)
	self.shape:move(0,0)
end

function Object:collide(otherObject)
end

function Object:rebound(otherObject)
end

function Object:draw()
	self.shape:draw("line")
end


function Object:__tostring()
	return "this is an abstarct object"
end




Turtle = Object:new(shape)
Turtle.forces = {}
Turtle.speed =
{
	x = 30,
	y = 0
}

function Turtle:update(dt)
	-- calculate acceleration
	local acceleration = {x = 0, y = 0}

	for k in pairs(self.forces) do
		acceleration.x = acceleration.x + self.forces[k].x
		acceleration.y = acceleration.y + self.forces[k].y
	end

	-- move to new position
	local position = {x = 0, y = 0}
	position.x = self.speed.x * dt + (acceleration.x * dt * dt)/2
	position.y = self.speed.y * dt + (acceleration.y * dt * dt)/2
	self.shape:move(position.x, position.y)

	-- calculate new speed
	self.speed.x = math.clamp(AIR_FRICTION*self.speed.x + acceleration.x * dt, -self.maxSpeed, self.maxSpeed)
	self.speed.y = math.clamp(AIR_FRICTION*self.speed.y + acceleration.y * dt, -self.maxSpeed, self.maxSpeed)
end

function Turtle:collide(otherObject)
	if otherObject == earth then
		-- add earth force to counter gravity
		self.forces[otherObject] = {x = 0, y = -game.gravity}

		-- apply collision affect on speed
		local restitution = 0.1
		self.speed.y = -restitution*self.speed.y
		self.speed.x = SURFACE_FRICTION*self.speed.x
	end
end

function Turtle:rebound(otherObject)
	if otherObject == earth then
		self.forces[otherObject] = nil
	end
end

function Turtle:draw()
	self.shape:draw("fill")
end


jumpDt=0

Cat = Object:new(shape)
Cat.forces = {}
Cat.jumpTime = 0
Cat.speed =
{
	x = 0,
	y = 0
}

function Cat:update(dt)
	-- limit jump
	self.jumpTime = self.jumpTime + dt
	if (self.jumpTime > MAX_JUMP_TIME) then self.forces[SPACE] = nil end

	-- calculate acceleration
	local acceleration = {x = 0, y = 0}

	for k in pairs(self.forces) do
		--print("force " .. --[[tostring(k) ..]] ": " ..  self.forces[k].x)
		acceleration.x = acceleration.x + self.forces[k].x
		acceleration.y = acceleration.y + self.forces[k].y
	end

	-- move to new position
	local position = {x = 0, y = 0}
	local x1,y1, x2,y2 = self.shape:bbox()
	position.x = self.speed.x * dt + (acceleration.x * dt * dt)/2
	position.y = self.speed.y * dt + (acceleration.y * dt * dt)/2

	-- bound the cat in the screen (horizontally)
	-- vertically the cat will be bounded by earth and gravity
	if (x1+position.x > (camera._x + game:screenWidth()) -(x2-x1)) then
		position.x=-1
		self.speed.x = -0.1*self.speed.x
	elseif (x1+position.x < camera._x) then
		position.x=1
		self.speed.x = -0.1*self.speed.x
	end

	self.shape:move(position.x, position.y)

	-- calculate new speed
	self.speed.x = math.clamp(AIR_FRICTION*self.speed.x + acceleration.x * dt, -self.maxSpeed, self.maxSpeed)
	self.speed.y = math.clamp(AIR_FRICTION*self.speed.y + acceleration.y * dt, -self.maxSpeed, self.maxSpeed)
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
	elseif otherObject == turtle then
		self.forces[otherObject] = nil
		-- stop walking
		turtle.forces["walk"] = nil
		self.forces["ride"] = nil
	end
end

function Cat:draw()
	self.shape:draw("fill")
end


return Object

--float accel = gravity - drag;
--transform.position.z += currentVelocity * Time.deltaTime + 0.5f * accel * Time.deltaTime * Time.deltaTime;
--currentVelocity += accel * Time.deltaTime;
