local M = {}

function M.killEnemy(collA)
	for j, enemy in ipairs(objects.enemy) do  -- drawing some enemies
			if enemy.isDone == 1  then
				if collA == ("enemy"..j) then
					enemy.herbert = 2
					enemy.deathX = enemy.body:getX()
					enemy.deathY = enemy.body:getY()
					if powerUpVar then
						powerUpTime = 0
					end
				end
				if enemy.herbert == 3 then
					enemy.body:destroy()
					enemy.isDone = 2
					table.remove(enemy,j)
					enemycount = enemycount-1
					table.remove(storage.collA,k)
                    score = score + 10
				end
			end
		end
end

function M.SpawnEnemy(enemy)
	while enemycount < maxEnemies do
		local velX = math.random(200,400)*(-1)^math.random(1,2) -- spawn enemies at random locations
		local velY = math.random(200,400)*(-1)^math.random(1,2) -- spawn enemies at random locations
		local body = love.physics.newBody(world, math.random(0,love.graphics.getWidth()), math.random(0,love.graphics.getHeight()-300),'dynamic') -- give the enemies a body
		local shape = love.physics.newRectangleShape(20, 20) -- shaping up
		local num = enemycount
		local herbert = 5
		table.insert(objects.enemy, {body = body, shape = shape, velX = velX, velY = velY, isDone = 0, num = num, frame = frame, herbert = herbert}) -- put 'em into a table
		enemycount = enemycount+1 -- count the enemies
		for i, enemy in ipairs(objects.enemy) do -- add finishing touches
			if enemy.isDone == 0 then
				enemy.spawn = {}
				enemy.spawn.frame = 1
				makeQuads(enemy.spawn,"assets/spawnAnim.png",20,200)
				enemy.kill = {}
				enemy.kill.frame = 1
				makeQuads(enemy.kill,"assets/killAnim.png",60,60)
				enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 0)
				enemy.fixture:setUserData("enemy"..i)
				enemy.body:setBullet(true)
				enemy.isDone = 1
			end
		end
	end
end

function M.UpdateEnemy(enemy)
  for i, enemy in ipairs(objects.enemy) do
                    
		if enemy.isDone == 1 and enemy.herbert == 1 then
			enemy.body:setLinearVelocity(enemy.velX, enemy.velY) -- get the enemies moving
			if enemy.body:getX()-5 < 0 then -- reverse enemie speed if the move to the outside horizontally
				enemy.body:setX(love.graphics.getWidth()-5)
			end
            if enemy.body:getX()+5 > love.graphics.getWidth() then
                enemy.body:setX(5)
            end
			if enemy.body:getY()-5 < 0 and enemy.velY < 0 or enemy.body:getY()+5 > love.graphics.getHeight()-floorheight-10 and enemy.velY > 0 then -- reverse enemie speed if the move to the outside vertically
				enemy.velY = -enemy.velY
			end
			if enemy.body:getY()+5 >= love.graphics.getHeight()-300 and enemy.herbert == 5 then
				enemy.body:setY(math.random(0,love.graphics.getHeight()-300))
			end
            
            ---SHITTY PASTE JOB---
            local xSpeed, ySpeed = enemy.body:getLinearVelocity( )
			if math.abs(xSpeed) <= 400 and math.abs(ySpeed) <= 400 then   
                
                local Xdist = enemy.body:getX() - objects.player.body:getX()
                
                if Xdist >= 100 then 
					enemy.velX = enemy.velX - Xdist/1000
				else
					enemy.velX = enemy.velX - Xdist/1000 +math.random(-2,2)
				end
                
                local Ydist = enemy.body:getY() - objects.player.body:getY()
                    
                if Ydist >= 100 then 
					enemy.velY = enemy.velY - Ydist/1000
				else
					enemy.velY = enemy.velY - Ydist/1000 +math.random(-2,2)
				end
            
            else
                enemy.velX = enemy.velX/math.random(2,5)
                enemy.velY = enemy.velY/math.random(2,5)
            end
            ---SHITTY PÄSTE JOB---
        elseif enemy.isDone == 1 and enemy.herbert == 2 then
			enemy.body:setX(enemy.deathX)
			enemy.body:setY(enemy.deathY)
		end
	end
end

function M.DrawEnemy(dt,enemy)
  dt = love.timer.getDelta( )
  love.graphics.setColor(255,0,0,255) -- some red for our enemies

	if spawncount ~= nil and objects.player.isDone == 1 then
		love.graphics.print (10-math.floor(spawncount),950*xMagic,love.graphics.getHeight()/2-80,0,0.2,0.2)
		love.graphics.print ("NEXT WAVE",250*xMagic,love.graphics.getHeight()/2-80,0,0.2,0.2)
		love.graphics.print ("ENTER TO SKIP",200*xMagic,love.graphics.getHeight()/2,0,0.2,0.2)
	end
  
  for i, enemy in ipairs(objects.enemy) do  -- drawing some enemies
    if enemy.isDone == 1 then
		if enemy.herbert == 0 then
			playAnim(enemy,"spawn",14,false,50,1,-10,-190)
		elseif enemy.herbert == 1 then
			love.graphics.polygon("fill", enemy.body:getWorldPoints(enemy.shape:getPoints()))
		elseif enemy.herbert == 2 then
			playAnim(enemy,"kill",20,false,30,3,-30,-30)
		else
			if 1 == math.random(1,10) then
				enemy.herbert = 0
			end
		end
    end
  end
end

return M
