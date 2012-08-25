MeleeWeapon = class("MeleeWeapon", Weapon)

function MeleeWeapon:initialize(shape, owner)
	Weapon.initialize(self, shape, owner)
	self.damage = 20

	local x,y = owner.shape:center()
	shape:moveTo(x, y-20)
	shape:rotate(math.pi/4*owner.direction, x, y)
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

function Weapon:attack()
	self.attacking = true
end

function MeleeWeapon:__tostring()
	return "this is an abstarct melee weapon object"
end