debug = true
meter = 20 -- scale of the world
floorheight = 40
bulletNormVel = 70000 -- how fast a bullet usually is
sniggleR = 1 -- every sniggle is used as "locking mechanism", so pressing a button will only trigger once
sniggleDR = 1
sniggleD = 1
sniggleDL = 1
sniggleL = 1
sniggleUL = 1
sniggleU = 1
sniggleUR = 1
sniggleJ = 1
pos1R = meter/2 -- pos1 and pos2 are for determining where bullets are spawned and how they are used
pos2R = 0
pos1DR = meter/2
pos2DR = meter/2
pos1D = 0
pos2D = meter/2
pos1DL = -meter/2
pos2DL = meter/2
pos1L = -meter/2
pos2L = 0
pos1UL = -meter/2
pos2UL = -meter/2
pos1U = 0
pos2U = -meter/2
pos1UR = meter/2
pos2UR = -meter/2

enemycount = 0 -- how many enemies are in the world
maxEnemies = 10 -- how many enemies should be in the world (good for arena modes)
text = "-->" -- random testing variable
textvar = 0 -- random testing variable
bananatree = 3 -- random testing variable
---JUMP EFFECT---
square = meter -- player size
-----------------

function shoot(bullet, dir) --used for deploying a bullet from the player in a specific direction
	if _G["sniggle" .. dir] ==1 then    -- prevents autofire (_G[...]asks for variable in Global table)
		local vel = bulletNormVel -- using right velocity
		local body = love.physics.newBody(world, objects.player.body:getX()+_G["pos1" .. dir], objects.player.body:getY()+_G["pos2" .. dir],'dynamic') -- creating the body at the right position
		local shape = love.physics.newRectangleShape(4, 4) -- shaping up
		table.insert(objects.bullet[dir], {body = body, shape = shape, vel = vel, isDone = 0}) -- putting the bullet in the right table
		for i, bullet in ipairs(objects.bullet[dir]) do -- if the bullet isn't done yet, apply the final touches e.g. glueing everithing together and making it a bullet type object
			if bullet.isDone == 0 then
				bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape, 0)
				bullet.fixture:setUserData("bullet"..dir..i)
				bullet.body:setBullet(true)
				bullet.isDone = 1
			end
		end
	end
	_G["sniggle" .. dir] = _G["sniggle" .. dir]-1 -- preventing autofire part II
end

function use(bullet, dir) --destroying the bullet, if...

   for i, bullet in ipairs(objects.bullet[dir]) do
    if bullet.isDone == 1 then -- ... its done and not used yet and...
	bullet.body:setLinearVelocity(bullet.vel*_G["pos1" .. dir], bullet.vel*_G["pos2" .. dir]) -- (using the opportunity to make the bullet move)
	local Velx, Vely = bullet.body:getLinearVelocity( ) -- getting our ocal variables to check
	if Velx == 0 and _G["pos1" .. dir] ~= 0 then -- ... the bullet doesn't move in X direction if it's meant to
	bullet.body:destroy()
    bullet.isDone = 2
	table.remove(objects.bullet[dir],i)
	elseif Vely == 0 and _G["pos2" .. dir] ~= 0 then -- ... the bullet doesn't move in Y direction if it's meant to
	bullet.body:destroy()
    bullet.isDone = 2
	table.remove(objects.bullet[dir],i)
	elseif bullet.body:getX()-1 < 0 then -- ... if it's too far to the left
	bullet.body:destroy()
    bullet.isDone = 2
	table.remove(objects.bullet[dir],i)
	elseif bullet.body:getX()+1 > love.graphics.getWidth() then -- ... if it's too far to the right
	bullet.body:destroy()
    bullet.isDone = 2
	table.remove(objects.bullet[dir],i)
	elseif bullet.body:getY()-1 < 0 then -- ... if it's too far to the top
	bullet.body:destroy()
    bullet.isDone = 2
	table.remove(objects.bullet[dir],i)
	elseif bullet.body:getY()+floorheight+5 > love.graphics.getHeight() then -- ... if it's too far to the bottom
	bullet.body:destroy()
    bullet.isDone = 2
	table.remove(objects.bullet[dir],i)
	end
    end
	end
end

function colldec (type1, dir1, type2, dir2, collA, collB) -- destroying two bodies if they touched

    if dir1 == "" then -- when there is no direction, don't use it
	for j, one in ipairs(objects[type1]) do -- opening our tables
    for i, two in ipairs(objects[type2][dir2]) do
    if one.isDone == 1 and two.isDone == 1 then -- only use the bodies if they are done and haven't been used yet
     if collA == (type1..i) and collB == (type2..dir2..j) or collA == (type2..dir2..j) and collB == (type1..i) then -- triggers when collision data matches object data
        one.body:destroy()
        one.isDone = 2
	    table.remove(objects[type1],i)
	    two.body:destroy()
        two.isDone = 2
	    table.remove(objects[type2][dir2],j)
	    enemycount = enemycount-1
	    table.remove(storage.collA,k)
	    table.remove(storage.collB,k)
	    textvar = textvar+1
    end
    end
    end
    end

	elseif dir2 == "" then -- when there is no direction, don't use it
	for j, one in ipairs(objects[type1][dir1]) do -- opening our tables
    for i, two in ipairs(objects[type2]) do
    if one.isDone == 1 and two.isDone == 1 then -- only use the bodies if they are done and haven't been used yet
     if collA == (type1..dir1..i) and collB == (type2..j) or collA == (type2..j) and collB == (type1..dir1..i) then -- triggers when collision data matches object data
        one.body:destroy()
        one.isDone = 2
	    table.remove(objects[type1][dir1],i)
	    two.body:destroy()
        two.isDone = 2
	    table.remove(objects[type2],j)
	    enemycount = enemycount-1
	    table.remove(storage.collA,k)
	    table.remove(storage.collB,k)
	    textvar = textvar+1
    end
    end
    end
    end

	else
    for j, one in ipairs(objects[type1][dir1]) do  -- opening our tables
    for i, two in ipairs(objects[type2][dir2]) do
    if one.isDone == 1 and two.isDone == 1 then -- only use the bodies if they are done and haven't been used yet
     if collA == (type1..dir1..i) and collB == (type2..dir2..j) or collA == (type2..dir2..j) and collB == (type1..dir1..i) then -- triggers when collision data matches object data
        one.body:destroy()
        one.isDone = 2
	    table.remove(objects[type1][dir1],i)
	    two.body:destroy()
        two.isDone = 2
	    table.remove(objects[type2][dir2],j)
	    enemycount = enemycount-1
	    table.remove(storage.collA,k)
	    table.remove(storage.collB,k)
	    textvar = textvar+1
    end
    end
    end
    end
    end
end

function test(tree) -- testing stuff. To be removed.

return _G["banana"..tree]

end

function love.load(arg) -- loading stuff. Duh.
	math.randomseed(os.time()) -- makes random stuff more random
	love.physics.setMeter(meter) --1 Meter = ...
	world = love.physics.newWorld(0, 9.81*10*meter, true) --no horizontal grav, 9.81m/s² vertically
	storage = {} -- some tables
	storage.collA = {}
	storage.collB = {}
	objects = {}
	objects.Ground = {}
	objects.Ground.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()-floorheight/2) --body, middle of shape will be at coordinate
	objects.Ground.shape = love.physics.newRectangleShape(love.graphics.getWidth(), floorheight) --floor is ... high and all over the screen
	objects.Ground.fixture = love.physics.newFixture(objects.Ground.body, objects.Ground.shape) --attach shape to body
	objects.Ground.fixture:setUserData("Ground")
	objects.player = {}
	objects.player.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "dynamic")
	objects.player.shape = love.physics.newRectangleShape( meter, meter)
	objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape, 1)
	objects.player.fixture:setRestitution(0)
	objects.player.speedX = 0
	objects.player.speedY = 0
	objects.player.fixture:setUserData("Playa")

	objects.bullet = {}
	objects.bullet.R = {}
	objects.bullet.DR = {}
	objects.bullet.D = {}
	objects.bullet.DL = {}
	objects.bullet.L = {}
	objects.bullet.UL = {}
	objects.bullet.U = {}
	objects.bullet.UR = {}

	objects.enemy = {}
	while enemycount < maxEnemies do
		local velX = math.random(200,400)*(-1)^math.random(1,2) -- spawn enemies at random locations
		local velY = math.random(200,400)*(-1)^math.random(1,2) -- spawn enemies at random locations
		local body = love.physics.newBody(world, math.random(0,love.graphics.getWidth()), math.random(0,love.graphics.getHeight()-50),'dynamic') -- give the enemies a body
		local shape = love.physics.newRectangleShape(10, 10) -- shaping up
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
	world:setCallbacks(beginContact, endContact, preSolve, postSolve) -- making collisison detection possible
end

function love.update(dt)

	world:update(dt) -- gets the physics going

	objects.player.VelX, objects.player.VelY = objects.player.body:getLinearVelocityFromWorldPoint( 0, 0 ) -- putting player speed into variables

	if love.keyboard.isDown('escape') then -- makes you wanna quit
		love.event.push('quit')
	end

	if love.keyboard.isDown('a') then -- player controls
		if objects.player.VelX > -400 then
			objects.player.body:applyLinearImpulse(-200,0)
		end

		if love.keyboard.isDown('lshift') and objects.player.VelX > -800 then -- player controls
			objects.player.body:applyLinearImpulse(-400,0)
		end
	end

  if love.keyboard.isDown('d') then -- player controls

		if objects.player.VelX < 400 then
			objects.player.body:applyLinearImpulse(200,0)
		end

		if love.keyboard.isDown('lshift') and objects.player.VelX < 800 then -- player controls
			objects.player.body:applyLinearImpulse(400,0)
		end

	end

  if love.keyboard.isDown(' ')  or love.keyboard.isDown('w') then -- player controls

		if objects.player.VelY < 10 and objects.player.VelY > -10 then

			if sniggleJ == 1 then -- no jumping autofire
				sniggleJ = -1
				objects.player.body:applyLinearImpulse(0,-1500)
				----EXTRA-----
				square = 40 -- makes the player go big after jumping
				--------------
			end

		end

	else
		sniggleJ = 1
	end


	if objects.player.body:getX() > love.graphics.getWidth() then -- don't leave the screen, please!
		objects.player.body:setX(0)
	end

	if objects.player.body:getX() < 0 then -- don't leave the screen, please!
		objects.player.body:setX(love.graphics.getWidth())
	end

	if objects.player.body:getY() < 0 then -- don't leave the screen, please!
		objects.player.body:setLinearVelocity(0,100)
	end

	if love.keyboard.isDown('kp6') then -- I'm firin' mah bullets
		shoot(bullet, "R")
	else sniggleR = 1
	end

	if love.keyboard.isDown('kp3') then -- I'm firin' mah bullets
		shoot(bullet, "DR")
	else sniggleDR = 1
	end

	if love.keyboard.isDown('kp2') then -- I'm firin' mah bullets
		shoot(bullet, "D")
	else sniggleD = 1
	end

	if love.keyboard.isDown('kp1') then -- I'm firin' mah bullets
		shoot(bullet, "DL")
	else sniggleDL = 1
	end

	if love.keyboard.isDown('kp4') then -- I'm firin' mah bullets
		shoot(bullet, "L")
	else sniggleL = 1
	end

	if love.keyboard.isDown('kp7') then -- I'm firin' mah bullets
		shoot(bullet, "UL")
	else sniggleUL = 1
	end

	if love.keyboard.isDown('kp8') then -- I'm firin' mah bullets
		shoot(bullet, "U")
	else sniggleU = 1
	end

	if love.keyboard.isDown('kp9') then -- I'm firin' mah bullets
		shoot(bullet, "UR")
	else sniggleUR = 1
	end

	for i, enemy in ipairs(objects.enemy) do
		if enemy.isDone == 1 then
			enemy.body:setLinearVelocity(enemy.velX, enemy.velY) -- get the enemies moving
			if enemy.body:getX()-5 < 0 and enemy.velX < 0 or enemy.body:getX()+5 > love.graphics.getWidth() and enemy.velX > 0 then -- reverse enemie speed if the move to the outside horizontally
				enemy.velX = -enemy.velX
			end
			if enemy.body:getY()-5 < 0 and enemy.velY < 0 or enemy.body:getY()+5 > love.graphics.getHeight()-floorheight-10 and enemy.velY > 0 then -- reverse enemie speed if the move to the outside vertically
				enemy.velY = -enemy.velY
			end
		end
	end

	--------------------------------------------------JUMP EFFECT---------------------------------------
	if square > 20 then -- funky jump rezising
   objects.player.shape = love.physics.newRectangleShape( square, square) --updated square shape
   square = square-0.5
	else
   objects.player.shape = love.physics.newRectangleShape( 20, 20) --ususal	square shape
   square = 20
	end
	----------------------------------------------------------------------------------------------------
	for k, collA in ipairs(storage.collA) do -- calling our collision data
		for k, collB in ipairs(storage.collB) do
			colldec ("enemy", "", "bullet", "R", collA, collB) -- destroying everything that collided
			colldec ("enemy", "", "bullet", "DR", collA, collB)
			colldec ("enemy", "", "bullet", "D", collA, collB)
			colldec ("enemy", "", "bullet", "DL", collA, collB)
			colldec ("enemy", "", "bullet", "L", collA, collB)
			colldec ("enemy", "", "bullet", "UL", collA, collB)
			colldec ("enemy", "", "bullet", "U", collA, collB)
			colldec ("enemy", "", "bullet", "UR", collA, collB)
			if k > 10 then -- only store 10 collision files
				table.remove(storage.collB,k-10)
				table.remove(storage.collA,k-10)
			end
		end
	end

	use(bullet, "R") -- use every bullet
	use(bullet, "DR")
	use(bullet, "D")
	use(bullet, "DL")
	use(bullet, "L")
	use(bullet, "UL")
	use(bullet, "U")
	use(bullet, "UR")
end

function love.draw(dt)
	love.graphics.setColor(255,255,255,255) -- make it all white
	love.graphics.polygon("fill", objects.Ground.body:getWorldPoints(objects.Ground.shape:getPoints())) -- draw the ground
	love.graphics.polygon("fill", objects.player.body:getWorldPoints(objects.player.shape:getPoints())) -- draw the player

	for k, collA in ipairs(storage.collA) do -- printing collision data for testing purposes
		love.graphics.print(collA, k*70, 50)
	end
	for k, collB in ipairs(storage.collA) do
		love.graphics.print(collB, k*70, 50)
	end

	love.graphics.print (test("tree"), 50, 50) -- testing stuff

	for i, bullet in ipairs(objects.bullet.R) do -- drawing some bullets
  	if bullet.isDone == 1 then
			love.graphics.polygon("fill", bullet.body:getWorldPoints(bullet.shape:getPoints()))
    	love.graphics.print (bullet.fixture:getUserData(),100*i,90)
  	end
	end

	for i, bullet in ipairs(objects.bullet.DR) do -- drawing some bullets
  	if bullet.isDone == 1 then
			love.graphics.polygon("fill", bullet.body:getWorldPoints(bullet.shape:getPoints()))
    	love.graphics.print (bullet.fixture:getUserData(),100*i,95)
  	end
	end

	for i, bullet in ipairs(objects.bullet.D) do -- drawing some bullets
  	if bullet.isDone == 1 then
			love.graphics.polygon("fill", bullet.body:getWorldPoints(bullet.shape:getPoints()))
    	love.graphics.print (bullet.fixture:getUserData(),100*i,100)
  	end
	end

	for i, bullet in ipairs(objects.bullet.DL) do -- drawing some bullets
  	if bullet.isDone == 1 then
			love.graphics.polygon("fill", bullet.body:getWorldPoints(bullet.shape:getPoints()))
    	love.graphics.print (bullet.fixture:getUserData(),100*i,105)
  	end
	end

	for i, bullet in ipairs(objects.bullet.L) do -- drawing some bullets
  	if bullet.isDone == 1 then
			love.graphics.polygon("fill", bullet.body:getWorldPoints(bullet.shape:getPoints()))
    	love.graphics.print (bullet.fixture:getUserData(),100*i,110)
  	end
	end

	for i, bullet in ipairs(objects.bullet.UL) do -- drawing some bullets
  	if bullet.isDone == 1 then
			love.graphics.polygon("fill", bullet.body:getWorldPoints(bullet.shape:getPoints()))
    	love.graphics.print (bullet.fixture:getUserData(),100*i,115)
		end
	end

	for i, bullet in ipairs(objects.bullet.U) do -- drawing some bullets
  	if bullet.isDone == 1 then
			love.graphics.polygon("fill", bullet.body:getWorldPoints(bullet.shape:getPoints()))
    	love.graphics.print (bullet.fixture:getUserData(),100*i,120)
  	end
	end

	for i, bullet in ipairs(objects.bullet.UR) do -- drawing some bullets
  	if bullet.isDone == 1 then
			love.graphics.polygon("fill", bullet.body:getWorldPoints(bullet.shape:getPoints()))
  		love.graphics.print (bullet.fixture:getUserData(),100*i,125)
  	end
	end

	love.graphics.setColor(255,0,0,255) -- some red for our enemies

	for i, enemy in ipairs(objects.enemy) do  -- drawing some enemies
  	if enemy.isDone == 1 then
  		love.graphics.polygon("fill", enemy.body:getWorldPoints(enemy.shape:getPoints()))
			love.graphics.print(tostring(enemy.velY),600, 10*i)
			love.graphics.print(enemy.fixture:getUserData(),500, 10*i)
  		love.graphics.print(enemy.fixture:getUserData(),enemy.body:getX()+20, enemy.body:getY())
  	end
	end

end

function beginContact(a, b, coll)
if a:getUserData() =="bullet" or b:getUserData()=="bullet" then
		table.insert(storage.collA, a:getUserData()) --storing our collision data
		table.insert(storage.collB, b:getUserData())
end

 	if a:getUserData() == "Playa" and b:getUserData() == "Ground" or a:getUserData() == "Ground" and b:getUserData() == "Playa" then -- getting to know when the player touches the ground
 		sniggleJ = 1
	end
end

function endContact(a, b, coll)
end

function preSolve(a, b, coll)
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end
