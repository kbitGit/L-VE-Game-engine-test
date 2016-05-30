local M = {}

function M.shoot(bullets, dir) --used for deploying a bullet from the player in a specific direction
	if _G["sniggle" .. dir] ==1 then    -- prevents autofire (_G[...]asks for variable in Global table)
		local vel = bulletNormVel -- using right velocity
		local body = love.physics.newBody(world, objects.player.body:getX()+_G["pos1" .. dir], objects.player.body:getY()+_G["pos2" .. dir],'dynamic') -- creating the body at the right position
		local shape = love.physics.newRectangleShape(4, 4) -- shaping up
		table.insert(objects.bullets, {body = body, shape = shape, vel = vel, isDone = 0,dir=dir}) -- putting the bullet in the right table
		for i, bullet in ipairs(objects.bullets) do -- if the bullet isn't done yet, apply the final touches e.g. glueing everithing together and making it a bullet type object
			if bullet.dir == dir then
				if bullet.isDone == 0 then
					bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape, 0)
					bullet.fixture:setUserData("bullets"..i)
					bullet.body:setBullet(true)
					bullet.isDone = 1
				end
			end
		end
	end
	_G["sniggle" .. dir] = _G["sniggle" .. dir]-1 -- preventing autofire part II
end

function M.use(bullet) --destroying the bullet, if...
  for i, bullet in ipairs(objects.bullets) do
			if bullet.isDone == 1 then -- ... its done and not used yet and...
				bullet.body:setLinearVelocity(bullet.vel*_G["pos1" .. bullet.dir], bullet.vel*_G["pos2" .. bullet.dir]) -- (using the opportunity to make the bullet move)
				local Velx, Vely = bullet.body:getLinearVelocity( ) -- getting our ocal variables to check
				if Velx == 0 and _G["pos1" .. bullet.dir] ~= 0 then -- ... the bullet doesn't move in X direction if it's meant to
					bullet.body:destroy()
  				bullet.isDone = 2
					table.remove(objects.bullets,i)
				elseif Vely == 0 and _G["pos2" .. bullet.dir] ~= 0 then -- ... the bullet doesn't move in Y direction if it's meant to
					bullet.body:destroy()
  				bullet.isDone = 2
					table.remove(objects.bullets,i)
				elseif bullet.body:getX()-1 < 0 then -- ... if it's too far to the left
					bullet.body:destroy()
  				bullet.isDone = 2
					table.remove(objects.bullets,i)
				elseif bullet.body:getX()+1 > love.graphics.getWidth() then -- ... if it's too far to the right
					bullet.body:destroy()
  				bullet.isDone = 2
					table.remove(objects.bullets,i)
				elseif bullet.body:getY()-1 < 0 then -- ... if it's too far to the top
					bullet.body:destroy()
  				bullet.isDone = 2
					table.remove(objects.bullets,i)
				elseif bullet.body:getY()+floorheight+5 > love.graphics.getHeight() then -- ... if it's too far to the bottom
					bullet.body:destroy()
  				bullet.isDone = 2
					table.remove(objects.bullets,i)
  		end
		end

	end
end


return M
