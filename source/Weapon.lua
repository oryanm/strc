require 'GameObject'

Weapon = class("Weapon", GameObject)

function Weapon:initialize(shape, owner)
	GameObject.initialize(self, shape)
	self.owner = owner
	self.attacking = false
	self.damage = 20
end

function Weapon:update(dt)
	local x,y = self.owner.shape:center()
	local speed = 10
	local maxAngle = math.pi/2

	if self.attacking and math.abs(self.shape:rotation()) < maxAngle then
		self.shape:rotate(speed*dt*self.owner.direction, x, y)
--		if math.abs(self.shape:rotation())>(math.pi/2) then
--			self.shape:setRotation(self.owner.direction*math.pi/2)
--		end
	elseif self.attacking then
		self.attacking = false
		self.shape:setRotation(0, x, y)
--		self.shape:moveTo(x, y-50)
	end
end

function Weapon:attack()
	self.attacking = true
end

function Weapon:__tostring()
	return "this is an abstarct weapon object"
end