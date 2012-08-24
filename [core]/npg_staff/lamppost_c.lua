
-- * Written by qaisjp (c) 2012

local screenWidth, screenHeight = guiGetScreenSize()
local lampPostMessage = ""
local lampPostDisplayed = false
local lpcolor = tocolor(0,255,0)

-- ******************
-- * Event handlers *
-- ******************
function drawLampPost(color)
	dxDrawText(lampPostMessage, 4, 4, screenWidth, screenHeight, tocolor(0, 0, 0, 128), 1, "bankgothic", "center", "center", true, true, true)
	dxDrawText(lampPostMessage, 0, 0, screenWidth - 4, screenHeight - 4, lpcolor, 1, "bankgothic", "center", "center", true, true, true)
end

addEvent("showLampPost", true)
addEventHandler("showLampPost", getRootElement(), 
	function(theMessage, color, timelimit)
		
		-- If it is not showing...
		if (lampPostDisplayed == false) then
			-- The variable is given to theMessage from lampPostMessage provided by the fuction.
			lampPostMessage = theMessage
			
			-- If a color variable was NOT passed then...
			if not color then
				lpcolor = tocolor(0,255,0)
			else -- If it was passed then...
				-- From the string get the 1st part.
				local colorR = gettok ( color, 1, string.byte(',') )
				-- From the string get the 2nd part.
				local colorG = gettok ( color, 2, string.byte(',') )
				-- From the string get the 3rd part.
				local colorB = gettok ( color, 3, string.byte(',') )
				-- Give the color variable converted from string's to numbers.
				lpcolor = tocolor(tonumber(colorR), tonumber(colorG), tonumber(colorB))
			end
			
			-- Add the event handler to show the message.
			addEventHandler("onClientPreRender", getRootElement(), drawLampPost)
			lampPostDisplayed = true
			
			-- If a timelimit was not passed then do the default time limit
			if not timelimit then
				setTimer(
					function()
						removeEventHandler("onClientPreRender", getRootElement(), drawLampPost)
						lampPostDisplayed = false
					end
				, 5000, 1)
			else -- If it was then do the passed timelimit
				setTimer(
					function()
						removeEventHandler("onClientPreRender", getRootElement(), drawLampPost)
						lampPostDisplayed = false
					end
				, timelimit, 1)
			end
		end
	end
)
