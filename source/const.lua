DELTA = 1/60
MAX_SPEED = vector.new(300, 5200)
MAX_JUMP_TIME = 0.15
HIT_PARALYZE_TIME = 0.2

SURFACE_FRICTION = 0.7
RESTITUTION = 0.1

PROJECTILE_SPEED = 500
PROJECTILE_RANGE = 800

DIRECTION = {RIGHT = 1, LEFT = -1 }

JUMPING_FORCE = -15000
RUNNING_FORCE = 6000
WALKING_FORCE = 1000
GRAVITY_FORCE = 4000

AUDIO_RESOURCES_PATH = '/resources/audio/'

TEAMS =
{
	NEUTRAL = 'neutral',
	GOODSIDE = 'goodside',
	DARKSIDE = 'darkside'
}

--[[
	a and b or c <==> a ? b : c
	x = x or v <==> if not x then x=v end <==>
		if x = nil then x=v end
	x, y = y, x <==> swap 'x' for 'y'
	math.huge <==> Integer.MAX_INT
	do return end
	o:foo(x) <==> o.foo(o,x)
 ]]