

LvlObj{
    var = "a",
	body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()-floorheight/2), --body, middle of shape will be at coordinate
	shape = love.physics.newRectangleShape(love.graphics.getWidth(), floorheight), --floor is ... high and all over the screen
	userdata = "Ground"
    }
    
LvlObj{
	var = "b",
    body = love.physics.newBody(world, math.random(100, love.graphics.getWidth()/2-100), math.random(50, love.graphics.getHeight()-2*floorheight)),
	shape = love.physics.newRectangleShape(200,floorheight),
	userdata = "Ground"
    }
    