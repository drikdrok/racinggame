check = class("check")

checks = {}

local checkImage = love.graphics.newImage("assets/check.png")

function check:initialize()
	self.x = love.graphics.getWidth()/2-font:getWidth(number1.. "+"..number2)/2 + 140 + #checks * 100
	self.y = 480

	self.timer = 0

	self.id = #checks + 1
	table.insert(checks, self)
end

function check:update(dt)
	self.timer = self.timer + dt
	if self.timer >= 1.5 then -- 1.5 seconds
		checks[self.id] = nil
	end
end

function check:draw()
	love.graphics.draw(checkImage, self.x, self.y, 0, 0.2, 0.2)
end