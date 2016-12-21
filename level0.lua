

LvlObj{
    var = "a",
	body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()-floorheight/2), --body, middle of shape will be at coordinate
	shape = love.physics.newRectangleShape(love.graphics.getWidth(), floorheight), --floor is ... high and all over the screen
	userdata = "Ground"
    }
    
LvlObj{
	var = "b",
    body = love.physics.newBody(world, (love.graphics.getWidth()/2-100)/2, love.graphics.getHeight()-300),
	shape = love.physics.newRectangleShape(love.graphics.getWidth()/2-100,floorheight),
	userdata = "Ground"
    }
    
LvlObj{
	var = "c",
    body = love.physics.newBody(world, (3*love.graphics.getWidth()/2+100)/2, love.graphics.getHeight()-300),
	shape = love.physics.newRectangleShape(love.graphics.getWidth()/2-100,floorheight),
	userdata = "Ground"
    }
    
