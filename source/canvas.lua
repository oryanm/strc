canvas = {}
canvas.canvas = {}
canvas.size = vector.new(WIDTH, HEIGHT)
canvas.offset = vector.new()
canvas.scale = 0

function canvas:load()
	self.canvas = love.graphics.newCanvas(canvas.size.x, canvas.size.y)
	self.canvas:setFilter("nearest","nearest")
	self:calculateScale()
end

function canvas:set()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
end

function canvas:unset()
	love.graphics.setCanvas()
	love.graphics.setBlendMode("premultiplied")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBackgroundColor(0, 0, 0, 255)
	love.graphics.clear()
	love.graphics.draw(self.canvas, self.offset.x, self.offset.y, 0, self.scale)
	love.graphics.setBlendMode("alpha")
end

function canvas:calculateScale()
	local windowSize = vector.new(love.graphics.getMode())
	local windowAspectRatio = windowSize.x / windowSize.y
	local canvasAspectRatio = self.size.x / self.size.y

	if windowAspectRatio < canvasAspectRatio then
		-- center the canvas vertically
		self.scale = windowSize.x / self.size.x
	else
		-- otherwise we have to center the canvas horizontally
		self.scale = windowSize.y / self.size.y
	end

	self.offset = (windowSize - self.size * self.scale) / 2
end