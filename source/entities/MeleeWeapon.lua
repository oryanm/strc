MeleeWeapon = class("MeleeWeapon", Weapon)

function MeleeWeapon:initialize(owner, shape)
	Weapon.initialize(self, 'MeleeWeapon', owner, shape or
		game.collider:addRectangle(0, 0, 50, 50))
	self.damage = 20

	local x,y = owner.shape:center()
	self.shape:moveTo(x + 15, y)
	game.collider:setGhost(self.shape)
	self.ready = true
end

function MeleeWeapon:attack()
	if self.ready then
		self.attacking = true
		self.ready = false
		game.collider:setSolid(self.shape)

		game.timer.add(0.2, function()
			-- make sure self is not dead.
			-- otherwise collider will throw exception
			if game.objects[self.name] then
				game.collider:setGhost(self.shape)
			end
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