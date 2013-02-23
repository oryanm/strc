MeleeWeapon = class("MeleeWeapon", Weapon)

function MeleeWeapon:initialize(owner, shape)
	Weapon.initialize(self, 'MeleeWeapon', owner, shape or
		collider:addRectangle(0, 0, 5, 100))
	self.damage = 20

	local x,y = owner.shape:center()
	self.shape:moveTo(x, y-20)
	self.shape:rotate(math.pi/4*owner.direction, x, y)
end

function MeleeWeapon:update(dt)
	local x,y = self.owner.shape:center()
	local speed = 10
	local maxAngle = math.pi*3/4

	if self.attacking and math.abs(self.shape:rotation()) < maxAngle then
		self.shape:rotate(speed*dt*self.owner.direction, x, y)
	elseif self.attacking then
		self.attacking = false
		self.shape:setRotation(math.pi/4*self.owner.direction, x, y)
	end
end

function MeleeWeapon:attack()
	self.attacking = true
end