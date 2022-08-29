-----------------------------------------------------------------------------------------
--
-- classic.lua
--
-----------------------------------------------------------------------------------------
--------------LOCAL CONSTANTS---------------------
--constant variables used throughout 
local HEIGHT = display.contentHeight
local WIDTH = display.contentWidth
local xMin = display.screenOriginX
local yMin = display.screenOriginY
local xMax = xMin + WIDTH
local yMax = yMin + HEIGHT
local xCenter = (xMin + xMax) / 2
local yCenter = (yMin + yMax) / 2



local composer = require( "composer" )
local scene = composer.newScene()


local widget = require "widget"


local g = require("globals")

-------------------------------------------------------------------------------------------
--local variables that will be used throughout the play.lua file 
local spirit
local targets = display.newGroup() 
local coins = display.newGroup()
local scrollSpeed = -1 						--ground moving speed to the left 


--local sound files for certain conditions 
local flapSound
local pointSound 
local hitSound 
local gameOverSound 
local gameMusic

--------------------------------------------------------------------------------------------

--updates the spirits color depending on the choice made by the player in the options menu 
function updateColor()
	if g.color == 1 then                            --Clear/no color/original look
		spirit:setFillColor(1)
	elseif g.color == 2 then                        --Navy Blue
		spirit:setFillColor(0, 0, 139)
	elseif g.color == 3 then                        --yellow
		spirit:setFillColor(1, 1, 0)
	elseif g.color == 4 then                        --red 
		spirit:setFillColor(139, 0, 0)
	elseif g.color == 5 then						--indigo 
		spirit:setFillColor(75, 0, 130)
	end
end


---------------------Assest Functions-------------------------------------------------
function loadBackground()
	
	local b = display.newImageRect("classicBackground.png",display.actualContentWidth, display.actualContentHeight )
    b.anchorX = 0 
    b.anchorY = 0
    b.x = 0 + display.screenOriginX 
	b.y = 0 + display.screenOriginY
	
	return b
end 



--creates the spirit
function makeSpirit()
	--create the spirit object and resize it appropriately 
	spirit = display.newImage("spirit.png",50,50)
	spirit.aspect = spirit.width / spirit.height
	spirit.width = 60
	spirit.height = spirit.width / spirit.aspect

	spirit.vel = 0 
	spirit.gravity = 0.3 
	spirit.bounce = 0.7 

	spirit.score = 0 					--score keeper

	return spirit
end


--creates the purple targets the player wants to avoid and returns it 
function createTargets()
	local t = display.newImageRect("toxic_spirit.png", 70, 70)
	t.x, t.y = xMax + 100, math.random(yMin, yMax) 				--y values random between the displays min. and max height

	targets:insert(t)
	return t 
end 



--creates the coins the player wants to collect and returns it 
function createCoins()
	local c = display.newImageRect("coin.png", 70,70)
	c.x, c.y = xMax + 100, math.random(yMin, yMax) 		
	coins:insert(c)


	return c 
end  


--create the life indicator in the bottom-right hand of the screen 
function createLives()

	x = WIDTH - 60
	y = HEIGHT + 20
	lives = display.newImage("lives.png", x, y  )
	l = display.newText("x3", x +40 , y + 10, native.systemFont, 24 )

end


--------------------------Music function--------------------------------------

--loads the required sounds of the game
function loadSound()
	pointSound = audio.loadSound("point.wav")
	flapSound = audio.loadSound("flap.wav")
	hitSound = audio.loadSound("hit.wav")
	gameOverSound = audio.loadSound("game_over.wav")

	--depending on the choice of what the player made, it will play the selected song 
	--on an infinite loop until the user has to restart 
	if g.music == 1 then
		gameMusic = audio.loadStream("Arcana.wav")
	elseif g.music == 2 then 
		gameMusic = audio.loadStream("Adventure.wav")
	elseif g.music == 3 then 
		gameMusic = audio.loadStream("Karupa.wav")
	end

	musicChannel = audio.play(gameMusic, {channel = 1 , loops = -1} )
end



-----------------------------------------------------------------------------------
--score keeper function 
function updateScore()
	spirit.score = spirit.score + 1 
	c.text = "x" .. spirit.score
end

-----------------------------------------------------------------------------------

function scene:create( event )

	

    local sceneGroup = self.view 


	background = loadBackground()
	local cIcon = display.newImageRect("coin.png", 50, 50)
	cIcon.x, cIcon.y = xMin + 20 , HEIGHT + 25
	c = display.newText("x0",xMin + 50, HEIGHT + 30, native.systemFont, 24 )
	

	------------------creates the moving ground------------------------------------ 
	grass1 = display.newImageRect("grassBlock.png", display.actualContentWidth, 52)
	grass1.anchorX = 0
	grass1.anchorY = 1
	grass1.x = display.screenOriginX
	grass1.y = display.actualContentHeight + display.screenOriginY


	grass2 = display.newImageRect("grassBlock.png", display.actualContentWidth, 52)
	grass2.anchorX = 0
	grass2.anchorY = 1
	grass2.x = grass1.x + grass1.contentWidth
	grass2.y = display.actualContentHeight + display.screenOriginY

	
	grass3 = display.newImageRect("grassBlock.png", display.actualContentWidth, 52)
	grass3.anchorX = 0
	grass3.anchorY = 1
	grass3.x = grass2.x + grass2.contentWidth
	grass3.y = display.actualContentHeight + display.screenOriginY
	-------------------------------------------------------------------------------


	spirit = makeSpirit()
	createLives()
	lives.count = 3 

	--loads the sound and sets the volume to whatever the player choose 
	loadSound()
	audio.setVolume(g.volume/100)
	
--------------------------------------------------------------------------------------------------
	--when an object has fullfilled its purpose, it will be deleted
	function targetDone( obj )
		obj:removeSelf()
	end



	--when the player is hit by the purple spirit, their life count is depelted by 1 
	function updateLives()
		lives.count = lives.count - 1 
		l.text = "x" .. lives.count
		if lives.count == 0 then	--if life count hits 0, it's game over 
			print("game over") 
			gameOver()
		end 
	end


--------------------------------------------------------------------------------------------------
	function screenTouched(event)
		--When the screen is touched, the bird will gain velocity; move up
		if (event.phase == "began") then
			audio.play(flapSound)
			spirit.vel = -6
		end 
	end 	



	--this function will continously move the grass in the given speed 
	--will keep repositioning each grass block behind the other;like a never ending train
	local function moveGrass( event )
		grass1.x = grass1.x + scrollSpeed
		grass2.x = grass2.x + scrollSpeed 
		grass3.x = grass3.x + scrollSpeed
		
		if(grass1.x + grass1.contentWidth) < 0 then 
			grass1.x = xMax + grass3.x
		end 
	
		if(grass2.x + grass2.contentWidth) < 0 then 
			grass2.x = xMax + grass1.x
		end 
	
		if(grass3.x + grass3.contentWidth) < 0 then 
			grass3.x = xMax + grass2.x
		end 
	end



	--will move the spirit as if it is bouncing on the ground 
	function moveSpirit()
		--moves the spirit in its current velocity 
		spirit.y = spirit.y + spirit.vel

		--if the spirit passed the bottom during this frame, make it bounce 
		if (spirit.y > HEIGHT - 30) then
			spirit.y = spirit.y - spirit.vel   -- Undo the movement that went past the bottom
			spirit.vel = -spirit.vel * spirit.bounce   -- Reverse the velocity and apply bounce factor
		end

		--change the ball's current velocity over time by applying the gravity acceleration 
		spirit.vel = spirit.vel + spirit.gravity 


		--if the player goes off screen, it's an automatic game over
		if (spirit.y < -50) then
			gameOver()
			
		end
	end 

	
	
	function newFrame(event)
		--will launch purple spirits at random intervals 	
		if math.random() < 0.015 then 
			local t = createTargets()
			toxicTransition = transition.to(t, 
				{
					x = xMin - 50,
					time = math.random(900, 2000),
					onComplete = targetDone,
				}
			)
		end
		

		--will launch coins at random intervals; more common than purple spirits
		if math.random() < 0.025 then 
			local c = createCoins()
			coinTransition = transition.to(c, 
				{
					x = xMin - 50,
					time = math.random(900, 2000),
					onComplete = targetDone,
				}
			)
		end


		-----collison checks----------
		--will check if the spirit has collided with the purple spirit
		--if it did, lose a life and make a little explosion at the (x,y) coordinate 
		--it was hit at. 
		for i = targets.numChildren, 1, -1 do 
			local t = targets[i] 
			local s = spirit 
			local m = false 
			local temp = hitTest(s,t,m)
			if temp == true then
				audio.play(hitSound)
			
				updateLives()	

				--explosion 
				local explode = display.newImage("explosion", t.x, t.y)
				transition.to( explode,
					{
						y = 0, 
						alpha = 10, 
						time = 1000,
						onComplete = targetDone, 
					}
				
				)

				transition.cancel( t )
				t:removeSelf()
			end
		end		


		--if the spirit has collided with a coin, gain 1 point and update the score 
		for j = coins.numChildren, 1, -1 do 
			local t = coins[j] 
			local s = spirit 
			local m = true 
			local temp = hitTest(s,t,m)
			if temp == true then 
				audio.play(pointSound)
				updateScore()

				transition.cancel( t )
				t:removeSelf()
			end
		end


		
		updateColor()
		moveSpirit()
		moveGrass()

	end

	-------------------------------------------------------------------------------------------------
	--hit test for what the spirit has collided with 
	function hitTest( s, t, m )
		local mode = m 
		local temp 
		if mode == false then
			if math.abs(s.x - t.x) < 20 and math.abs(s.y - t.y) < 20 then
				temp = true 
			end
		elseif mode == true then 
			if math.abs(s.x - t.x) < 20 and math.abs(s.y - t.y) < 20 then
				temp = true
			end
		end
		return temp
	end
	------------------------------------------------------------------------------------------------
	--game over function that will be triggered when certain conditions are met 
	function gameOver()
		--play the game over sound and remove the event listeners to "stop" the game 
		audio.play(gameOverSound)
		Runtime:removeEventListener("enterFrame", newFrame)
		background:removeEventListener("touch", screenTouched)

		--display a game over prompt, remove the spirit obj 
		gameOverPrompt = display.newImage("game_over.png", xCenter, yCenter)
		targetDone(spirit)

		--prompt the tap the prompt text to restart the game level 
		local promptReplay = display.newText("Tap Here to Restart", xCenter, yCenter + 100)
		sceneGroup:insert(gameOverPrompt)
		sceneGroup:insert(promptReplay)


		--if the player taps the prompt, the game will remove its assests, stop the music, and
		--send the player back to the options menu 
		local function replay(event)
			if(event.phase == "began") then
				composer.gotoScene("options","fade",300)
				targetDone(c)
				targetDone(l)
				targetDone(cIcon)
				targetDone(lives)

				audio.stop(1)
				return true
			end
		end

		promptReplay:addEventListener("touch", replay)
	end
	-------------------------------------------------------------------------------------------------

	-----------------------------------event listeners--------------------------------------------- 	
	Runtime:addEventListener("enterFrame", newFrame)
	background:addEventListener("touch", screenTouched)

		
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( grass1 )
	sceneGroup:insert( grass2 )
	sceneGroup:insert( grass3 )
	sceneGroup:insert( spirit )
end 






function scene:hide( event )
    local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)

		--Pause the game when either buttons are released
		
		
		
		--scrollSpeed = 0 

		
		
	elseif phase == "did" then
		-- Called when the scene is now off screen
		
	
	end	
end 


function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	

	
end


-------------------------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene