-----------------------------------------------------------------------------------------
--
-- menu.lua
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


--included composer
local composer = require("composer")
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"


--local buttons to be used
local playBtn, optionBtn, spiritStack

------------------------------------------------------------------------------------------
--button release functions

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
 

	-- go to play.lua scene
	composer.gotoScene( "play", "fade", 100 )
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function onOptionBtnRelease()
   
    --go to option menu scene
    composer.gotoScene("options", "fade", 300)
    
    return true
end

-------------------------------------------------------------------------------------------
--load assests 
function createBackground()
    --display background 
    local b = display.newImageRect("menuBackground.png", display.actualContentWidth, display.actualContentHeight )
     b.anchorX = 0 
     b.anchorY = 0
     b.x = 0 + display.screenOriginX 
    b.y = 0 + display.screenOriginY


    return b 
end



--Creates the title 
function createTitle()
    local t = display.newImageRect("title.png",250, 50)
    t.x, t.y = xCenter, yMin + 100


    return t 

end 




local sheetData = 
{
    width = 269, 
    height = 298, 
    numFrames = 19
}


sheet = graphics.newImageSheet("spiritTower.png", sheetData)


local sequenceData = 
{
    name = "stacking",
    start = 1, 
    count = 19,
    time = 2500,
    loopCount = 0, 
}

---------------------------------------------------------------------------------------------




--SCENE FUNCTIONS--

function scene:create(event)
    local sceneGroup = self.view 


    --display background, title 
    local background = createBackground()
    local title = createTitle()


    --displays spirit animation sprite 
    spiritStack = display.newSprite(sheet, sequenceData)
    spiritStack.x, spiritStack.y = xCenter +120 , yMax 
    spiritStack:play()


    --Displays button that will send the user to the play.lua scene when released
	playBtn = widget.newButton{
		label="Play Now",
		labelColor = { default={255}, over={128} },
		defaultFile ="button.png",
		overFile ="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
    }
    --play button coordinates 
	playBtn.x = xCenter
	playBtn.y = yCenter +190




    --creates a widget button that will load the options menu on release 
	optionBtn = widget.newButton{
		label="Options",
		labelColor = { default={255}, over={128} },
		defaultFile ="button.png",
		overFile ="button-over.png",
		width=154, height=40,
		onRelease = onOptionBtnRelease	-- event listener function
    }
    --option button coordinates 
	optionBtn.x = xCenter
    optionBtn.y = yCenter + 290

    --Scene group that will disappear all objects/UI when moved to another scene
    sceneGroup:insert( background )
    sceneGroup:insert(playBtn)
    sceneGroup:insert(optionBtn)
    sceneGroup:insert(title)
    sceneGroup:insert(spiritStack)
end



function scene:show(event)
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


function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
end




-----------------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene


