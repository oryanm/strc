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

-- todo: collide based on angle
function GameObject:collide(otherObject)
	local selfLeft, selfTop, selfRight, selfBottom = self.shape:bbox()
	local otherLeft, otherTop, otherRight, otherBottom = otherObject.shape:bbox()

	-- if self's bottom is lower than other's top
	if selfBottom > otherTop then
		local halfOfHeightsSum = ((selfBottom - selfTop) + (otherBottom - otherTop)) / 2
		-- and self is at the top half of other
		if otherBottom - selfTop > halfOfHeightsSum then
			local overlap = math.floor(selfBottom - otherTop)
			-- if the overlap is big enough (moving cat when the overlap is too small will cause stuttering)
			if overlap > 1 then
				-- move cat back
				local centerX, centerY = self.shape:center()
				self:moveTo(centerX, centerY - overlap)
			end
		end
	end

	-- apply collision affect on speed
	self.speed = self.speed:permul(vector.new(SURFACE_FRICTION, -RESTITUTION))
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