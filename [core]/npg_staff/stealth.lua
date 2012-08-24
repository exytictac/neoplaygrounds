
-- ***********************************************
-- * AFS Staff / Stealth mode                    *
-- * Written by Tommy (c) 2010                   *
-- ***********************************************

-- ***************
-- *  Functions  *
-- ***************
function destroyBlipsAttachedTo(player)
	local attached = getAttachedElements(player)
	if (attached) then
		for k, element in ipairs(attached) do
			if (getElementType(element) == "blip") then
				destroyElement(element)
			end
		end
	end
end

function setStealthMode(thePlayer, command)
	if (getPlayerClass(thePlayer) >= 2) then
		if (getElementData(thePlayer, "stealthMode") == true) then
			if (getPlayerClass(thePlayer) < 5) then
				setPlayerNametagShowing(thePlayer, true)
			end
			setElementAlpha(thePlayer, 255)
			setElementData(thePlayer, "stealthMode", false, true)
			outputChatBox("#FF0000*INFO: #FFFF00You have left stealth mode.", thePlayer, 255, 100, 100, true)
			
			if (getPlayerClass(thePlayer) == 2) then
				createBlipAttachedTo(thePlayer, 0, 2, 64, 192, 255)
			elseif (getPlayerClass(thePlayer) == 3) then
				createBlipAttachedTo(thePlayer, 0, 2, 0, 128, 255)
			end
		else
			setPlayerNametagShowing(thePlayer, false)
			setElementAlpha(thePlayer, 0)
			setElementData(thePlayer, "stealthMode", true, true)
			outputChatBox("#FF0000*INFO: #FFFF00You are now in left stealth mode.", thePlayer, 255, 100, 100, true)

			if (getPlayerClass(thePlayer) == 2 or getPlayerClass(thePlayer) == 3) then
				destroyBlipsAttachedTo(thePlayer)
			end
		end
	else
		outputChatBox("You can't use this command.", thePlayer, 255, 0, 0, false)
	end
end
addEvent("triggerStealthMode", true)
addEventHandler("triggerStealthMode", getRootElement(), setStealthMode)

-- ****************************
-- * Add all command handlers *
-- ****************************
addCommandHandler("sm", setStealthMode)
