car = class("car")

cars = {}

function car:initialize(image, speed)
	self.x = 10
	self.y = 140 + 80*#cars

	self.speed = speed

	self.image = love.graphics.newImage("assets/car" .. image..".png")

	self.finished = false

	table.insert(cars, self)
end

function car:update(dt)
	self.x = self.x + self.speed*dt

	if self.x + 100/self.image:getWidth() > 1200 and not self.finished then 
		table.insert(places, self.image)
		self.finished = true
	end
end

function car:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, 100/self.image:getWidth(), 50/self.image:getHeight())
end