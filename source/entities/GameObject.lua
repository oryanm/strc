GameObject = class("GameObject")

function GameObject:initialize(shape)
	self.shape = shape
	shape.object = self
	self.forces = {}
	self.speed = vector.new()
	self.maxSpeed = vector.new(300, 600)
	self.damage = 0
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
	game.objects[tostring(self)] = nil
end

function GameObject:__tostring()
	return "this is an abstarct game object"
end


Earth = class('Earth', GameObject)

function Earth:initialize(shape)
	GameObject.initialize(self, shape)
end

function Earth:__tostring()
	return "Earth"
end