local M = {}

function M.killEnemy(type1,collA)
	for j, enemy in ipairs(objects[type1]) do  -- drawing some enemies
			if enemy.isDone == 1  then
				if collA == (type1..j) then
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
    table.insert(objects.enemy, {body = body, shape = shape, velX = velX, velY = velY, isDone = 0}) -- put 'em into a table
    enemycount = enemycount+1 -- count the enemies
    for i, enemy in ipairs(objects.enemy) do -- add finishing touches
      if enemy.isDone == 0 then
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
		if enemy.isDone == 1 then
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
		end
	end
end

function M.DrawEnemy(enemy)
  love.graphics.setColor(255,0,0,255) -- some red for our enemies

  for i, enemy in ipairs(objects.enemy) do  -- drawing some enemies
    if enemy.isDone == 1 then
      love.graphics.polygon("fill", enemy.body:getWorldPoints(enemy.shape:getPoints()))
    end
  end
end
return M
