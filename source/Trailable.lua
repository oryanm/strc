Trailable =
{
	getTrail = function(self) return error('abstract method must be implemented') end;
	getMaxSizeOfTrail = function(self) return error('abstract method must be implemented') end;

	drawTrail = function(self)
		local trail = self:getTrail()

		--TODO: this seems to drop the FPS like crazy
		for i = 1, table.getn(trail) do
			love.graphics.point(trail[i].x,  trail[i].y)
		end
	end;

	addTrail = function(self)
		local ccx, ccy = self.shape:center()
		local trail = self:getTrail()
		table.insert(trail, vector.new(ccx, ccy))

		if (table.getn(trail) > self:getMaxSizeOfTrail()) then
			table.remove(trail, 1)
		end
	end
}