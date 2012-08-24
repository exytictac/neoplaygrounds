
-- ******************************************
-- * AFS Staff / Anti spam                  *
-- * Written by Tommy (c) 2010              *
-- ******************************************

local playerTickCount = { }
local playerIsTalking = { }
local playerMessagesCount = { }
local playerMuteTimer = { }

function unmutePlayer(thePlayer)
	-- Unmute the player.
	setPlayerMuted(thePlayer, false)
	playerMuteTimer[thePlayer] = nil
	-- Display a message in the chatbox and Debug box.
	outputDebugString("*SPAM: ".. getPlayerName(thePlayer) .. " has been unmuted.", 3)
	--triggerClientEvent(thePlayer, "showLampPost", getRootElement(), "YOU HAVE BEEN UNMUTED \n\n DO NOT SPAM NEXT TIME",255,0,0 )
	
end

function mutePlayer(thePlayer)
	-- Mute the player for 30 seconds.
	setPlayerMuted(thePlayer, true)
	playerMuteTimer[thePlayer] = setTimer(unmutePlayer, 30000, 1, thePlayer)
	
	-- Display a message in the chatbox and debug box
	outputDebugString("*SPAM: ".. getPlayerName(thePlayer) .. " has been muted for nick spamming.", 3)
	--triggerClientEvent(thePlayer, "showLampPost", getRootElement(), " YOU HAVE BEEN MUTED FOR NICK FLOODING \n\n DO NOT SPAM",255,0,0)
end

addEventHandler("onPlayerChangeNick", getRootElement(),
	function(message)
		playSoundFrontEnd ( getRootElement(), 33 )
		if (not playerIsTalking[source]) then
			-- The player is talking.
			playerIsTalking[source] = true
			playerTickCount[source] = getTickCount()
		else
			-- The player is still talking. We check the time between each post.
			if (getTickCount() - playerTickCount[source] > 4500) then
				-- The player is not spamming.
				playerTickCount[source] = getTickCount()
				playerMessagesCount[source] = 0
			else
				if (playerMessagesCount[source] == nil) then
					playerMessagesCount[source] = 0
				end
			
				-- Check the numbers of posts.
				if (playerMessagesCount[source] >= 2) then
					-- The player is spamming. We mute him.
					playerTickCount[source] = getTickCount()
					cancelEvent()
					mutePlayer(source)
					
					-- Do a report to the staff log.
				--	triggerEvent("reportToStaffLog", getRootElement(), source, "Spam", tostring(playerMessagesCount[source]) .. " messages in 2 seconds")
				end
				
				playerMessagesCount[source] = playerMessagesCount[source] + 1
			end
		end
	end
)

addEventHandler("onPlayerJoin", getRootElement(),
	function()
		playerIsTalking[source] = false
		playerMuteTimer[source] = nil
		playerMessagesCount[source] = 0
	end
)

addEventHandler("onResourceStop", getResourceRootElement(),
	function()
		local playersList = getElementsByType("player")
		for i, thePlayer in pairs(playersList) do
			if (playerMuteTimer[thePlayer] ~= nil) then
				setPlayerMuted(thePlayer, false)
			end
		end
	end
)
