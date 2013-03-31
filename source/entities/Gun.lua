Gun = class('Gun', Weapon)

function Gun:initialize(owner, shape)
	Weapon.initialize(self, 'Gun', owner, shape or
		collider:addRectangle(0, 0, 30, 10))

	local x,y = owner.shape:center()
	collider:setGhost(self.shape)
	self.shape:moveTo(x + 20, y)
	self.fireRate = 0.05
	self.clipSize = 30
	self.ammo = 200
	self.loadedAmmo = self.clipSize
	self.reloading = false
	self.reloadDelay = 1

	--[[ fire blank shot. this is done for the scenario when the player is still holding
	the mouse button while he switches from melee to ranged weapon for the first time ]]
	self:attack()
	self:afterAttack()
end

function Gun:attack()
	if not self.reloading then
		-- if clip is empty
		if self.loadedAmmo <= 0 then
			self:reload()
		else
			self.attacking = true
			self.handle = game.timer.addPeriodic(self.fireRate, self:fireProjectile())
		end
	end
end

function Gun:afterAttack()
	game.timer.cancel(self.handle)
	self.attacking = false
end

function Gun:fireProjectile()
	return function()
		-- if clip is empty
		if self.loadedAmmo <= 0 then
			-- can't fire
			self.attacking = false
			self:reload()
			return false
		else
			self.loadedAmmo = self.loadedAmmo - 1
			local proj = collider:addPoint((vector.new(self.shape:center()) + vector.new(10,0)):unpack())
			collider:copyGroups(self.shape, proj)
			Projectile:new(vector.new(love.mouse.getPosition()) + vector.new(camera._x, camera._y), proj)
			speakers:playSoundEffect('fireProjectile.wav')
		end
	end
end

function Gun:reload()
	self.reloading = true
	self.loadingHandle = game.timer.add(self.reloadDelay, function()
		-- reload a full clip or what is left
		self.loadedAmmo = math.min(self.ammo, self.clipSize)
		self.ammo = math.max(self.ammo - self.clipSize, 0)
		self.reloading = false
	end)
end

function Gun:safe()
	self:afterAttack()

	-- abort reloading
	if self.reloading then
		game.timer.cancel(self.loadingHandle)
		self.reloading = false
	end
end

function Gun:destroy()
	self:safe()
	Weapon.destroy(self)
end
