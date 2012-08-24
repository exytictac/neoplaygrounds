--[[
	RPG Jobs v2.0.1 [mechanic.server]
	
	Made By: JR10
	
	Copyright (c) 2011
]]

addEventHandler("onPlayerSpawn", root,
	function()
	if getElementData ( source, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(source, "Mechanic") then
			giveWeapon(source, 41, 1000)
		end
	end
)

addEventHandler("onRPGEnter", root,
	function()
		setTimer(
			function(source)
				if isPlayerInTeam(source, "Mechanic") then
					triggerClientEvent(source, "setMechanic", source)
					setElementData(source, "canFix", true)
				end
				setElementData(source, "orderedMechanic", false)
			end
		, 500, 1, source)
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function()
		setTimer(
			function()
				for i, v in ipairs(getElementsByType("player")) do
				if getElementData ( v, "gamemode" ) ~= "rpg" then return end
					if not isGuestAccount(getPlayerAccount(v)) then
						if isPlayerInTeam(v, "Mechanic") then
							triggerClientEvent(v, "setMechanic", v)
							setElementData(v, "canFix", true)
						end
						setElementData(v, "orderedMechanic", false)
					end
				end
			end
		, 500, 1)
	end
)


addEventHandler("onResourceStart", resourceRoot,
	function()
		NoDriverTXT = textCreateDisplay()
		NoDriverITEM = textCreateTextItem("There is no driver in this car", 0.35, 0.8, "high", 0, 255, 0, 255, 2)
		textDisplayAddText(NoDriverTXT, NoDriverITEM)
		FixedCarTXT = textCreateDisplay()
		FixedCarITEM = textCreateTextItem("The vehicle doesn't need repair", 0.35, 0.8, "high", 0, 255, 0, 255, 2)
		textDisplayAddText(FixedCarTXT, FixedCarITEM)
		PreventAbuseTXT = textCreateDisplay()
		PreventAbuseITEM = textCreateTextItem("You can't fix vehicles for a minute to prevent abuse", 0.35, 0.8, "high", 0, 255, 0, 255, 2)
		textDisplayAddText(PreventAbuseTXT, PreventAbuseITEM)
		PoorDriverForMechanicTXT = textCreateDisplay()
		PoorDriverForMechanicITEM = textCreateTextItem("The driver doesn't have enough money", 0.35, 0.8, "high", 0, 255, 0, 255, 2)
		textDisplayAddText(PoorDriverForMechanicTXT, PoorDriverForMechanicITEM)
		PoorDriverForDriverTXT = textCreateDisplay()
		PoorDriverForDriverITEM = textCreateTextItem("You don't have enough money", 0.35, 0.8, "high", 0, 255, 0, 255, 2)
		textDisplayAddText(PoorDriverForDriverTXT, PoorDriverForDriverITEM)
		DidntOrderTXT = textCreateDisplay()
		DidntOrderITEM = textCreateTextItem("The driver didn't order a mechanic", 0.35, 0.8, "high", 0, 255, 0, 255, 2)
		textDisplayAddText(DidntOrderTXT, DidntOrderITEM)
		SuccesForDriverTXT = textCreateDisplay()
		SuccesForDriverITEM = textCreateTextItem("Your vehicle was repaired for $5000", 0.35, 0.8, "high", 0, 255, 0, 255, 2)
		textDisplayAddText(SuccesForDriverTXT, SuccesForDriverITEM)
		SuccesForMechanicTXT = textCreateDisplay()
		SuccesForMechanicITEM = textCreateTextItem("The vehicle was repaired for $5000", 0.35, 0.8, "high", 0, 255, 0, 255, 2)
		textDisplayAddText(SuccesForMechanicTXT, SuccesForMechanicITEM)
		for i, v in ipairs(getElementsByType("player")) do
			setTimer(
				function(v)
				if getElementData ( v, "gamemode" ) ~= "rpg" then return end
					if isPlayerInTeam(v, "Mechanic") then
						triggerClientEvent(v, "setMechanic", v)
						setElementData(v, "canFix", true)
					end
					setElementData(v, "orderedMechanic", false)
				end
			, 500, 1, v)
		end
	end
)

addEvent("fixTheVehicle", true)
addEventHandler("fixTheVehicle", root,
	function(mechanic, vehicle)
		if isPlayerInTeam(mechanic, "Mechanic") then
			if getElementData(mechanic, "canFix") then
				local driver = getVehicleOccupant(vehicle, 0)
				if driver then
					if getElementData(driver, "orderedMechanic") then
						if getElementHealth(vehicle) < 1000 and getElementHealth(vehicle) > 0 then
							if getPlayerMoney(driver) >= 5000 then
								if fixVehicle(vehicle) then
									takePlayerMoney(driver, 5000)
									givePlayerMoney(mechanic, 5000)
									setElementData(driver, "orderedMechanic", false)
									setElementData(mechanic, "canFix", false)
									setTimer(setElementData, 60000, 1, mechanic, "canFix", true)
									if not textDisplayIsObserver(SuccesForMechanicTXT, mechanic) and not textDisplayIsObserver(PoorDriverForMechanicTXT, mechanic) and not textDisplayIsObserver(FixedCarTXT, mechanic) and not textDisplayIsObserver(DidntOrderTXT, mechanic) and not textDisplayIsObserver(PreventAbuseTXT, mechanic) then textDisplayAddObserver(SuccesForMechanicTXT, mechanic) setTimer(textDisplayRemoveObserver, 6000, 1, SuccesForMechanicTXT, mechanic) end
									if not textDisplayIsObserver(SuccesForDriverTXT, driver) and not textDisplayIsObserver(PoorDriverForDriverTXT, driver) then textDisplayAddObserver(SuccesForDriverTXT, driver) setTimer(textDisplayRemoveObserver, 6000, 1, SuccesForDriverTXT, driver) end
								end
							else
								if not textDisplayIsObserver(SuccesForMechanicTXT, mechanic) and not textDisplayIsObserver(PoorDriverForMechanicTXT, mechanic) and not textDisplayIsObserver(FixedCarTXT, mechanic) and not textDisplayIsObserver(DidntOrderTXT, mechanic) and not textDisplayIsObserver(PreventAbuseTXT, mechanic) then textDisplayAddObserver(PoorDriverForMechanicTXT, mechanic) setTimer(textDisplayRemoveObserver, 6000, 1, PoorDriverForMechanicTXT, mechanic) end
								if not textDisplayIsObserver(SuccesForDriverTXT, driver) and not textDisplayIsObserver(PoorDriverForDriverTXT, driver) then textDisplayAddObserver(PoorDriverForDriverTXT, driver) setTimer(textDisplayRemoveObserver, 6000, 1, PoorDriverForDriverTXT, driver) end
							end
						else
							if not textDisplayIsObserver(SuccesForMechanicTXT, mechanic) and not textDisplayIsObserver(PoorDriverForMechanicTXT, mechanic) and not textDisplayIsObserver(FixedCarTXT, mechanic) and not textDisplayIsObserver(DidntOrderTXT, mechanic) and not textDisplayIsObserver(PreventAbuseTXT, mechanic) then textDisplayAddObserver(FixedCarTXT, mechanic) setTimer(textDisplayRemoveObserver, 6000, 1, FixedCarTXT, mechanic) end
						end
					else
						if not textDisplayIsObserver(SuccesForMechanicTXT, mechanic) and not textDisplayIsObserver(PoorDriverForMechanicTXT, mechanic) and not textDisplayIsObserver(FixedCarTXT, mechanic) and not textDisplayIsObserver(DidntOrderTXT, mechanic) and not textDisplayIsObserver(PreventAbuseTXT, mechanic) then textDisplayAddObserver(DidntOrderTXT, mechanic) setTimer(textDisplayRemoveObserver, 6000, 1, DidntOrderTXT, mechanic) end
					end
				else
					if not textDisplayIsObserver(SuccesForMechanicTXT, mechanic) and not textDisplayIsObserver(PoorDriverForMechanicTXT, mechanic) and not textDisplayIsObserver(FixedCarTXT, mechanic) and not textDisplayIsObserver(DidntOrderTXT, mechanic) and not textDisplayIsObserver(PreventAbuseTXT, mechanic) then textDisplayAddObserver(NoDriverTXT, mechanic) setTimer(textDisplayRemoveObserver, 6000, 1, NoDriverTXT, mechanic) end
				end
			else
				if not textDisplayIsObserver(SuccesForMechanicTXT, mechanic) and not textDisplayIsObserver(PoorDriverForMechanicTXT, mechanic) and not textDisplayIsObserver(FixedCarTXT, mechanic) and not textDisplayIsObserver(DidntOrderTXT, mechanic) and not textDisplayIsObserver(PreventAbuseTXT, mechanic) then textDisplayAddObserver(PreventAbuseTXT, mechanic) setTimer(textDisplayRemoveObserver, 6000, 1, PreventAbuseTXT, mechanic) end
			end
		end
	end
)

addCommandHandler("ordermechanic",
	function(player)
	if getElementData ( player, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(player, "Mechanic") then return end
		if getElementData(player, "orderedMechanic") then return outputChatBox("You have already ordered a mechanic", player) end
		if getPlayerMoney(player) >= 500 then
			takePlayerMoney(player, 500)
			outputChatBox("Your request for mechanics was sent", root, 0, 255, 0) 
			local x, y, z = getElementPosition(player)
			local zone = getZoneName(x, y, z)
			local city = getZoneName(x, y, z, true)
			setElementData(player, "orderedMechanic", true)
			for i, v in ipairs(getPlayersInTeam(getTeamFromName("Mechanic"))) do
				triggerClientEvent(v, "showOrder", v, player, zone, city)
			end
		else
			outputChatBox("You are too poor", player)
		end
	end
)