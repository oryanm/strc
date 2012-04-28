camera = {}
camera._x = 0
camera._y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self._x, -self._y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self._x = self._x + (dx or 0)
  self._y = self._y + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:setX(value)
  if self._bounds then
    self._x = math.clamp(value, self._bounds.minx, self._bounds.maxx)
	--if (value < self._bounds.minx) then self._x = self._bounds.minx
	--elseif (value > self._bounds.maxx) then self._x = self._bounds.maxx end
  else
    self._x = value
  end
end

function camera:setY(value)
  if self._bounds then
    self._y = math.clamp(value, self._bounds.miny, self._bounds.maxy)
  else
    self._y = value
  end
end

function camera:setPosition(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function camera:getBounds()
  return unpack(self._bounds)
end

function camera:setBounds(minx, miny, maxx, maxy)
  self._bounds = { minx = minx, miny = miny, maxx = maxx, maxy = maxy }
end
