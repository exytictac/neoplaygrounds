--[[local words = {"cunt", "fuck", "nigga", "sex", "rape", "asshole", "dick", "penis", "vagina", "white boy", "black boy", "gay", "bitch", "son of a bitch", "dickshit", "dickhole", "motherfucker", "your mother","afs sucks"}
local serverTag = "[AFS]"

addEventHandler("onPlayerChat", getRootElement(),
	function(message, messageType)
		censorUsed = false
		for _,word in pairs(words) do
			if string.find(string.lower(message),string.lower(word)) then
				cancelEvent()
				censorUsed = true
				local wordLength = string.len(word)
				message = string.gsub(string.lower(message), string.lower(word), string.rep("*", tonumber(wordLength)))
				Cmessage = string.gsub(string.lower(message), string.lower(word), string.rep("*", tonumber(wordLength)))
			end
		end
		
		if censorUsed == false then
			cancelEvent()
			Cmessage = message
		end
		
		-- Get the player class.
		local playerClass = exports.exports:getPlayerClass(source)
		local nameR, nameG, nameB = getPlayerNametagColor(source)
		
		if getElementData(source, "hideTag") == true then
			hexcode = "#ffff00"
			playerTag = ""
			nameR, nameG, nameB = 255,255,0
		elseif (playerClass == 1) then
			playerTag = ""
			hexcode = "#FFFF00"
		elseif (playerClass == 2) then
			hexcode = "#00FF00"
			playerTag = serverTag
		elseif (playerClass == 3) then
			hexcode = "#FF8800"
			playerTag = serverTag
		elseif (playerClass == 4) then
			playerTag = serverTag
			hexcode = "#FF0000"
		end

		-- Normal chat
		if (messageType == 0) then
			
			outputChatBox(playerTag .. string.gsub(getPlayerName(source):gsub('#%x%x%x%x%x%x', ''), "_", " ") .. ': ' .. "#FFFFFF" .. Cmessage:gsub('#%x%x%x%x%x%x', ''), getRootElement(), nameR, nameG, nameB, true)
			
			-- Register the message to the log.
			outputServerLog("CHAT: " .. getPlayerName(source) .. ": " .. message:gsub('#%x%x%x%x%x%x', ''))
		-- Messages with /me
		elseif (messageType == 1) then
			outputChatBox( '#ff8800 ' .. getPlayerName(source):gsub('#%x%x%x%x%x%x', '') .. '#ff8800 ' .. Cmessage:gsub('#%x%x%x%x%x%x', ''), getRootElement(), nameR, nameG, nameB, true)
			-- Register the message to the log.
			outputServerLog("ACTION: " .. getPlayerName(source) .. ": " .. message:gsub('#%x%x%x%x%x%x', ''))
		-- Team chat
		elseif (messageType == 2) then
			outputChatBox("To use team chat, please rebind Y to Special Chat and set your special chat to Team", source,255,0,0)
		end
	end
)]]

-- ****************************************
-- * Chat functions for members and staff *
-- ****************************************
function memberChat(thePlayer, command, ...)
	if (getElementData(thePlayer, "auth") >= 1) then
		-- Get the player class.
		local playerClass = getElementData(thePlayer, "auth")
		
		if (playerClass == 1) then
			hexcode = "#00FF00"
			playerTag = serverTag
		elseif (playerClass == 2) then
			hexcode = "#FF8800"
			playerTag = serverTag
		elseif (playerClass == 3) then
			playerTag = serverTag
			hexcode = "#FF0000"
		end
		
		local message = table.concat({...}, " ")
		for id, playerValue in ipairs(getElementsByType("player")) do
			if (getElementData(thePlayer, "auth") >= 1) then
				outputChatBox("#88FF00[MEMBER] " .. hexcode .. getPlayerName(thePlayer) .. ":#FFFFFF " .. message, playerValue, 0, 128, 255, true)
			end
		end
			
		-- Register the message to the log.
		outputServerLog( "MEMBERCHAT: " .. getPlayerName(thePlayer) .. ": " .. message:gsub('#%x%x%x%x%x%x', ''))
		-- Show in chatbubbles
		triggerClientEvent("onMessageIncome",thePlayer,message, "member")
	end
end
function staffChat(thePlayer, command, ...)
	if (getElementData(thePlayer, "auth") >= 2) then
		-- Get the player class.
		local playerClass = getElementData(thePlayer, "auth")
		
		if (playerClass == 2) then
			hexcode = "#FF8800"
			playerTag = serverTag
		elseif (playerClass == 3) then
			playerTag = serverTag
			hexcode = "#FF0000"
		end
		
		local message = table.concat({...}, " ")
		for id, playerValue in ipairs(getElementsByType("player")) do
			if (getElementData(playerValue, "auth") >= 2) then
				outputChatBox("#0088FF[STAFF] " .. hexcode .. getPlayerName(thePlayer) .. ":#FFFFFF " .. message, playerValue, 0, 128, 255, true)
			end
		end
			
		-- Register the message to the log.
		outputServerLog("STAFFCHAT: " .. getPlayerName(thePlayer) .. ": " .. message:gsub('#%x%x%x%x%x%x', ''))
		-- Show the bubble
		triggerClientEvent("onMessageIncome",thePlayer,message, "staff")
	end
end
addCommandHandler("staff", staffChat)
addCommandHandler("vip", memberChat) 

addCommandHandler("message",
	function(thePlayer, command, ...)
		if (exports.exports:getPlayerClass(thePlayer) >= 2) then
			local message = table.concat({...}, " ")
			outputChatBox(":" .. message, getRootElement(), 255, 255, 255, true)
		
			-- Register the message to the log.
			outputServerLog("INFOMESSAGE BY " .. getPlayerName(thePlayer) .. ": " .. message:gsub('#%x%x%x%x%x%x', ''))
		end
	end
)
--[[
addCommandHandler("Special Chat Channel",
	function(source, command, ...)
		local message = table.concat({...}, " ")
		censorUsed = false
		for _,word in pairs(words) do
			if string.find(string.lower(message),string.lower(word)) then
				cancelEvent()
				censorUsed = true
				local wordLength = string.len(word)
				message = string.gsub(string.lower(message), string.lower(word), string.rep("*", tonumber(wordLength)))
				Cmessage = string.gsub(string.lower(message), string.lower(word), string.rep("*", tonumber(wordLength)))
			end
		end
		
		if censorUsed == false then
			cancelEvent()
			Cmessage = message
		end
		
		-- Get the player class.
		local playerClass = exports.exports:getPlayerClass(source)
		local nameR, nameG, nameB = getPlayerNametagColor(source)
		
		if getElementData(source, "hideTag") == true then
			hexcode = "#ffff00"
			playerTag = ""
			nameR, nameG, nameB = 255,255,0
		elseif (playerClass == 1) then
			playerTag = ""
			hexcode = "#FFFF00"
		elseif (playerClass == 2) then
			hexcode = "#00FF00"
			playerTag = serverTag
		elseif (playerClass == 3) then
			hexcode = "#FF8800"
			playerTag = serverTag
		elseif (playerClass == 4) then
			playerTag = serverTag
			hexcode = "#FF0000"
		end
		
		preChat = tostring(getElementData(source, "specialChannel"))
		if preChat == "Gamemode" then
			preChat = "[GM]"
			for i,v in pairs (getElementsByType("player")) do
				if getElementData(v, "gamemode") == getElementData(source,"gamemode") then
					outputChatBox(preChat..playerTag .. getPlayerName(source):gsub('#%x%x%x%x%x%x', '') .. ': ' .. "#FFFFFF" .. Cmessage:gsub('#%x%x%x%x%x%x', ''), v, nameR, nameG, nameB, true)
				end
			end
		elseif preChat == "In Vehicle" then
			preChat = "[VEH]"
			veh = getPedOccupiedVehicle(source)
			if veh then
				local occupants = getVehicleOccupants(veh)
				local seats = getVehicleMaxPassengers(veh)
				for seat = 0, seats do
					local occupant = occupants[seat]
					if occupant and getElementType(occupant)=="player" then
						outputChatBox(preChat..playerTag .. getPlayerName(source):gsub('#%x%x%x%x%x%x', '') .. ': ' .. "#FFFFFF" .. Cmessage:gsub('#%x%x%x%x%x%x', ''), occupant, nameR, nameG, nameB, true)
					end
				end
			end
		elseif preChat == "Nearby" then
			-- nearby shit
		elseif preChat == "Team" then
			local playersInTeam = getPlayersInTeam(getPlayerTeam(source))
			local teamName = getTeamName(getPlayerTeam(source))
			for i, playerValue in pairs(playersInTeam) do
				outputChatBox("#00FF88[" .. teamName .. ']' .. hexcode .. playerTag .. getPlayerName(source):gsub('#%x%x%x%x%x%x', '') .. ': ' .. "#FFFFFF" .. message:gsub('#%x%x%x%x%x%x', ''), playerValue, nameR, nameG, nameB, true)
			end
			
			-- Register the message to the log.
			outputServerLog( "TEAMCHAT: " .. getPlayerName(source) .. ": " .. message:gsub('#%x%x%x%x%x%x', ''))
		elseif preChat == "Member" then
			memberChat(source, "member", message)
		elseif preChat == "Staff" then
			staffChat(source, "staff", message)
		else
		end
	end
)

addCommandHandler("ignore",
	function(thePlayer,cmd, ignorePlayerName)
	end
)
]]