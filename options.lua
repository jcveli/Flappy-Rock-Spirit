-----------------------------------------------------------------------------------------
--
-- options.lua
--
-----------------------------------------------------------------------------------------
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


--include widgets for the slider for size and bounce 
local widget = require("widget")


--include the globals table from globals.lua
local g = require("globals")


--widgets being used in options.lua
--local in file so any function in options.lua can use it; no need to pass
local segmentControl, returnButton, playButton

-----------------------------------------------------------------------------------------------
--depending on the player's choice, will display a spirit object for a preview 
--of whatever color is chosen 
function updateSetting()
    if g.color == 1 then                            --Clear/no color
        spiritPreview:setFillColor(1)
    elseif g.color == 2 then                        --Navy Blue
        spiritPreview:setFillColor(0, 0, 139)
    elseif g.color == 3 then                        --yellow
        spiritPreview:setFillColor(1, 1, 0)
    elseif g.color == 4 then                        --red 
        spiritPreview:setFillColor(139, 0, 0)
    elseif g.color == 5 then                        --indigo 
        spiritPreview:setFillColor(75, 0, 130)
    end

    --will increase/decrease volume to whatever the user chooses 
    audio.setVolume(g.volume/100)


end

--Will return the global variable to the table to be used in any scene 
function OnSegmentPress( event )
    local target = event.target

    g.color = target.segmentNumber  --whatever color is choosen by the player is saved 

end


--Will play the choosen song by the player for them to listen to, to choose if they want 
--to play the chosen song in the game level
function onMusicPress(event)
    local target = event.target 

    g.music = target.segmentNumber 
   
    audio.stop()
    if g.music == 1 then
		gameMusic = audio.loadStream("Arcana.wav")          --Arcana music = 1 
	elseif g.music == 2 then 
		gameMusic = audio.loadStream("Adventure.wav")       --"adventure" music =  2
	elseif g.music == 3 then 
		gameMusic = audio.loadStream("Karupa.wav")          --Karupa music = 3
	end


    --Will play the choosen song by the player for them to listen to, to choose if they want 
    --to play the chosen song in the game level
	musicChannel = audio.play(gameMusic, {channel = 1 , loops = 1} )
end



--will continuously update the settings as the player is in the options.lua scene
function newFrame()
    updateSetting()
end



----------------------------------------------------------------------------------------------



function onReturnBtnRelease()
    composer.gotoScene("menu", "fade", 300 )

    return true
end


function onPlayBtnRelease()
    audio.stop()

    composer.removeScene("play")
    composer.gotoScene("play", "fade", 300)


    return true
end 


--------------------------------------------------------------------------------------------

--volume slider 
function volumeSlided( event )
    g.volume = event.value 
    vp.text = g.volume .. "%"
end


---------------------------------------------------------------------------------------------

--Creates the spirit object but as a preview; returns the object 
function makeSpiritPreview()
    --create the spirit object and resize it appropriately 
	spirit = display.newImage("spirit.png",50,50)
	spirit.aspect = spirit.width / spirit.height
	spirit.width = 60
	spirit.height = spirit.width / spirit.aspect
    
    spirit.x, spirit.y = xCenter , yCenter + 160        --sets the x and y coordinate of the spirit 

	return spirit
end


-------------------------------------SCENE FUNCTIONS-------------------------------------
function scene:create(event)
    local sceneGroup = self.view 


    --load background
    local background = display.newImageRect("optionBackground.png",display.actualContentWidth, display.actualContentHeight )
    background.anchorX = 0 
    background.anchorY = 0
    background.x = 0 + display.screenOriginX 
    background.y = 0 + display.screenOriginY
    
    
    --segment control for the color of the spirit
    segmentControl = widget.newSegmentedControl(
        {
            left = 3,
            top = yMin + 100, 
            segmentWidth = 63, 
            segments = {"None","Navy Blue", "Yellow", "Red", "Indigo"},
            defaultSegment = 1,
            labelColor = { default={1,1,1,1}, over = {0,0.3,0.8,1} },

            onPress = OnSegmentPress
        }
    )



    --slider for the volume control
    --will also display the current volume % on the go 
    volumeControl = widget.newSlider{
        top = display.screenOriginX + 140, 
		left = display.screenOriginY + 65,
        width = 270,
        value = g.volume,

        listener = volumeSlided
    }
    --event listener for the slider and text 
    volumeControl:addEventListener("slide", volumeSlided)                               
    v = display.newText("Volume", xMin + 50, yMin + 170, native.systemFont, 20 )
    vp = display. newText(g.volume .. "%", xMin + 250, yMin + 170, native.systemFont, 20 )



    --segment control for music choice 
    musicControl = widget.newSegmentedControl(
        {
            left = 3, 
            top = yMin + 250, 
            segmentWidth = 103, 
            segments = {"Arcana", "Adventure", "Karupa"},
            defaultSegment = 1, 
            labelColor = { default={1,1,1,1}, over = {1,0.3,0.2,1} },

            onPress = onMusicPress 
        }
    )

 

    --return button that will bring you back to the menu 
    returnButton = widget.newButton(
        {
            defaultFile = "backButton.png",
            onRelease = onReturnBtnRelease 
        }
    )
    returnButton.width, returnButton.height= 60,40
    returnButton.x, returnButton.y = xMin + 50, yMin + 50



    --play button that will bring you to play.lua scene
    playButton = widget.newButton(
        {
            defaultFile = "startButton.png",
            onRelease = onPlayBtnRelease 
        }
    )
    playButton.width, playButton.height= 60,40
    playButton.x, playButton.y = xMax - 50, yMin + 50




    --creates the spirit preview object in the middle of the screen 
    spiritPreview = makeSpiritPreview()
    

    
    -------------runtime listener functions--------------------------
    Runtime:addEventListener("enterFrame", newFrame)



    --------------------Scene groups----------------------------------
    sceneGroup:insert( background )
    sceneGroup:insert(segmentControl)
    sceneGroup:insert(returnButton)
    sceneGroup:insert(playButton)
    sceneGroup:insert(spiritPreview)
    sceneGroup:insert(volumeControl)
    sceneGroup:insert(v)
    sceneGroup:insert(musicControl)
    sceneGroup:insert(vp)
end



function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end




function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end



function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	


end



---------------------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------------------

return scene 