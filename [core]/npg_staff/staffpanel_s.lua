-- * Written by Tommy                       *
-- * Made for NPG use                       *
-- ******************************************

addCommandHandler("staffpanel",
	function(source)
		if getElementData(source, "auth") >= 2 then
			triggerClientEvent(source, "openModPanel", getRootElement())
		end
	end
)

addCommandHandler("warn",
	function(thePlayer, command, thePlayerToWarn, ...)
		if getElementData(thePlayer, "auth") >= 2 then
			if (thePlayerToWarn) and ( ... ) then
				args = {...}
				local warnText = table.concat(args, " ")
				if thePlayerToWarn == "" then
					thing = getRootElement()
				else
					thing = getPlayerFromName(thePlayerToWarn)
				end
				triggerClientEvent(thing, "showLampPost", getRootElement(), string.gsub(getPlayerName(thePlayer):gsub('#%x%x%x%x%x%x', ''), "_", " ").." warns: " .. warnText, "255,0,0", 5000 )
			else
				outputChatBox("#ff0000*STAFF: #ffff00Syntax: /warn [player] [message]", thePlayer, 2,43,4, true)
			end
		else
			outputChatBox("You can't use the command", thePlayer, 255,0,0)
		end
	end
)


function updateGui(client, playerSource)
	local thePlayer = getPlayerFromName(client)
	triggerClientEvent(playerSource, "updateMuteButton", getRootElement(), thePlayer, isPlayerMuted(thePlayer))
	triggerClientEvent(playerSource, "updateFreezeButton", getRootElement(), thePlayer, isElementFrozen(thePlayer))

	if (getElementData(thePlayer, "inJail") == true) then
		triggerClientEvent(playerSource, "updateArrestButton", getRootElement(), thePlayer, true)
	else
		triggerClientEvent(playerSource, "updateArrestButton", getRootElement(), thePlayer, false)
	end
	
	if (isPedInVehicle(thePlayer) == true) then
		triggerClientEvent(playerSource, "updateEjectButton", getRootElement(), thePlayer, false)
	else
		triggerClientEvent(playerSource, "updateEjectButton", getRootElement(), thePlayer, true)
	end
	
	if (thePlayer == playerSource) then
		triggerClientEvent(playerSource, "updateSpectateButton2", getRootElement(), thePlayer, true)
	else
		triggerClientEvent(playerSource, "updateSpectateButton2", getRootElement(), thePlayer, false)
		if (getCameraTarget(playerSource) == thePlayer) then
			triggerClientEvent(playerSource, "updateSpectateButton", getRootElement(), thePlayer, true)
		else
			triggerClientEvent(playerSource, "updateSpectateButton", getRootElement(), thePlayer, false)
		end
	end
	
	triggerClientEvent(playerSource, "updateUserInfo", getRootElement(), thePlayer, getPlayerIP(thePlayer), getPlayerSerial(thePlayer), getPlayerClass(thePlayer), getElementData(thePlayer, "reportsCount"))
end

function staffMutePlayer(client, playerSource)
	local playerToMute = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToMute) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't mute " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	if (isPlayerMuted(playerToMute) == true) then
		setPlayerMuted(playerToMute, false)
		outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been unmuted.", getRootElement(), 255, 255, 255, true)
		triggerClientEvent("updateMuteButton", getRootElement(), playerToMute, false)
	else
		setPlayerMuted(playerToMute, true)
		outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been muted.", getRootElement(), 255, 255, 255, true)
		triggerClientEvent("updateMuteButton", getRootElement(), playerToMute, true)
	end
end

function staffKickPlayer(client, playerSource, reason)
	local playerToKick = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToKick) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't kick " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	
	-- If there is no reason then don't reason "ENTER THE REASON HERE" - Qais
	if reason == "Enter the reason here." then
		reason = false
	end
	
	outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been kicked.", getRootElement(), 255, 255, 255, true)
	kickPlayer(playerToKick, playerSource, reason)
end

function staffKickInactivePlayer(client, playerSource, reason)
	local playerToKick = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToKick) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't kick " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been kicked for inactivity.", getRootElement(), 255, 255, 255, true)
	kickPlayer(playerToKick, playerSource, reason)
end

function staffBanPlayer(client, playerSource, reason, banTime, banByIP, banByUserName, banBySerial)
	local playerToBan = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToBan) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't ban " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	banPlayer(playerToBan, banByIP, banByUserName, banBySerial, playerSource, reason, banTime)
	outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been banned.", getRootElement(), 255, 255, 255, true)
end

function staffFreezePlayer(client, playerSource)
	local playerToFreeze = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToFreeze) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't freeze " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	if (isElementFrozen(playerToFreeze) == true) then
		setElementFrozen(playerToFreeze, false)
		outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been unfrozen.", getRootElement(), 255, 255, 255, true)
		triggerClientEvent("updateFreezeButton", getRootElement(), playerToFreeze, false)
	else
		setElementFrozen(playerToFreeze, true)
		outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been frozen.", getRootElement(), 255, 255, 255, true)
		triggerClientEvent("updateFreezeButton", getRootElement(), playerToFreeze, true)
	end
end

function staffEjectPlayer(client, playerSource)
	local playerToEject = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToEject) ==3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't eject " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	if (isPedInVehicle(playerToEject) == true) then
		outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been ejected.", getRootElement(), 255, 255, 255, true)
		removePedFromVehicle(playerToEject)
		triggerClientEvent("updateEjectButton", getRootElement(), playerToEject, true)
	end
end

function staffUnarmPlayer(client, playerSource)
	local playerToUnarm = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToUnarm) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't unarm " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been unarmed.", getRootElement(), 255, 255, 255, true)
	takeAllWeapons(playerToUnarm)
	setPedArmor(playerToUnarm, 0)
end

function staffBurnPlayer(client, playerSource)
	local playerToBurn = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToBurn) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't burn " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been set on fire.", getRootElement(), 255, 255, 255, true)
	setPedOnFire(playerToBurn, true)
end

function staffArrestPlayer(client, playerSource)
	local playerToArrest = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToArrest) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't arrest " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	if (getElementData(playerToArrest, "inJail") == false) then
		outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been arrested.", getRootElement(), 255, 255, 255, true)
		if getPedOccupiedVehicle(playerToArrest) then removePedFromVehicle(playerToArrest) end
		setElementData(playerToArrest, "inJail", true)
		setElementPosition(playerToArrest, 643.58581542969, -2374.5551757813, 1.555365562439)
		takeAllWeapons(playerToArrest)
		triggerClientEvent("updateArrestButton", getRootElement(), playerToArrest, true)
	else
		outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been released.", getRootElement(), 255, 255, 255, true)
		setElementPosition(playerToArrest, 737.40600585938, -2393.1303710938, 33.039539337158)
		setElementData(playerToArrest, "inJail", false)
		triggerClientEvent("updateArrestButton", getRootElement(), playerToArrest, false)
	end
end

function staffKillPlayer(client, playerSource)
	local playerToKill = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToKill) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't kill " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	if (isPedDead(playerToKill) == false) then
		killPed(playerToKill)
		outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been killed.", getRootElement(), 255, 255, 255, true)
	end
end

function staffBombPlayer(client, playerSource)
	local playerToBomb = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToBomb) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't bomb " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	if (isPedDead(playerToBomb) == false) then
		local pX, pY, pZ = getElementPosition(playerToBomb)
		createExplosion(pX, pY, pZ, 0)
		createExplosion(pX, pY, pZ, 0)
		createExplosion(pX, pY, pZ, 0)
		if isPedDead(playerToBomb) == false then
			killPed(playerToBomb)
		end
	end
	outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been bombed.", getRootElement(), 255, 255, 255, true)
end

function staffRenamePlayer(client, playerSource, newNick)
	local playerToRename = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToRename) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't rename " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	setPlayerName(playerToRename, newNick)
	outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been renamed to " .. newNick .. ".", getRootElement(), 255, 255, 255, true)
end

function staffSpectatePlayer(client, playerSource)
	if (getCameraTarget(playerSource) == playerSource) then
		local playerToSpy = getPlayerFromName(client)
		--[[if (getPlayerClass(playerSource) == 3 and getPlayerClass(playerToSpy) == 4) then
			outputChatBox("#FF0000*STAFF: #FFFF00You can't spy " .. client .. ".", playerSource, 255, 255, 255, true)
			return
		end]] --This should not be a problem ;)
		local pX, pY, pZ = getElementPosition (playerSource)
		setElementPosition(playerSource, pX, pY, pZ)
		setCameraTarget(playerSource, playerToSpy)
		setElementPosition(playerSource, pX, pY, pZ)
		triggerClientEvent(playerSource, "updateSpectateButton", getRootElement(), thePlayer, true)
	else
		setCameraTarget(playerSource, playerSource)
		triggerClientEvent(playerSource, "updateSpectateButton", getRootElement(), thePlayer, false)
	end
end

function staffWarnPlayer(client, playerSource, warnText)
	local playerToWarn = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToWarn) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't warn " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	triggerClientEvent(playerToWarn, "showLampPost", getRootElement(), warnText, "255,0,0" )
	outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been warned.", playerSource, 255, 0, 0, true)
end

function staffSlapPlayer(client, playerSource, warnText)
	local playerToSlap = getPlayerFromName(client)
	if (getPlayerClass(playerSource) == 2 and getPlayerClass(playerToSlap) == 3) then
		outputChatBox("#FF0000*STAFF: #FFFF00You can't slap " .. client .. ".", playerSource, 255, 255, 255, true)
		return
	end
	local px, py, pz = getElementVelocity(playerToSlap)
	setElementVelocity(playerToSlap, px , py, pz + 1)
	setElementHealth(playerToSlap, 1)
	outputChatBox("#FF0000*STAFF: #FFFF00" .. client .. " has been slapped.", getRootElement(), 255, 0, 0, true)
end

function staffWarnAllPlayers(playerSource, warnText, color)
	triggerClientEvent("showLampPost", getRootElement(), warnText, "255, 0, 0")
end

addEvent("updateGui", true)
addEventHandler("updateGui", getRootElement(), updateGui)
addEvent("StaffMutePlayer", true)
addEventHandler("StaffMutePlayer", getRootElement(), staffMutePlayer)
addEvent("StaffKickPlayer", true)
addEventHandler("StaffKickPlayer", getRootElement(), staffKickPlayer)
addEvent("StaffKickInactivePlayer", true)
addEventHandler("StaffKickInactivePlayer", getRootElement(), staffKickInactivePlayer)
addEvent("StaffBanPlayer", true)
addEventHandler("StaffBanPlayer", getRootElement(), staffBanPlayer)
addEvent("StaffFreezePlayer", true)
addEventHandler("StaffFreezePlayer", getRootElement(), staffFreezePlayer)
addEvent("StaffEjectPlayer", true)
addEventHandler("StaffEjectPlayer", getRootElement(), staffEjectPlayer)
addEvent("StaffUnarmPlayer", true)
addEventHandler("StaffUnarmPlayer", getRootElement(), staffUnarmPlayer)
addEvent("StaffBurnPlayer", true)
addEventHandler("StaffBurnPlayer", getRootElement(), staffBurnPlayer)
addEvent("StaffArrestPlayer", true)
addEventHandler("StaffArrestPlayer", getRootElement(), staffArrestPlayer)
addEvent("StaffKillPlayer", true)
addEventHandler("StaffKillPlayer", getRootElement(), staffKillPlayer)
addEvent("StaffBombPlayer", true)
addEventHandler("StaffBombPlayer", getRootElement(), staffBombPlayer)
addEvent("StaffRenamePlayer", true)
addEventHandler("StaffRenamePlayer", getRootElement(), staffRenamePlayer)
addEvent("StaffSpectatePlayer", true)
addEventHandler("StaffSpectatePlayer", getRootElement(), staffSpectatePlayer)
addEvent("StaffWarnPlayer", true)
addEventHandler("StaffWarnPlayer", getRootElement(), staffWarnPlayer)
addEvent("StaffWarnAllPlayers", true)
addEventHandler("StaffWarnAllPlayers", getRootElement(), staffWarnAllPlayers)
addEvent("StaffSlapPlayer", true)
addEventHandler("StaffSlapPlayer", getRootElement(), staffSlapPlayer)

addEventHandler("onResourceStart", getResourceRootElement(),
	function()
		local playersList = getElementsByType("player")
		for i, thePlayer in pairs(playersList) do
			bindKey(thePlayer, 'F5', 'down', 'staffpanel')
		end
	end
)

addEventHandler("onPlayerJoin", getRootElement(),
	function()
		bindKey(source, 'F5', 'down', 'staffpanel')
	end
)

