--[[GAMEMODE SELECTOR]]--
local sx,sy = guiGetScreenSize()
addEvent ( "showClientGamemodeGUI", true )
local options = {rollover={right=false,left=false} }
gui[4] = { }

gui[4]["text"] = guiCreateLabel ( (sw / 2) - (250 * wp), sh * 0.7, 500 * wp, 100 * wp, "", false )
guiLabelSetHorizontalAlign ( gui[4]["text"], "center" )
guiLabelSetVerticalAlign ( gui[4]["text"], "center" )
guiSetFont ( gui[4]["text"], guiCreateFont( "FortuneCity.ttf", 50 ) )
guiLabelSetColor ( gui[4]["text"], 0, 0, 0 )
guiSetVisible ( gui[4]["text"], false )
player = getLocalPlayer ( )
local button

local function eventEnter(source, i)
	if guiGetAlpha ( source ) < 0.75 or not guiGetEnabled ( source ) then
		return
	end
	Animation.createAndPlay(source,
		Animation.presets.guiMoveResize(
			(sw / 2) + (i * (iconWidth * 1.75 * wp)) - (iconWidth * 0.875),
			(sh / 2) - (iconHeight * 0.875),
			iconWidth * 1.75, iconHeight * 1.75
			, 100
		)
	)
	guiSetText ( gui[4]["text"], gmNames[i][1] )
end

local function eventLeave(source, i)
	if not source or getElementData(source, 'gm:disabled') then
		return
	end
	Animation.createAndPlay(source,
		Animation.presets.guiMoveResize(
			(sw / 2) + (i * (iconWidth * 1.75 * wp)) - (iconWidth / 2),
			(sh / 2) - (iconHeight / 2),
			iconWidth, iconHeight,
			100
		)
	)
	guiSetText ( gui[4]["text"], "" )
end

local function animationClick(button, i)
	Animation.createAndPlay(button,
		Animation.presets.guiMoveResize(
			(sw / 2) - iconWidth,
			(sh / 2) - iconHeight,
			iconWidth * 2.5,
			iconHeight * 2.5,
			250
		)
	)
	
	setTimer ( guiSetPosition, 250, 1, button, (sw / 2) - iconWidth, (sh / 2) - iconHeight, false )
	guiSetEnabled ( button, false )
	setTimer ( guiSetSize, 250, 1, button, iconWidth * 2.5, iconHeight * 2.5, false )
	triggerEvent ( "onClientPlayerSelectGamemode", player, gmNames[i][1]:lower() )
	triggerServerEvent("onPlayerSelectGamemode", player, gmNames[i][1]:lower())
	hideCenterStrip()
	setElementData(player, "gamemode", gmNames[i][1]:lower(), true)
	setTimer(
		function()
			Animation.createAndPlay(gui[4]["button"..tostring(i)], Animation.presets.guiFadeOut(750))
		end
	, 200, 1)
	setTimer(guiSetVisible, 1260, 1, button, false)
	guiSetVisible ( gui[4]["text"], false )
end




local function eventClick(source, i)
	if guiGetAlpha ( source ) < 0.75 or not guiGetEnabled(source) then
		return
	end
	guiSetEnabled ( source, false )
	guiSetText ( gui[4]["text"], "" )
	
	for v = -2, 2 do
		if (v ~= i) then
			Animation.createAndPlay(gui[4]["button"..v],
				Animation.presets.guiMoveResize(
					(sw / 2) + (i * (iconWidth * 1.75 * wp)),
					(sh / 2), 
					0, 0, 250
				)
			)
			setTimer(destroyElement,950, 1, gui[4]["button"..v])
		end
	end
	Animation.createAndPlay(gui[4]["backButton"], Animation.presets.guiFadeOut(500) )
	setTimer(destroyElement, 550, 1, gui[4]["backButton"])
	Animation.createAndPlay(gui[4]["nextButton"], Animation.presets.guiFadeOut(500) )
	setTimer(destroyElement, 550, 1, gui[4]["nextButton"])
	
	setTimer(animationClick, 100, 1, source, i)
end

function rolloverImage()
	if source == gui[4]['nextButton'] then
		guiStaticImageLoadImage(gui[4]['nextButton'], "images/nav/right" .. (options.rollover.right and "" or "Hover") .. ".png")
		options.rollover.right = not options.rollover.right
	elseif source == gui[4]['backButton'] then
		guiStaticImageLoadImage(gui[4]['backButton'], "images/nav/left" .. (options.rollove.left and "" or "Hover") .. ".png")
		options.rollover.left = not options.rollover.left
	end
end


function eventGamemode()
	guiSetVisible ( gui[4]["text"], true )
	for i = -2, 2 do
				gui[4]["button"..i] = guiCreateStaticImage ( 
					(sw / 2) + (i * (iconWidth * 1.75 * wp)) - (iconWidth / 2),
					(sh / 2) - (iconHeight / 2),
					iconWidth, iconHeight,
					("images/icons/"..gmNames[i][1]:lower ( )..".png"):gsub(' ','-')
					, false
				)
				guiSetAlpha(gui[4]['button'..i], 0)
										
				Animation.createAndPlay ( gui[4]["button"..i], Animation.presets.guiFadeIn ( 500 ) ) 
				addEventHandler ( "onClientMouseEnter", gui[4]["button"..i], function() eventEnter(source, i) end, false)
				addEventHandler ( "onClientMouseLeave", gui[4]["button"..i], function() eventLeave(source,i) end, false)
				addEventHandler ( "onClientGUIClick",  gui[4]["button"..i], function() eventClick(source, i) end, false)
	end
	
	gui[4]['backButton'] = guiCreateStaticImage(0.0015, 0.4655, 57, 70, "images/nav/left.png", true)	
	guiSetSize(gui[4]['backButton'], 57, 70, false)
	Animation.createAndPlay ( gui[4]["backButton"], Animation.presets.guiFadeIn ( 500 ) )
	guiSetAlpha(gui[4]['backButton'], 0.1)
	guiSetEnabled(gui[4]['backButton'], false)
	
	addEventHandler("onClientMouseEnter", gui[4]['backButton'], rolloverImage, false)
	addEventHandler("onClientMouseLeave", gui[4]['backButton'], rolloverImage, false)
	
	gui[4]['nextButton'] = guiCreateStaticImage(0.953, 0.465, 57, 70, "images/nav/right.png", true)	
	Animation.createAndPlay ( gui[4]["nextbutton"], Animation.presets.guiFadeIn ( 500 ) )
	guiSetSize(gui[4]['nextButton'], 57, 70, false)
	addEventHandler("onClientMouseEnter", gui[4]['nextButton'], rolloverImage, false)
	addEventHandler("onClientMouseLeave", gui[4]['nextButton'], rolloverImage, false)
end
--addEventHandler ( "onClientPlayerLogin", player, eventGamemode)


local gamemodeTimer
function hideGamemodeIcons()
	Animation.createAndPlay ( gui[4]['backButton'], Animation.presets.guiFadeOut ( 500 ) ) 
	Animation.createAndPlay ( gui[4]['nextButton'], Animation.presets.guiFadeOut ( 500 ) ) 
	setTimer ( destroyElement, 500, 1, gui[4]['nextButton'] )
	setTimer ( destroyElement, 500, 1, gui[4]['backButton'] )
	for i=-2,2 do
		Animation.createAndPlay ( gui[4]["button"..i], Animation.presets.guiFadeOut ( 500 ) ) 

		setTimer ( destroyElement, 500, 1, gui[4]["button"..i] )
		gamemodeTimer = setTimer ( function() gamemodeTimer = false end,550,1)
	end
	guiSetVisible ( gui[4]["text"], false )
end
addEventHandler ( "showClientGamemodeGUI", getRootElement(), eventGamemode)

bindKey ( "f3", "down", function()
		if gamemodeTimer then return end
		local state = isElement(gui[4]['button1'])
		guiSetInputEnabled ( not state )
		--showCursor( not state)
		if state then
			hideGamemodeIcons()
		else
			eventGamemode()
		end
	end
)