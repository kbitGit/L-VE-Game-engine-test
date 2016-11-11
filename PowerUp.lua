local M = {}
local timer = 0
powerUpVar = false
dt = love.timer.getDelta( )
powerUpTime = 0
maxPowerUpTime = 7

function M.SpawnPowerUp(powerUp)
	timer = timer + dt
	if math.floor(timer*10) % 1 == 0 and math.random(0,10000) <= 5 then
		local x = math.random(0,love.graphics.getWidth())
		local y = math.random(0,love.graphics.getHeight()-340)
		table.insert(objects.powerUp, {x = x, y = y, shape = shape, frame = frame,isDone = 0}) -- put 'em into a table
		for i, powerUp in ipairs(objects.powerUp) do -- add finishing touches
			if powerUp.isDone == 0 then
				powerUp.anim = {}
				powerUp.anim.frame = 1
				makeQuads(powerUp.anim,"assets/Powerup.png",30,30)
				powerUp.isDone = 1
			end
		end
	end
end

function M.UsePowerUp(collA)
	for j, powerUp in ipairs(objects.powerUp) do  -- drawing some enemies
		if powerUp.isDone == 1  then
			if objects.player.body:getX() + 30 >= powerUp.x and objects.player.body:getX() <= powerUp.x+30 and objects.player.body:getY() + 30 >= powerUp.y and objects.player.body:getY() <= powerUp.y+30 then
				powerUpVar = true
				powerUp.isDone = 2
				table.remove(powerUp,j)
			end
		end
	end
	if powerUpVar then
		if (love.keyboard.isDown(' ') or love.keyboard.isDown('space')  or love.keyboard.isDown('w')) and sniggleJ == 0 then
			sniggleJ = sniggleJ + 0.5
		end
		powerUpTime = powerUpTime + dt
		if powerUpTime >= maxPowerUpTime then
			powerUpTime = 0
			powerUpVar = false
		end
	end
end

function M.DrawPowerUp(dt)
	love.graphics.setColor(255,255,0,255)
	for i, powerUp in ipairs(objects.powerUp) do
		if powerUp.isDone == 1 then
			playAnim(powerUp,"anim",10,true,15,1,-15,-15)
		end
		if powerUpVar then
			love.graphics.polygon("fill", love.graphics.getWidth()/2 + (love.graphics.getWidth()/2*((maxPowerUpTime-powerUpTime)/maxPowerUpTime)),0, love.graphics.getWidth()/2 + (love.graphics.getWidth()/2*((maxPowerUpTime-powerUpTime)/maxPowerUpTime)),20, love.graphics.getWidth()/2, 20, love.graphics.getWidth()/2 - (love.graphics.getWidth()/2*((maxPowerUpTime-powerUpTime)/maxPowerUpTime)),0, love.graphics.getWidth()/2 - (love.graphics.getWidth()/2*((maxPowerUpTime-powerUpTime)/maxPowerUpTime)),20,love.graphics.getWidth()/2 + (love.graphics.getWidth()/2*((maxPowerUpTime-powerUpTime)/maxPowerUpTime)),0) -- draw the player
		end
	end
end

return M