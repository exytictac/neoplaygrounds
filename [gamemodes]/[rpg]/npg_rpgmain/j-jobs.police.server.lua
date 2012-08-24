--[[
	RPG Jobs v2.0.1 [police.server]
	
	Made By: JR10
	
	Copyright (c) 2011
]]

local LSPDColShape = createColTube ( 1544.599609375, -1675.6923828125, 13.558725357056 , 5 , 5 )
setElementDimension ( LSPDColShape, 100 )

addEventHandler("onPlayerJoin", root,
	function()
		setElementData(source, "justDamaged", false)
	end
)


function outputPoliceRadio(msg, msg2)
	if msg and msg2 then
		for i, v in ipairs(getPlayersInTeam(getTeamFromName("Police"))) do
			outputChatBox("LSP Radio: "..msg, v, settingPoliceTeamColor [ 1 ] , settingPoliceTeamColor [ 2 ] , settingPoliceTeamColor [ 3 ])
			outputChatBox(msg2, v, settingPoliceTeamColor [ 1 ] , settingPoliceTeamColor [ 2 ] , settingPoliceTeamColor [ 3 ])
		end
	else
		for i, v in ipairs(getPlayersInTeam(getTeamFromName("Police"))) do
			outputChatBox("LSP Radio: "..msg, v, settingPoliceTeamColor [ 1 ] , settingPoliceTeamColor [ 2 ] , settingPoliceTeamColor [ 3 ])
		end
	end
end

addEventHandler ( "onPlayerDamage" , root ,
	function ( attacker , attackerWeapon )
	if getElementData ( source, "gamemode" ) == "rpg" then
		if getElementHealth ( source ) < 1 then
			return
		end
		if not isPlayerInTeam ( attacker , "Police" ) then
			return
		end
		if not attacker or attacker == source then
			return
		end
		if getPlayerWantedLevel ( source ) < 1 then
			return
		end
		if getElementData ( source , "Cuffed" ) then
			return
		end
		if attackerWeapon ~= 3 then
			return
		end
		setElementData(source, "Cuffed", true)
		setElementData(source, "Handcuffer", getPlayerName(attacker))
		outputPoliceRadio(getPlayerName(source).." has been handcuffed by "..getPlayerName(attacker))
		outputChatBox("You have been handcuffed by " .. getPlayerName ( attacker ), source)
		outputChatBox("Take " .. getPlayerName ( source ) .. " to LSPD to arrest him" , attacker )
		toggleAllControls(source, false, true, false)
		showCursor(source, true)
		setPlayerFollowPlayer ( source , attacker )
	end
	end
)

function setPlayerFollowPlayer ( player , target )
	triggerClientEvent ( player , "client:setPlayerFollowPlayer" , player , true , target )
end

addCommandHandler("uncuff",
	function(player, _, name)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if not isPlayerInTeam(player, "Police") then return outputChatBox("You are not a cop", player) end
		if not name then return outputChatBox("Syntax: /uncuff <player partial name>", player) end
		local target = findPlayer(name, player)
		if not target then return end
		if target == player then return outputChatBox("You can't uncuff yourself", player) end
		if not getElementData(target, "Cuffed") then return outputChatBox(getPlayerName(target).." is not cuffed", player) end
		local tx, ty, tz = getElementPosition(target)
		if not isPlayerInRangeOfPoint(player, tx, ty, tz, 3) then return outputChatBox("You are too far from "..getPlayerName(target), player) end
		if not getElementData(target, "Handcuffer") == getPlayerName(player) then return outputChatBox("You didn't cuff "..getPlayerName(target), player) end
		setElementData(target, "Cuffed", false)
		setElementData(target, "Handcuffer", "")
		outputChatBox(getPlayerName(player).." has uncuffed you", target)
		outputPoliceRadio(getPlayerName(target).." has been uncuffed by "..getPlayerName(player))
		triggerClientEvent ( target , "client:setPlayerFollowPlayer" , target , false , player )
	end
)

addEventHandler ( "onColShapeHit" , LSPDColShape ,
	function ( hElement , mDim )
	if getElementData ( hElement, "gamemode" ) ~= "rpg" then return end
		if not mDim then
			return
		end
		if getElementType ( hElement ) ~= player then
			return
		end
		if getPlayerWantedLevel ( hElement ) < 1 then
			return
		end
		if not getElementData ( hElement , "Cuffed" ) then
			return
		end
		local player = getPlayerFromName ( getElementData ( hElement , "Handcuffer" ) )
		if not player then
			return
		end
		local wantedLevel = getPlayerWantedLevel ( hElement )
		fadeCamera(hElement, false)
		setTimer(setElementInterior, 1000, 1, hElement, settingPrisonLocation [ 4 ])
		setTimer(setElementPosition, 1000, 1, hElement, settingPrisonLocation [ 1 ] , settingPrisonLocation [ 2 ] , settingPrisonLocation [ 3 ] )
		setTimer(setElementDimension, 1000, 1, hElement, settingPrisonLocation [ 5 ] )
		setTimer(setElementRotation, 1000, 1, hElement, settingPrisonLocation [ 6 ])
		setTimer(fadeCamera, 1000, 1, hElement, true)
		outputPoliceRadio ( getPlayerName ( hElement ) .. " has been arrested by " .. getPlayerName ( player ) )
		if settingTakePlayerWeaponsOnArrest then
			takeAllWeapons(hElement)
		end
		setElementData(hElement, "Arrested", true)
		setElementData(hElement, "Cuffed", false)
		setElementData(hElement, "Handcuffer", "")
		if wantedLevel == 1 then
			givePlayerMoney(player, 1000)
			takePlayerMoney(hElement, 5000)
			setElementData(hElement, "Timeleft", 30)
			setTimer ( releasePlayer , 30000 , 1 , hElement )
		elseif wantedLevel == 2 then
			givePlayerMoney(player, 2000)
			takePlayerMoney(hElement, 8000)
			setElementData(hElement, "Timeleft", 60)
			setTimer ( releasePlayer , 60000 , 1 , hElement )
		elseif wantedLevel == 3 then
			givePlayerMoney(player, 3000)
			takePlayerMoney(hElement, 10000)
			setElementData(hElement, "Timeleft", 120)
			setTimer ( releasePlayer , 120000 , 1 , hElement )
		elseif wantedLevel == 4 then
			givePlayerMoney(player, 4000)
			takePlayerMoney(hElement, 12000)
			setElementData(hElement, "Timeleft", 180)
			setTimer ( releasePlayer , 180000 , 1 , hElement )
		elseif wantedLevel == 5 then
			givePlayerMoney(player, 5000)
			takePlayerMoney(hElement, 15000)
			setElementData(hElement, "Timeleft", 200)
			setTimer ( releasePlayer , 200000 , 1 , hElement )
		elseif wantedLevel == 6 then
			givePlayerMoney(player, 8000)
			takePlayerMoney(hElement, 20000)
			setElementData(hElement, "Timeleft", 240)
			setTimer ( releasePlayer , 240000 , 1 , hElement )
		end
		setPlayerWantedLevel(hElement, 0)
	end
)

function releasePlayer(player)
	fadeCamera(player, false)
	setTimer(setElementInterior, 1000, 1, player, 0)
	setTimer(setElementPosition, 1000, 1, player, 1544.0986328125, -1675.591796875, 13.557745933533)
	setTimer(setPedRotation, 1000, 1, player, 90)
	setTimer(setElementDimension, 1000, 1, player, 0)
	setTimer(fadeCamera, 1000, 1, player, true)
	setTimer(outputChatBox, 1000, 1, "You have been released from jail , try to be a better citizen", player)
	setTimer(outputPoliceRadio, 1000, 1, getPlayerName(player).." has been released from jail")
	setTimer(setElementData, 1000, 1, player, "Arrested", false)
	toggleAllControls(player, true)
	showCursor(player, false)
end

addCommandHandler("release",
	function(player, _, name)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if not isPlayerInTeam(player, "Police") then return outputChatBox("You are not a cop", player) end
		if not name then return outputChatBox("Syntax: /release <player partial name>", player) end
		local target = findPlayer(name, player)
		if not target then return end
		if target == player then return outputChatBox("You can't release yourself", player) end
		if not getElementData(target, "Arrested") then return outputChatBox(getPlayerName(target).." is not arrested", player) end
		releasePlayer(player)
	end
)

local rb = {}
addCommandHandler("rb",
	function(player, cmd)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if not isPlayerInTeam(player, "Police") then return outputChatBox("You are not a cop", player) end
		if getElementData(player, "RB") then return outputChatBox("You have already deployed a road block", player, 192, 192, 192) end
		local x, y, z = getElementPosition(player)
		local rx, ry, rz = getElementRotation(player)
		rb[player] = createObject ( 981, x+4, y, z, rx, ry, rz)
		setElementData(rb[player], "creator", getPlayerName(player))
		setElementData(player, "RB", true)
		outputPoliceRadio(getPlayerName(player).." deployed a road block at "..getZoneName(x, y, z))
	end
)

addCommandHandler("rrb",
	function(player, cmd)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if not isPlayerInTeam(player, "Police") then return outputChatBox("You are not a cop", player) end
		if not getElementData(player, "RB") then return outputChatBox("You haven't deployed any road blocks", player, 192, 192, 192) end
		for i, v in ipairs(getElementsByType("object")) do
			if getElementModel(v) == 981 then
				if getElementData(v, "creator") == getPlayerName(player) then
					local x, y, z = getElementPosition(v)
					destroyElement(v)
					outputPoliceRadio(getPlayerName(player).." removed a road block at "..getZoneName(x, y, z))
					setElementData(player, "RB", false)
					break
				end
			end
		end	
	end
)

addCommandHandler("free",
	function(player, cmd, name, ...)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if not isPlayerInTeam(player, "Police") then return outputChatBox("You are not a cop", player) end
		if not name then return outputChatBox("Syntax: /free <partial Name> <reason>", player) end
		if ... then
			local target = findPlayer(name, src)
			if not target then return end
			if target == player then return outputChatBox("You can't free yourself", player) end
			local reason = table.concat({...}, " ")
			setPlayerWantedLevel(target, 0)
			outputPoliceRadio(getPlayerName(target).." has been freed by "..getPlayerName(player), "Reason: "..reason)
		else
			local target = findPlayer(name, src)
			if not target then return end
			if target == player then return outputChatBox("You can't free yourself", player) end
			setPlayerWantedLevel(target, 0)
			outputPoliceRadio(getPlayerName(target).." has been freed by "..getPlayerName(player), "Reason: Not Specified")
		end
	end
)

addCommandHandler("ticket",
	function(player, _, name, ammount)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if not isPlayerInTeam(player, "Police") then return outputChatBox("You are not a cop", player) end
		if not name or not ammount and tonumber(ammount) ~= nil then return outputChatBox("Syntax: /ticket <partial Name> <ammount>", player) end
		local target = findPlayer(name, player)
		if not target then return end
		if target == player then return outputChatBox("You can't ticket yourself", player) end
		if getPlayerWantedLevel(target) == 0 then return outputChatBox(getPlayerName(target).." is not a criminal", player) end
		if not getElementData(target, "Cuffed") then return outputChatBox(getPlayerName(target).." is not cuffed", player) end
		if not getElementData(target, "Handcuffer") == getPlayerName(player) then return outputChatBox("You didn't cuff that player", player) end
		if tonumber(ammount) < 100 then return outputChatBox("The ammount must be higher than $100", player) end
		if not getElementData(target, "gotTicket") then
			ammount = tonumber(ammount)
			setElementData(target, "gotTicket", true)
			setElementData(target, "ticketAmmount", ammount)
			outputChatBox(getPlayerName(player).." gave u a ticket with $"..ammount.." go pay it in LSPD", target, 255, 255, 0)
			toggleAllControls(target, true)
			showCursor(target, false)
			outputPoliceRadio(getPlayerName(player).." gave "..getPlayerName(target).." a ticket with $"..ammount)
			stopFollow(target, player)
			setElementData(target, "Cuffed", false)
			setElementData(target, "Handcuffer", "")
		else
			ammount = tonumber(ammount)
			setElementData(target, "ticketAmmount", getElementData(target, "ticketAmmount") + ammount)
			outputChatBox(getPlayerName(player).." gave u a ticket with $"..ammount.." go pay it in LSPD", target, 255, 255, 0)
			toggleAllControls(target, true)
			showCursor(target, false)
			outputPoliceRadio(getPlayerName(player).." gave "..getPlayerName(target).." a ticket with $"..ammount)
			stopFollow(target, player)
			setElementData(target, "Cuffed", false)
			setElementData(target, "Handcuffer", "")
		end
	end
)

local ticketPickup = createPickup(249.5751953125, 67.8544921875, 1003.640625, 3, 1239, 0)
setElementInterior(ticketPickup, 6)
setElementDimension(ticketPickup, 100)

addEventHandler("onPickupHit", ticketPickup,
	function(hitElement)
	if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
		outputChatBox("You can pay your ticket here by /payticket", hitElement, 255, 255, 0)
	end
)

addCommandHandler("payticket",
	function(player, cmd)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if getElementData(player, "gotTicket") then
			local x, y, z = getElementPosition(player)
			if isPlayerInRangeOfPoint(player, 249.5751953125, 67.8544921875, 1003.640625, 3) then
				if getPlayerMoney(player) < getElementData(player, "ticketAmmount") then return outputChatBox("You don't have enough money to pay the ticket", player) end
				takePlayerMoney(player, getElementData(player, "ticketAmmount"))
				setElementData(player, "gotTicket", false)
				setElementData(player, "ticketAmmount", 0)
				outputPoliceRadio(getPlayerName(player).." has paid his ticket")
				outputChatBox("You have succesfully paid your ticket", player, 255, 255, 0)
				setPlayerWantedLevel(player, 0)
			else
				outputChatBox("You must be in LSPD to pay your ticket", player, 192, 192, 192)
			end
		else
			outputChatBox("You dont have a ticket", player, 192, 192, 192)
		end
	end
)

addCommandHandler("tickets",
	function(src, cmd)
	if getElementData ( src, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(src, "Police") then
			outputChatBox("---- Tickets ----", 255, 255, 0)
			for i, v in ipairs(getPlayersInGamemode ( 'rpg' )) do
				if getElementData(v, "gotTicket") then
					outputChatBox(getPlayerName(v).." -- $"..getElementData(v, "ticketAmmount"), src)
				end
			end
		else
			outputChatBox("You are not a cop", src, 192, 192, 192)
		end
	end
)

local LSPEle = createMarker(1568.6572265625, -1689.9814453125, 7, "arrow", 1.5, 0, 255, 0, 255)
local LSPREle = createMarker(1572.6884765625, -1675.5966796875, 29.09545249939, "arrow", 1.5, 0, 255, 0, 255)

addEventHandler("onMarkerHit", LSPEle,
	function(hitElement, dim)
	if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
		if getElementType(hitElement) == "player" then
			if isPlayerInTeam(hitElement, "Police") then
				fadeCamera(hitElement, false)
				setTimer(setElementPosition, 1000, 1, hitElement, 1574.8115234375, -1675.4208984375, 28.39545249939)
				setTimer(setPedRotation, 1000, 1, hitElement, 270)
				setTimer(fadeCamera, 1000, 1, hitElement, true)
				playSoundFrontEnd(hitElement, 1)
			end
		end
	end
)

addEventHandler("onMarkerHit", LSPREle,
	function(hitElement, dim)
	if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
		if getElementType(hitElement) == "player" then
			if isPlayerInTeam(hitElement, "Police") then
				fadeCamera(hitElement, false)
				setTimer(setElementPosition, 1000, 1, hitElement, 1568.447265625, -1692.6533203125, 5.890625)
				setTimer(setPedRotation, 1000, 1, hitElement, 175)
				setTimer(fadeCamera, 1000, 1, hitElement, true)
				playSoundFrontEnd(hitElement, 1)
			end
		end
	end
)

addCommandHandler("codes",
	function(player, cmd)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(player, "Police") then
			outputChatBox("--/ar : assistance request", player, settingPoliceTeamColor [ 1 ] , settingPoliceTeamColor [ 2 ] , settingPoliceTeamColor [ 3 ])
			outputChatBox("--/omw : on my way", player, settingPoliceTeamColor [ 1 ] , settingPoliceTeamColor [ 2 ] , settingPoliceTeamColor [ 3 ])
			outputChatBox("--/ann : assistance not needed any more",player, settingPoliceTeamColor [ 1 ] , settingPoliceTeamColor [ 2 ] , settingPoliceTeamColor [ 3 ])
			outputChatBox("--/rhq : returning to head quarter", player, settingPoliceTeamColor [ 1 ] , settingPoliceTeamColor [ 2 ] , settingPoliceTeamColor [ 3 ])
			outputChatBox("--/cs : chasing suspects", player, settingPoliceTeamColor [ 1 ] , settingPoliceTeamColor [ 2 ] , settingPoliceTeamColor [ 3 ])
		end
	end
)

addCommandHandler("ar",
	function(player, cmd)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(player, "Police") then
			local x, y, z = getElementPosition(player)
			outputPoliceRadio(getPlayerName(player).." Assistance Request At "..getZoneName(x, y, z))
		end
	end
)

addCommandHandler("omw",
	function(player, cmd)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(player, "Police") then
			outputPoliceRadio(getPlayerName(player).." :  On My Way")
		end
	end
)

addCommandHandler("ann",
	function(player, cmd)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(player, "Police") then
			outputPoliceRadio(getPlayerName(player).." : Assistance not needed any more")
		end
	end
)

addCommandHandler("rhq",
	function(player, cmd)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(player, "Police") then
			local x, y, z = getElementPosition(player)
			outputPoliceRadio(getPlayerName(player).." : At "..getZoneName(x, y, z).." and returning to head quarter")
		end
	end
)

addCommandHandler("cs",
	function(player, cmd)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(player, "Police") then
			local x, y, z = getElementPosition(player)
			outputPoliceRadio(getPlayerName(player).." : Chasing suspect at "..getZoneName(x, y, z))
		end
	end
)

function getPlayersFromGamemode( gm )
   local tab = {}
   for i,v in ipairs(getElementsByType'player') do
     if getElementData(v, 'gamemode') == gm then table.insert(tab, v) end 
   end
   return tab
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		for i, v in ipairs(getPlayersFromGamemode( 'rpg' )) do
			setElementData(v, "RB", false)
			setElementFrozen(v, false)
			setElementData(v, "Cuffed", false)
			setElementData(v, "gotCuffs", false)
			setElementData(v, "Arrested", false)
		end
	end
)

--WANTED
addEventHandler("onPlayerWasted", resourceRoot,
	function(ammo, attacker, weapon, bodypart)
	if getElementData ( attacker or driver and source , "gamemode" ) ~= "rpg" then return end
		if getPlayerWantedLevel(source) > 0 and isPlayerInTeam(attacker, "Police") then
			setPlayerWantedLevel(source, 0)
			return takePlayerMoney(source, 200)
		end
		if getElementType(attacker) == "player" then
			if not isElement(attacker) or attacker == source then return end
			if getPlayerWantedLevel(attacker) < 6 then
				setPlayerWantedLevel(attacker, getPlayerWantedLevel(attacker) + 1)
			end
		elseif getElementType(attacker) == "vehicle" then
			local driver = getVehicleController(attacker)
			if not isElement(driver) then return end
			if getPlayerWantedLevel(driver) < 6 then
				setPlayerWantedLevel(driver, getPlayerWantedLevel(driver) + 1)
			end
		end
	end
)

addEventHandler("onPlayerVehicleEnter", root,
	function(vehicle, seat, jacked)
	if getElementData ( source, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(source, "Police") then return end
		if getElementData(source, "Cuffed") then return end
		local model =  getElementModel(vehicle)
		if model == 598 or model == 596 or model == 597 or model == 427 or model == 490 or model == 599 then
			if getPlayerWantedLevel(source) < 6 then
				setPlayerWantedLevel(source, getPlayerWantedLevel(source) + 1)
			end
		end
	end
)

addEventHandler("onPlayerDamage", root,
	function(attacker,weapon,bodypart,loss)
	if getElementData ( source or attacker, "gamemode" ) ~= "rpg" then return end
		if getElementData(source, "justDamaged") then return end
		if not attacker or attacker == source or getElementType ( attacker ) ~= "player" then return end
		if isPlayerInTeam(attacker, "Police") and getPlayerWantedLevel(source) > 0 then return end
		setPlayerWantedLevel(attacker, getPlayerWantedLevel(attacker) + 1)
		setElementData(source, "justDamaged", true)
		setTimer(setElementData, 10000, 1, source, "justDamaged", false)
	end
)