player = class("player")

function player:initialize()
	self.x = 10
	self.y = 380

	self.image = love.graphics.newImage("assets/player.png")

	self.velocity = 0 
	self.speed = 100

	self.finished = false

	self.won = false
	self.place = 0 

end

function player:update(dt)
	if self.velocity > 0 then 
		self.velocity = self.velocity - self.speed*dt
		self.x = self.x + self.speed*dt


		if self.x + 100/self.image:getWidth() > 1200 and not self.finished then 
			table.insert(places, self.image)
			self.finished = true

			self.place = #places

			if #places == 1 then 
				self.won = true
			end
		end
	end
end

function player:draw()
	if not self.finished then 
		love.graphics.draw(self.image, self.x, self.y, 0, 100/self.image:getWidth(), 40/self.image:getHeight())
	end
end


return player