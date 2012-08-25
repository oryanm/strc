Weapon = class("Weapon", GameObject)

function Weapon:initialize(shape, owner)
	GameObject.initialize(self, shape)
	self.owner = owner
	self.attacking = false
	self.damage = 0
end

function Weapon:update(dt)
end

function Weapon:attack()
end

function Weapon:__tostring()
	return "this is an abstarct weapon object"
end