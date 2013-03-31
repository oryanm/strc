Weapon = class('Weapon', GameObject)
Weapon.sequence = 0

function Weapon:initialize(name, owner, shape)
	Weapon.sequence = Weapon.sequence + 1
	GameObject.initialize(self, name .. '#' .. Weapon.sequence, shape)
	self.owner = owner
	self.attacking = false
	self.damage = 0
	self.team = self.owner.team
end

function Weapon:attack()
end

function Weapon:afterAttack()
end