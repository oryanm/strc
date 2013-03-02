Gun = class('Gun', Weapon)

function Gun:initialize(owner, shape)
	Weapon.initialize(self, 'Gun', owner, shape or
		collider:addRectangle(0, 0, 30, 10))

	local x,y = owner.shape:center()
	collider:setGhost(self.shape)
	self.shape:moveTo(x + 20, y)
	self.fireRate = 0.05

	--[[ fire blank shot. this is done for the scenario when the player is still holding
	the mouse button while he switches from melee to ranged weapon for the first time ]]
	self:attack()
	self:afterAttack()
end

function Gun:attack()
	self.attacking = true
	self.handle = timer.addPeriodic(self.fireRate, self:fireProjectile())
end

function Gun:afterAttack()
	self.attacking = false
	timer.cancel(self.handle)
end

function Gun:fireProjectile()
	return function()
		local proj = collider:addPoint((vector.new(self.shape:center()) + vector.new(10,0)):unpack())
		collider:copyGroups(self.shape, proj)
		Projectile:new(vector.new(love.mouse.getPosition()) + vector.new(camera._x, camera._y), proj)
	end
end