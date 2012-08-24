require 'middleclass'

GameObject = class("GameObject")

function GameObject:initialize(shape)
	self.shape = shape
	shape.object = self
	self.forces = {}
	self.speed = {x = 0, y = 0}
	self.maxSpeed = {x = 300, y = 600}
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

function GameObject:__tostring()
	return "this is an abstarct game object"
end