--This got out of hand. Very little planning happened, leading to most have the game just being in this one file...

math.randomseed(os.time())
love.graphics.setDefaultFilter("nearest", "nearest")

class = require("middleclass")
anim8 = require("anim8")
Player = require("player")
require("car")
require("check")

number1 = 0
number2 = 0

answer = ""

places = {}	


local bronze = love.graphics.newImage("assets/bronze.png")
local silver = love.graphics.newImage("assets/silver.png")
local track = love.graphics.newImage("assets/track.png")
local trophyImage = love.graphics.newImage("assets/gold.png")
local sadImage = love.graphics.newImage("assets/Sad.png")

local placesImage = love.graphics.newImage("assets/places.png")
local placesLocations = {{1010, 545}, {900, 550}, {1100, 590}} 

local crowdImage = love.graphics.newImage("assets/crowd.png")
local g = anim8.newGrid(50, 20, crowdImage:getWidth(), crowdImage:getHeight())
local crowdAnimation = anim8.newAnimation(g("1-2", 1), 0.5)

state = "menu"

local countdownTimer = 3

difficulty = 1
difficultyText = {"Nemt", "Svært", "Turbo"}


local buttons = {
	{
		text = "Start", 
		y = 520,
		execute = function() --what to do when button is clicked
			cars = {}
			places = {}

			player = Player:new()

			car:new(2, math.random(10+(difficulty*16), 20+(difficulty*16)))
			car:new(3, math.random(10+(difficulty*16), 20+(difficulty*16)))
			car:new(4, math.random(10+(difficulty*16), 20+(difficulty*16)))

			font = love.graphics.newFont(55)
			love.graphics.setFont(font)

			newQuestion()


			state = "countdown"
			countdownTimer = 3
			answer = ""
		end,
		highlighted = false --Is cursor over
	},

	{
		text = "Sværhedsgrad",
		x = 10,
		y = 570,
		execute = function() --what to do when button is clicked
			difficulty = difficulty + 1
			if difficulty >= 4 then 
				difficulty = 1
			end		
		end,
		highlighted = false -- is mouse over button
	},

	{
		text = "Tilbage",
		x = 10,
		y = 600,
		execute = function()
			state = "menu"

			player = Player:new()

			cars = {}
			car:new(2, math.random(10+(difficulty*16), 20+(difficulty*16)))
			car:new(3, math.random(10+(difficulty*16), 20+(difficulty*16)))
			car:new(4, math.random(10+(difficulty*16), 20+(difficulty*16)))

			font = love.graphics.newFont(55)
			love.graphics.setFont(font)
		end,
		highlighted = false
	}
}


local logoY = -100

function love.load()
	player = Player:new()

	car:new(2, math.random(12, 22))
	car:new(3, math.random(12, 22))
	car:new(4, math.random(12, 22))

	font = love.graphics.newFont(55)
	love.graphics.setFont(font)

end

function love.update(dt)

	crowdAnimation:update(dt)

	if state == "finished" then 
		buttons[1].text = "Prøv igen"
		updateButton(1)
		updateButton(3)
	else
		buttons[1].text = "Start"
	end

	for i,v in pairs(checks) do
		v:update(dt)
	end

	player:update(dt)

	if player.finished then
		state = "finished"
	end

	if tonumber(answer) == number1 + number2 then 
		answer = "" --Resets input
		player.velocity = player.velocity + 225 --Make player move forward

		newQuestion() 
		check:new() --Create green checkmark
	end


	if state == "playing" or state == "finished" then
		for i,v in pairs(cars) do --Update every car
			v:update(dt)
		end
		if #places >= 3 then  -- If the other cars finish before the player
			state = "finished"
		end
	elseif state == "menu" then 
		if logoY < 420 then  --Drop down the logo 
			logoY = logoY + 300*dt
		end
		if logoY > 420 then 
			logoY = 420
		end

		updateButton(1)
		updateButton(2)
		buttons[3].highlighted = false
	elseif state == "countdown" then 
		countdownTimer = countdownTimer - dt

		if countdownTimer <= 0 then 
			state = "playing"
			font = love.graphics.newFont(55)
			love.graphics.setFont(font)
		end
	end
end

function love.draw()
	love.graphics.setColor(0.5, 0.5, 0.5)

	love.graphics.rectangle("fill", 0, 400, 1280, 1000)
	love.graphics.rectangle("fill", 0, 000, 1280, 80)
	love.graphics.setColor(1,1,1)
	love.graphics.draw(track, 0, 80)
	for i = 0, (720/50*4) do
		crowdAnimation:draw(crowdImage, 50*4.3*i, 0, 0, 4.3)
	end	

	for i,v in pairs(cars) do
		v:draw()
	end
	for i,v in pairs(checks) do
		v:draw()
	end
	
	player:draw()

	if state == "playing" or state == "finished" then 
		if not player.finished and state ~= "finished" then 
			love.graphics.print(number1.. "+"..number2, love.graphics.getWidth()/2-font:getWidth(number1.. "+"..number2)/2, 480)
			love.graphics.print(answer, love.graphics.getWidth()/2-font:getWidth(answer)/2, 580)
		end

		--Winners

		love.graphics.draw(placesImage, 900, 550, 0, 0.25)

		for i = 1, #places do
			if i < 4 then 		
				love.graphics.draw(places[i], placesLocations[i][1], placesLocations[i][2], 0, 100/places[i]:getWidth())
			end
		end


		if state == "finished" then
			font = love.graphics.newFont(80)
			love.graphics.setFont(font)
			local message = "Øv... Kom igen!"

			if player.won then 
				message = "Du vandt!"
			end	

			local finishImage = trophyImage
			if player.place == 1 then
				finishImage = trophyImage

			elseif player.place == 2 then 
				finishImage = silver
				message = "Tæt på!"
			elseif player.place == 3 then 
				finishImage = bronze
			else  
				finishImage = sadImage
			end
		
			love.graphics.print(message, love.graphics.getWidth()/2-font:getWidth(message)/2, 50)
			love.graphics.draw(finishImage, love.graphics.getWidth()/2-(finishImage:getWidth()*0.65)/2 , 150, 0,  0.65)


			drawButton(1)
			drawButton(3)
		end

	elseif state == "menu" then
		love.graphics.print("Racerspil!", love.graphics.getWidth()/2-font:getWidth("Racerspil!")/2, logoY)
		love.graphics.print(difficultyText[difficulty], 10, 650)

		drawButton(1)
		drawButton(2)
	elseif state == "countdown" then 
		font = love.graphics.newFont(80)
		 		love.graphics.setFont(font)
		love.graphics.print(math.ceil(countdownTimer), love.graphics.getWidth()/2-font:getWidth(math.ceil(countdownTimer))/2, 50)
	end
end

function love.keypressed(key)
	if key == "escape" then
		if state == "playing" then 
			buttons[3].execute()
		end	
		--love.event.quit()
	end

	if state == "playing" then 
		if key == "1" or key == "2" or key == "3" or key == "4" or key == "5" or key == "6" or key == "7" or key == "8" or key == "9" or key == "0" or key == "kp1" or key == "kp2" or key == "kp3" or key == "kp4" or key == "kp5" or key == "kp6" or key == "kp7" or key == "kp8" or key == "kp9" or key == "kp0" then 
			key = string.gsub(key, "kp", "") --Remove the numpad prefix
			answer = answer .. key --Key gets appended to current intput
		end
		if key == "backspace" then -- Delete previous character
			answer = answer:sub(1, -2)
		end

		if answer:len() > 10 then --Reset input if longer than 10
			answer = ""
		end
	end

	if key == "space" then
		if state == "menu" or state == "finished" then 
			buttons[1].execute() --Press button with space key
		end
	end	
end	

function love.mousepressed(x, y, button)
	if button == 1 then 
		if state == "menu" or state == "finished" then
			for i,v in pairs(buttons) do
				if v.highlighted then 
					v.execute()
				end
			end	
		end
	end
end

function newQuestion()
	number1 = math.random(1, 9)
	number2 = math.random(1, 9)
end


function updateButton(button)
	local button = buttons[button]

	local x = button.x or love.graphics.getWidth()/2-font:getWidth(button.text)/2
	
	local mouseX, mouseY = love.mouse.getPosition()
	-- See if mouse if hovered over buttons
	button.highlighted = (mouseX > x  and mouseX < x + font:getWidth(button.text) and mouseY > button.y and mouseY < button.y + font:getHeight(button.text))  
end

function drawButton(button)
	local button = buttons[button]

	if button.highlighted then 
		love.graphics.setColor(1,0,0) -- Red
	else
		love.graphics.setColor(1,1,1) -- White
	end
	local x = button.x or love.graphics.getWidth()/2-font:getWidth(button.text)/2 -- Center
	love.graphics.print(button.text, x, button.y)
end
