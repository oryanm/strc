Gun = class('Gun', Weapon)

function Gun:initialize(owner, shape)
	Weapon.initialize(self, 'Gun', owner, shape or
		collider:addRectangle(0, 0, 30, 10))

	local x,y = owner.shape:center()
	collider:setGhost(self.shape)
	self.shape:moveTo(x + 20, y)
	self.fireRate = 0.05

	self.ammo = 70
	self.loadedAmmo = 30
	self.reloading = false

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
			self.handle = timer.addPeriodic(self.fireRate, self:fireProjectile())
		end
	end
end

function Gun:afterAttack()
	self.attacking = false
	timer.cancel(self.handle)
end

function Gun:fireProjectile()
	return function()
		self.loadedAmmo = self.loadedAmmo - 1
		-- if clip is empty
		if self.loadedAmmo <= 0 then
			-- can't fire
			timer.cancel(self.handle)
		else
			local proj = collider:addPoint((vector.new(self.shape:center()) + vector.new(10,0)):unpack())
			collider:copyGroups(self.shape, proj)
			Projectile:new(vector.new(love.mouse.getPosition()) + vector.new(camera._x, camera._y), proj)
		end
	end
end

function Gun:reload()
	self.reloading = true
	timer.add(1, function()
		self.loadedAmmo = math.min(self.ammo, 30)
		self.ammo = math.max(self.ammo - 30, 0)
		self.reloading = false
	end)
end
