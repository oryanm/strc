-- force const
-- if activated by key,
-- the value is the KeyConstant value
JUMP = ' '
MOVE_RIGHT = 'right'
MOVE_LEFT = 'left'
WALK = 'walk'
RIDE = 'ride'
GRAVITY = 'gravity'
CAT = 'Cat'
TURTLE = 'Turtle'
EARTH = 'Earth'

force = {}

function force.new(x, y, key)
	local f = vector.new(x, y)
	f.key = key
	return f
end

FORCES =
{
	JUMP = force.new(0, JUMPING_FORCE, JUMP),
	MOVE_RIGHT = force.new(RUNNING_FORCE, 0, MOVE_RIGHT),
	MOVE_LEFT = force.new(-RUNNING_FORCE, 0, MOVE_LEFT),
	WALK = vector.new(WALKING_FORCE, 0),
	RIDE = vector.new(WALKING_FORCE, 0),
	GRAVITY = vector.new(0, game.gravity),
	EARTH = vector.new(0, -game.gravity)
}

PLAYER_APPLIED_FORCES =
{
	JUMP = FORCES.JUMP,
	MOVE_RIGHT = FORCES.MOVE_RIGHT,
	MOVE_LEFT = FORCES.MOVE_LEFT
}