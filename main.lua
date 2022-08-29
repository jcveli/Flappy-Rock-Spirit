--[[---------------------------------------------------------------------------------------
--
-- main.lua


========================================================================================
    Welcome! Before playing, please not that this is best played on a phone with a resolution
of 1080 x 1920 such as an iPhone 6 Plus. 
    This game is titled "Flappy Spirit", a "parody" of the game 'Flappy Bird'. The game is simple:
    collect as many coins as you can while avoiding the purple spirits coming at you. Tap the screen 
    to make your spirit go up to gain. BUT you cannot go off screen, beyond the screens height, or its 
    an automatic game over. There is also a bounce factor when your spirit hits the ground. 
     If you are hit, you will lose a life; tou have 3 lives in the beginning. If you lose all 3, it is game over. If you
    exit out by tapping in the game over text prompt, you will be redirected to the options menu for you to 
    change any options such as the color of the spirit, volume control, and/or the music being played in the game. 
    
    The game is structued as followed:
    + menu.lua -> options.lua or play.lua [will take you straight to the game] 
    + There is also a main.lua [here] and a globals.lua file that carries globals table that holds
    the music number[selection], volume number, spirit color number, etc. 

    Items in this program are as followed:
    +(5) Transition animations (transition.to) (at least 2 different types)
    +(5) Manual frame animation or manual collision detection in the enterFrame event
    +(5) Sprite animation or use of image sheets
    +(5) Changing text display (e.g. score readout)
    +(5) Touch events (touch or tap)
    +(5) Sound effects (at least 3 different ones)
    +(5) Background music with an on/off switch or volume slider 
    +(10) Composer multi-scene management (at least 3 scenes)
    +(5) Hide/show UI objects (use .isVisible to make buttons and other items come and go)?
    +(5) Button, Slider and/or Switch (any combination 5 points max)
    +(5) Segmented control
    +(5) Native text field
    TOTAL Possible Coding Item Points: 65 
    
-----------------------------------------------------------------------------------------
]]



display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )


