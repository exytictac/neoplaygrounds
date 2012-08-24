-- Based on that of interstate69

--[[
HOW TO USE:

CLIENT:
sendMessage(string theText, int red, int green, int blue)

SERVER:
sendMessage( player, text, red, green, blue )
sendGlobalMessage( text, red, green, blue)


theText: the desired string of text
theFont: the desired font
red: amount of red (0-255)
green: amount of green (0-255)
blue: amount of blue (0-255)

]]

addCommandHandler('n', function(_, ...) displayGUItextToPlayer(...) end)

local theTexts, nT, nbActive, alpha, blinking, scrolling, scrollsize, isVisible, blinkingTimer = {}, 0, true
local sX, sY = guiGetScreenSize()
local font = "default-large-bold"
function sendMessage(text, r, g, b)
	if not nbActive then return end
	alpha = 0.8 --the starting alpha
	r,g,b = tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 0
	if not ( blinking ) then --if theres no blinking marker
		blinking = guiCreateLabel(0.9, 0.8, 0,0, "  _", true) --create one
		guiLabelSetColor(blinking, 0, 255, 0) --color used for interstate69
		guiSetFont(blinking, font) --set font to match the rest
		guiSetSize(blinking, guiLabelGetTextExtent(blinking), guiLabelGetFontHeight(blinking), false) --set the size as big as it needs to be
		isVisible = true --tell the script its currently visible
		blinkingTimer = setTimer(flashBlink, 200, 0) --start blinking it
	end
	if isTimer(scrolling) then --if a text is currently scrolling
		killTimer(scrolling) --stop it
		scrolling = nil --make sure the element is really gone

		guiSetSize ( theTexts[nT], guiLabelGetTextExtent ( theTexts[nT] ), guiLabelGetFontHeight ( theTexts[nT] ), false ) --set the text size as big as it should be
	end
	if isElement(theTexts[1]) then --if theres a text item
		local i = #theTexts --get the amount of text items
		while i > 0 do --start from the number of text items, count down to 0
			if i <= 0 then --safety check
				break --break the loop in case something's gone wrong.
			end
			local x, y = guiGetPosition(theTexts[i], false) --get the position of the current text item

			local fy = guiLabelGetFontHeight(theTexts[i])+6 --get the font height

			guiSetPosition(theTexts[i], x, y - fy, false) --move the text one step up
			guiSetAlpha(theTexts[i], alpha) --set the alpha
			alpha = alpha - 0.2 --make the alpha smaller on the next item
			i = i - 1 --count down
		end
	end
	if nT < 5 then --if theres less than 5 text items
		nT = nT + 1 --count up
	else --if there are 5 or more items
		destroyElement(theTexts[1]) --destroy the first item
		table.remove(theTexts, 1) --remove it from the table
	end
	theTexts[nT]  = guiCreateLabel(0.0155, 0.27, 0, 0, text, true) --create text
	guiSetFont(theTexts[nT], font)
	guiLabelSetColor(theTexts[nT], r, g, b) --set the color of the text
	
	local x, y = guiGetPosition(theTexts[nT], false) --get the position

	local fx = guiLabelGetTextExtent(theTexts[nT]) --get the lenght of the text item
	local size = ( x + fx ) - sX --calculate a new position for the text, so it wont go off screen
	local margin = 0.05 * sX --add a margin
	local move = size + margin --calculate the total move

	guiMoveToBack(theTexts[nT])
	guiSetPosition(blinking, x - move, y, false) --set the blinking marker at the same place
	
	guiSetSize(theTexts[nT], 0, 0, false) --set the size to 0 again (for scrolling)
	scrollsize = 0
	typeFirstCharacter = true
	scrolling = setTimer(startScroll, 50, 0) --set a timer to start scrolling
end
addEvent("noticeBoard:send", true)
addEventHandler("noticeBoard:send", root, sendMessage)

function startScroll () --scroll function
	if typeFirstCharacter == true then
		setTimer ( playSoundFrontEnd, 100, 3, 42 )
		typeFirstCharacter = false
	end
	local x = guiLabelGetTextExtent(theTexts[nT]) --get the lenght of the text
	if scrollsize < x then --if scrollsize is smaller than the text lenght
		scrollsize = scrollsize + 10 --add 10 pixels
	else
		scrollsize = x --if scollsize is bigger than the text lenght, tell it to set scrollsize the same size as the text lenght (we dont want it bigger!)
		killTimer(scrolling) --kill the timer
		scrolling = nil --make sure the element is deleted
		destroyElement(blinking)
		killTimer(blinkingTimer)

		blinking, isVisible = false, false
	end
	guiSetSize(theTexts[nT], scrollsize, guiLabelGetFontHeight ( theTexts[nT] ), false)
	local x, y = guiGetPosition(theTexts[nT], false) --get current position
	if blinking then
		guiSetPosition(blinking, x + scrollsize, y, false)
	end
end

function flashBlink () --blinking marker function
	if not blinking then return end
	if isVisible == true then --if its currently visible
		guiSetVisible(blinking, false) --set it invisible
		isVisible = false --tell the script its hidden
	else --if its hidden
		guiSetVisible(blinking, true) --set it visible
		isVisible = true --tell the script its visible
	end
end

 _ = sendMessage

addCommandHandler("troll", function(_,mm)
			sendMessage(string.format("Random number generated: %s", mm or math.random(1,1337)))
	end
)

addCommandHandler('nb', function()
		nbActive = not nbActive
		
		if nbActive then return end
		destroyElement(blinking)
		killTimer(blinkingTimer)

		blinking, isVisible = false, false
		nT = 0
		for i,v in ipairs(theTexts) do
			destroyElement(v)
		end
		if scrolling then killTimer(scrolling) end scrolling=nil
		theTexts = {}
	end
)