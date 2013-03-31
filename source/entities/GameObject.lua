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
	self.maxSpeed = vector.new(400, 1200)
	self.team = TEAMS.NEUTRAL
end

function GameObject:update(dt)
end

function GameObject:draw()
	self.shape:draw("line")
end

function GameObject:collide(otherObject)
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
		collider:addRectangle(0, game:mapHeight() - 20, game:mapWidth(), 20))
	collider:setPassive(self.shape)
end