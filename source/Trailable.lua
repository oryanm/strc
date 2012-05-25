require 'middleclass'

trail = {}
MAX_SIZE = 100

Trailable =
{
	drawTrail = function(self)
		--print('flap flap flap I am a ' .. self.class.name)
		for i=1, table.getn(trail) do
			love.graphics.point( trail[i].x,  trail[i].y)
		end
	end;

	addTrail = function(self)
		local ccx, ccy = self.shape:center()
		table.insert(trail, {x = ccx, y = ccy})

		if ( table.getn(trail) > MAX_SIZE) then
			table.remove(trail,1)
		end
	end
}