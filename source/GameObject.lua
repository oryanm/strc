require 'middleclass'

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

function GameObject:__tostring()
	return "this is an abstarct game object"
end