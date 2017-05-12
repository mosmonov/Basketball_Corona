-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)
 
local physics = require "physics"
physics.start()
physics.setGravity(0, 9.8)  -- 9.81 m/s*s in the positive x direction
physics.setScale(80)  -- 80 pixels per meter
physics.setDrawMode("normal")
local background = display.newImage("CourtBackground4.png")
background.x = display.contentWidth/2
background.y = display.contentHeight/2


local player1 = display.newText("Player 1", 120, 300)
player1:setTextColor(1, 1, 0)
player1.rotation = -360
player1.size = 25

local player2 = display.newText("Player 2", 320, 300)
player2:setTextColor(1, 1, 0)
player2.rotation = -360
player2.size = 25

local floor1Height = 8
local floor1 = display.newRect(240, display.contentHeight, display.contentWidth, floor1Height)
floor1:setFillColor(0, 0, 0)

local wallWidth = 2
local lWall = display.newRect(0, 155, wallWidth,display.contentHeight)
lWall:setFillColor(0, 0, 0)

local wallWidth=2
local rWall = display.newRect (480,155 , wallWidth, display.contentHeight)
rWall:setFillColor(0, 0, 0)

local ceilingHeight = 2
local ceiling = display.newRect(240,0, display.contentWidth, ceilingHeight)
ceiling:setFillColor(0, 0, 0)


 
staticMaterial = {density=2, friction=.3, bounce=.5}
physics.addBody(floor1, "static", staticMaterial)
physics.addBody(lWall, "static", staticMaterial)
physics.addBody(rWall, "static", staticMaterial)
physics.addBody(ceiling, "static", staticMaterial)

local vertPost = display.newRect (0.95*display.contentWidth, 0.70*display.contentHeight,10, 0.65*display.contentHeight-floor1Height)
vertPost:setFillColor(0,0,0)

local horizPost = display.newRect(vertPost.x-23, vertPost.y - 0.5*vertPost.height, 55, 5)
horizPost:setFillColor(0,0,0)

local backboard = display.newRect(horizPost.x-0.5*horizPost.width, horizPost.y-25, 4, 98)
backboard:setFillColor(0,0,0)
-- Create the goal
local rimMiddle = display.newRect (backboard.x-33, horizPost.y,50, 4)
rimMiddle:setFillColor(0,0.6,0.7)

local rimBack = display.newRect(rimMiddle.x+rimMiddle.width/2, horizPost.y, 10, 4)
rimBack:setFillColor(207,67,4)

local rimFront = display.newRect(rimMiddle.x-rimMiddle.width/2-3, horizPost.y, 8, 4)
rimFront:setFillColor(207, 67, 4)

physics.addBody(vertPost, "static", staticMaterial)
physics.addBody(horizPost, "static", staticMaterial)
physics.addBody(backboard, "static", staticMaterial)
physics.addBody(rimBack, "static", staticMaterial)
physics.addBody(rimFront, "static", staticMaterial)

 
--Create the Ball
local ball = display.newCircle(50, 200, 14)
ball:setFillColor(1,0, 0)
 
physics.addBody(ball, {density=.8, friction=.4, bounce=.6, radius=10})
local speedX = 0
local speedY = 0
local prevTime = 0
local prevX = 0
local prevY = 0



local function drag( event )
	local ball = event.target
	
	local phase = event.phase

	if "began" == phase then

	 display.getCurrentStage():setFocus( ball )
 
		
		ball.x0 = event.x - ball.x
		ball.y0 = event.y - ball.y
		
		event.target.bodyType = "kinematic"
		
		 event.target:setLinearVelocity( 0, 0 )
        event.target.angularVelocity = 0
		
	    else
        if "moved" == phase then
            ball.x = event.x - ball.x0
            ball.y = event.y - ball.y0

	   elseif "ended" == phase or "cancelled" == phase then
            display.getCurrentStage():setFocus( nil )
            event.target.bodyType = "dynamic"
			
		ball:setLinearVelocity(speedX, SpeedY)

	  end
	  end
	return true
	end
	
	
	 function trackVelocity(event)

		local timePassed = event.time - prevTime
		prevTime = prevTime + timePassed

		speedX = (ball.x - prevX) / (timePassed / 1000)
		speedY = (ball.y - prevY) / (timePassed / 1000)

		prevX = ball.x
		prevY = ball.y
	end

	Runtime:addEventListener("enterFrame", trackVelocity)

	ball:addEventListener("touch", drag)
	
	local score = display.newText("score: 0", 45, 20)
	score:setTextColor(1,1,0)
	score.size=20

	scoreVal = 0
	local lastGoalTime = 1000
	function monitorScore(event)
		if event.time-lastGoalTime>500 then
			if ball.x>rimFront.x+rimFront.width and ball.x<rimBack.x-rimBack.width
			and ball.y>rimMiddle.y and ball.y<rimMiddle.y+10 then
			scoreVal=scoreVal+1
			lastGoalTime=event.time
			score.text = "Score: " ..scoreVal
			end
		end
	end

	Runtime:addEventListener("enterFrame", monitorScore)
