local m = math

function m.clampv(v, min, max)
	return vector.new(math.clamp(v.x, min.x, max.x), math.clamp(v.y, min.y, max.y))
end

function m.clamp(x, min, max)
	return x < min and min or (x > max and max or x)
end

function m.sign(x)
	return x > 0 and 1 or x < 0 and -1 or 0
end

function m.angleBetweenObjects(object, otherObject)
	return m.angle(vector.new(object.shape:center()), vector.new(otherObject.shape:center()))
end

function m.angle(point, otherPoint)
	return m.deg(m.atan2(otherPoint.x - point.x, otherPoint.y - point.y))
end

math = m