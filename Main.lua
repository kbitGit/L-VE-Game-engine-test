debug = true
love.window.setFullscreen(true)
meter = 20 -- scale of the world
world = love.physics.newWorld(0, 9.81*10*meter, true) --no horizontal grav, 9.81m/s² vertically
floorheight = 40
bulletNormVel = 70000 -- how fast a bullet usually is
objects = {}
objects.Ground = {}

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
local bulletsHandle = require "Bullet"
local enemyHandle = require "Enemy"


function handleUserInput()
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

	if love.keyboard.isDown('kp6') or love.keyboard.isDown('right') and not love.keyboard.isDown('up') and not love.keyboard.isDown('down') then -- I'm firin' mah bullets
		bulletsHandle.shoot(bullets, "R")
	else sniggleR = 1
	end

	if love.keyboard.isDown('kp3') or love.keyboard.isDown('right') and love.keyboard.isDown('down')then -- I'm firin' mah bullets
		bulletsHandle.shoot(bullets, "DR")
	else sniggleDR = 1
	end

	if love.keyboard.isDown('kp2') or love.keyboard.isDown('down')  and not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then-- I'm firin' mah bullets
		bulletsHandle.shoot(bullets, "D")
	else sniggleD = 1
	end

	if love.keyboard.isDown('kp1') or love.keyboard.isDown('down') and love.keyboard.isDown('left')then -- I'm firin' mah bullets
		bulletsHandle.shoot(bullets, "DL")
	else sniggleDL = 1
	end

	if love.keyboard.isDown('kp4') or love.keyboard.isDown('left') and not love.keyboard.isDown('up') and not love.keyboard.isDown('down')  then -- I'm firin' mah bullets
		bulletsHandle.shoot(bullets, "L")
	else sniggleL = 1
	end

	if love.keyboard.isDown('kp7') or love.keyboard.isDown('up') and love.keyboard.isDown('left')then -- I'm firin' mah bullets
		bulletsHandle.shoot(bullets, "UL")
	else sniggleUL = 1
	end

	if love.keyboard.isDown('kp8') or love.keyboard.isDown('up')   and not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then -- I'm firin' mah bullets
		bulletsHandle.shoot(bullets, "U")
	else sniggleU = 1
	end

	if love.keyboard.isDown('kp9') or love.keyboard.isDown('up') and love.keyboard.isDown('right')then -- I'm firin' mah bullets
		bulletsHandle.shoot(bullets, "UR")
	else sniggleUR = 1
	end
end




function LvlObj (b) 
    objects.Ground[b.var] = {}
    objects.Ground[b.var].body = b.body
    objects.Ground[b.var].shape = b.shape
    objects.Ground[b.var].fixture = love.physics.newFixture(objects.Ground[b.var].body, objects.Ground[b.var].shape)
    objects.Ground[b.var].fixture:setUserData(b.userdata)
    end

function love.load(arg) -- loading stuff. Duh.
	math.randomseed(os.time()) -- makes random stuff more random
	love.physics.setMeter(meter) --1 Meter = ...
	storage = {} -- some tables
	storage.collA = {}
	storage.collB = {}
    ---

    ---
	objects.player = {}
	objects.player.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "dynamic")
	objects.player.shape = love.physics.newRectangleShape( meter, meter)
	objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape, 1)
	objects.player.fixture:setRestitution(0)
	objects.player.speedX = 0
	objects.player.speedY = 0
	objects.player.fixture:setUserData("Playa")

	objects.bullets = {}
	objects.enemy = {}
	enemyHandle.SpawnEnemy(enemy)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve) -- making collisison detection possible
    
    --dofile("level0")
    require "level0"
end


function love.update(dt)

	world:update(dt) -- gets the physics going

	handleUserInput()
	enemyHandle.UpdateEnemy(enemy)
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
		enemyHandle.killEnemy("enemy",collA)
		if k > 10 then -- only store 10 collision files
			table.remove(storage.collA,k-10)
		end
	end
	bulletsHandle.use(bullets) -- use every bullet

end

function love.draw(dt)
	love.graphics.setColor(255,255,255,255) -- make it all white
	love.graphics.polygon("fill", objects.player.body:getWorldPoints(objects.player.shape:getPoints())) -- draw the player
    
    for g, grnd in pairs(objects.Ground) do
        love.graphics.polygon("fill", grnd.body:getWorldPoints(grnd.shape:getPoints())) -- draw the ground
    end

	for k, collA in ipairs(storage.collA) do -- printing collision data for testing purposes
		love.graphics.print(collA, k*70, 50)
	end
	for k, collB in ipairs(storage.collA) do
		love.graphics.print(collB, k*70, 50)
	end

	--love.graphics.print (test("tree"), 50, 50) -- testing stuff

	for i, bullet in ipairs(objects.bullets) do -- drawing some bullets
  	if bullet.isDone == 1 then
			love.graphics.polygon("fill", bullet.body:getWorldPoints(bullet.shape:getPoints()))
    	love.graphics.print (bullet.fixture:getUserData(),100*i,90)
  	end
	end
	enemyHandle.DrawEnemy(enemy)

end

function beginContact(a, b, coll)

	
     if string.match(a:getUserData(),"bullets") then
        table.insert(storage.collA, b:getUserData()) --storing our collision data
	end
	if string.match(b:getUserData(),"bullets")then
        table.insert(storage.collA, a:getUserData())
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
