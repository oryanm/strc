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

		game.timer.add(0.2, function()
			-- todo: if the weapon is destroyed within the timed 0.2s then self.shape will be nil
			collider:setGhost(self.shape)
			self.attacking = false
		end)

		game.timer.add(0.4, function()
			self.ready = true
		end)

		speakers:playSoundEffect('mel.wav')
	end
end

function MeleeWeapon:draw()
	if self.attacking then self.shape:draw("line") end
end