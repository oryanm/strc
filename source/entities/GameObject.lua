GameObject = class("GameObject")

function GameObject:initialize(name, shape)
	self.name = name
	-- add self to the game
	game.objects[name] = self
	-- set self's physical shape
	self.shape = shape
	shape.object = self
	-- every game object has an array of
	-- forces working on him and current speed
	self.forces = {}
	self.speed = vector.new()
	self.maxSpeed = MAX_SPEED
	self.team = TEAMS.NEUTRAL
end

function GameObject:update(dt)
end

function GameObject:draw()
	self.shape:draw("line")
end

function GameObject:move(vector)
	local x, y = vector:unpack()
	self.shape:move(x, y)
end

function GameObject:moveTo(x, y)
	local cx, cy = self.shape:center()
	self:move(vector.new(x - cx, y - cy))
end

function GameObject:collide(otherObject)
	local selfLeft, selfTop, selfRight, selfBottom = self.shape:bbox()
	local otherLeft, otherTop, otherRight, otherBottom = otherObject.shape:bbox()

	local angle = math.angleBetweenObjects(otherObject, self)
	local center = vector.new(otherObject.shape:center())
	local topRight = math.angle(center, vector.new(otherRight, otherTop))
	local topLeft = math.angle(center, vector.new(otherLeft, otherTop))
	local bottmRight = math.angle(center, vector.new(otherRight, otherBottom))
	local bottomLeft = math.angle(center, vector.new(otherLeft, otherBottom))

	local result

	-- todo: handel Points better
	if instanceOf(Projectile, otherObject) then
		return "DOWN"
	end


	if angle > topRight or angle < topLeft then
		result="UP"
		local overlap = math.floor(selfBottom - otherTop)
		-- if the overlap is big enough (moving cat when the overlap is too small will cause stuttering)
		if overlap > 1 then
			-- move cat back
			local centerX, centerY = self.shape:center()
			self:moveTo(centerX, centerY - overlap)
		end

		self.forces[otherObject.name] = FORCES.EARTH
	elseif angle < topRight and angle > bottmRight then
		result="RIGHT"
		self.forces[otherObject.name] = FORCES.MOVE_RIGHT + vector.new(20000,0)
	elseif angle > topLeft and angle < bottomLeft then
		result="LEFT"
		self.forces[otherObject.name] = FORCES.MOVE_LEFT + vector.new(-20000,0)
	else
		result="DOWN"
	end

	-- apply collision affect on speed
	self.speed = self.speed:permul(vector.new(SURFACE_FRICTION, -RESTITUTION))

	return result
end

function GameObject:rebound(otherObject)
end

function GameObject:destroy()
	-- remove self from the world (the collider) and from the game
	collider:remove(self.shape)
	game.objects[self.name] = nil
end

function GameObject:__tostring()
	return self.name
end


Earth = class('Earth', GameObject)

function Earth:initialize(shape)
	GameObject.initialize(self, 'Earth', shape or
		collider:addRectangle(0, game:mapHeight() - 20, game:mapWidth(), 100))
	collider:setPassive(self.shape)
end