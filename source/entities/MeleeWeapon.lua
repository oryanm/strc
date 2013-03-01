MeleeWeapon = class("MeleeWeapon", Weapon)

function MeleeWeapon:initialize(owner, shape)
	Weapon.initialize(self, 'MeleeWeapon', owner, shape or
		collider:addRectangle(0, 0, 50, 50))
	self.damage = 20

	local x,y = owner.shape:center()
	self.shape:moveTo(x + 15, y - 15)
	collider:setGhost(self.shape)
	self.ready = true
end

function MeleeWeapon:attack()
	if self.ready then
		self.attacking = true
		self.ready = false
		collider:setSolid(self.shape)

		timer.add(0.2, function()
			collider:setGhost(self.shape)
			self.attacking = false
		end)

		timer.add(0.4, function()
			self.ready = true
		end)
	end
end

function MeleeWeapon:draw()
	if self.attacking then self.shape:draw("line") end
end