
-- ***********************************************
-- * AFS Staff / Lamp post                       *
-- * Written by Tommy (c) 2010                   *
-- ***********************************************

-- *****************
-- *   Functions   *
-- *****************
function showLampPost(thePlayer, command, ...)
	if (getPlayerClass(thePlayer) >= 1) then
		local theMessage = table.concat({...}, " ")
		triggerClientEvent("showLampPost", getRootElement(), theMessage)
	else
		outputChatBox("You can't use this command.", thePlayer, 255, 0, 0, false)
	end
end

-- ****************************
-- * Add all command handlers *
-- ****************************
addCommandHandler("lp", showLampPost)
