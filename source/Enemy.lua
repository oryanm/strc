require 'LivingObject'

Enemy = class('Enemy', LivingObject)
Enemy.sequence = 0

function Enemy:initialize(shape)
	LivingObject.initialize(self, shape)
	self.forces[GRAVITY] = FORCES.GRAVITY
	self.direction = DIRECTION.LEFT
	self.forces[WALK] = vector.new(self.direction*WALKING_FORCE, 0)
	Enemy.sequence = Enemy.sequence + 1
	self.id = Enemy.sequence
end

-- create an anemy and throw it to the game
function Enemy.spawn()
	local enemy = Enemy:new(collider:addRectangle(
		camera._x + 930, camera._y + 300, 20, 20))
	collider:addToGroup("Enemies", enemy.shape)
	game.objects[tostring(enemy)] = enemy
end

function Enemy:draw()
	self.shape:draw("line")
end

function Enemy:collide(otherObject)
	if otherObject == earth then
		-- add earth force to counter gravity
		self.forces[tostring(otherObject)] = FORCES.EARTH

		-- apply collision affect on speed
		local restitution = 0.1
		self.speed.y = -restitution*self.speed.y
		self.speed.x = SURFACE_FRICTION*self.speed.x
	elseif otherObject == turtle or otherObject == cat or instanceOf(Weapon, otherObject) then
		local fx = 10*WALKING_FORCE
		if ((self.shape:center() < otherObject.shape:center()))then fx = -fx end
		self.speed.x = -0.1*self.speed.x
		-- apply otherObject's force on self
		self.forces[tostring(otherObject)] = vector.new(fx, -WALKING_FORCE)
	end
end

function Enemy:rebound(otherObject)
	self.forces[tostring(otherObject)] = nil
	if otherObject == turtle or otherObject == cat or instanceOf(Weapon, otherObject) then
		LivingObject.takeHit(self, otherObject.damage)
	end
end

function Enemy:__tostring()
	return "Enemy#" .. self.id
end
