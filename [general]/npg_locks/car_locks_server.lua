--[[ =============================
	 Car Locks ( server ) by vick.
	 =============================

	 player element data
	 cl_ownedvehicle
	 vehicle element data
	 cl_vehicleowner
	 cl_vehiclelocked
	 cl_enginestate
--]]

function onPlayerJoin()
	bindKey(source, "l", "down", doToggleLocked)
end
function onPlayerQuit()
	-- check for owned car
	local ownedVehicle = getElementData(source, "cl_ownedvehicle")
	if ownedVehicle then
		cl_RemoveVehicleOwner(ownedVehicle)
	end
end
function onPlayerWasted()
	-- check for owned car
	local ownedVehicle = getElementData(source, "cl_ownedvehicle")
	if ownedVehicle ~= false then
		cl_RemoveVehicleOwner(ownedVehicle)
	end
end
function onVehicleEnter(player, seat, jacked)
	-- Driver Enter
	if seat == 0 then
		oldVehicle = getElementData(player, "cl_ownedvehicle")
		-- not entering player's own owned vehicle
		if cl_VehicleLocked(source) == true and cl_VehicleOwner(source) ~= player then
			removePedFromVehicle(player)
			errMsg("this vehicle is locked.", player)
			return false
		end
		-- set element data for vehicle and owner
		cl_SetVehicleOwner(source, player)
	end
	return true
end
function onVehicleStartEnter(enteringPlayer, seat, jacked)
	local theVehicle = source
	local theOwner
	-- locked and not owner entering
	if getElementData(theVehicle, "cl_vehiclelocked") == true then
		theOwner = getElementData(theVehicle, "cl_vehicleowner")
		if theOwner ~= false and theOwner ~= enteringPlayer then
			errMsg("This vehicle is locked")
			cancelEvent()
		end
	end
end
function initCarLocks()
	-- Initilize Player Element Data
	local players = getElementsByType("player")
	for i,v in ipairs(players) do
		removeElementData(v, "cl_ownedvehicle")
		bindKey(v, "l", "down", doToggleLocked)
	end

	-- Initilize Vehicle Element Data
	local vehicles = getElementsByType("vehicle")
	for i,v in ipairs(vehicles) do
		removeElementData(v, "cl_vehicleowner")
		removeElementData(v, "cl_vehiclelocked")
		removeElementData(v, "cl_enginestate")
		setVehicleLocked(v, false)
		setVehicleOverrideLights(v, 0)
	end
end
function onVehicleRespawn(exploded) 
	cl_RemoveVehicleOwner(source)
end
function onVehicleExplode()
	local theOwner = getElementData(source, "cl_vehicleowner")
	if theOwner then
		cl_RemoveVehicleOwner(source)
	end
end
function cl_SetVehicleOwner(theVehicle, thePlayer)
	local oldVehicle = getElementData ( thePlayer, "cl_ownedvehicle" )
	if ( oldVehicle ~= false ) then
		-- unlock old car		
		removeElementData ( oldVehicle, "cl_vehicleowner" )
		removeElementData ( oldVehicle, "cl_vehiclelocked" )
		removeElementData ( oldVehicle, "cl_enginestate" )
		setVehicleLocked ( oldVehicle, false ) 
		-- set vars for new car
	end
	setElementData ( theVehicle, "cl_vehicleowner", thePlayer )
	setElementData ( theVehicle, "cl_vehiclelocked", false )
	setElementData ( thePlayer, "cl_ownedvehicle", theVehicle )
	setElementData( theVehicle, "cl_enginestate", true )
end
function cl_RemoveVehicleOwner ( theVehicle )
	local theOwner = getElementData ( theVehicle, "cl_vehicleowner" )
	if ( theOwner ~= false ) then
		removeElementData ( theOwner, "cl_ownedvehicle" )
		removeElementData ( theVehicle, "cl_vehicleowner" )
		removeElementData ( theVehicle, "cl_vehiclelocked" )
		removeElementData ( owned, "cl_enginestate" )
	end
	setVehicleLocked ( theVehicle, false )

end
function cl_FlashLights ( thePlayer )
	setTimer ( doToggleLights, 300, 4, thePlayer, true )
end
function cl_FlashOnce ( thePlayer )
	setTimer ( doToggleLights, 300, 2, thePlayer, true )
end
function cl_VehicleOwner ( theVehicle )
	return getElementData( theVehicle, "cl_vehicleowner" )

end
function cl_VehicleLocked ( theVehicle )
	return getElementData( theVehicle, "cl_vehiclelocked" )
end
function errMsg(stringSent, thePlayer)
	outputChatBox ( stringSent, thePlayer, 255,0,0 )
end
function Car_Msg ( strout, theVehicle )
	numseats = getVehicleMaxPassengers ( theVehicle )
	for s = 0, numseats do
		local targetPlayer = getVehicleOccupant ( theVehicle, s )
		if targetPlayer ~= false then
			outputChatBox ( strout, targetPlayer, 30, 144, 255 )
		end
	end
end
function Info_Msg ( strout, thePlayer )
	outputChatBox ( strout, thePlayer, 102, 205, 170 )
end
function doToggleLocked ( source )
	local theVehicle , strout
	if ( getElementType(source) == "vehicle" ) then
		theVehicle = source
	end
	if ( getElementType(source) == "player" ) then
		theVehicle = getElementData ( source, "cl_ownedvehicle" )
	end

	if ( theVehicle ) then
		local vehiclename = getVehicleName ( theVehicle )
		-- already locked
		if ( getElementData ( theVehicle, "cl_vehiclelocked") == true ) then
			doUnlockVehicle ( source )
		else 
			doLockVehicle ( source )
		end
	else
		errMsg("You must have a vehicle to lock or unlock it.", source)
	end
end	
function doLockVehicle ( source )
	local theVehicle, strout
	if getElementType(source) == "vehicle" then
		theVehicle = source
	end
	if getElementType(source) == "player" then
		theVehicle = getElementData ( source, "cl_ownedvehicle" )
	end

	if theVehicle then
		local vehiclename = getVehicleName ( theVehicle )
		-- already locked
		if getElementData (theVehicle, "cl_vehiclelocked") == true then
			strout = "Your " .. vehiclename .. " is already locked." 
			errMsg(strout, source)
		else 
			setElementData ( theVehicle, "cl_vehiclelocked", true)
			setVehicleLocked ( theVehicle, true ) 
			Info_Msg ( "Locked vehicle " .. vehiclename .. ".", source )
			if ( getVehicleController ( theVehicle ) == false ) then
				cl_FlashLights ( source )
			end
		end
	else
		errMsg("You must have a vehicle to lock it.", source)
	end
end
function doUnlockVehicle ( source )
	local theVehicle, strout
	if getElementType(source) == "vehicle" then
		theVehicle = source
	elseif getElementType(source) == "player" then
		theVehicle = getElementData(source, "cl_ownedvehicle")
	end
	if theVehicle then
		local vehiclename = getVehicleName( theVehicle )
		if getElementData ( theVehicle, "cl_vehiclelocked") == false then
			strout = "Your " .. vehiclename .. " is already unlocked."
			errMsg(strout, source)
		else
			setElementData ( theVehicle, "cl_vehiclelocked", false)
			setVehicleLocked ( theVehicle, false )
			Info_Msg("Unlocked vehicle " .. vehiclename .. ".", source)
			if getVehicleController(theVehicle) == false then
				cl_FlashOnce ( source )
			end
		end
	else
		errMsg("You must have a vehicle to unlock it.", source)
	end
end
function doToggleLights(source, beep)
	local theVehicle 
	if getElementType(source) == "vehicle" then
		theVehicle = source
	end
	if getElementType(source) == "player" then
		theVehicle = getElementData ( source, "cl_ownedvehicle" )
	end
	if theVehicle then
		-- if he was in one
		if getVehicleOverrideLights ( theVehicle ) ~= 2 then  -- if the current state isn't 'force on'
            setVehicleOverrideLights ( theVehicle, 2)            -- force the lights on
			-- play sound close to element
			if beep == true then
				local theElement = theVehicle
				triggerClientEvent(getRootElement(), "onPlaySoundNearElement", getRootElement(), theElement, 5)
			end
        else
            setVehicleOverrideLights(theVehicle, 1)            -- otherwise, force the lights off
        end
	else
		errMsg("You must have a vehicle to control the lights.", source)
    end
end
function doToggleEngine ( source )
	local theVehicle
	if ( getElementType(source) == "vehicle" ) then
		theVehicle = source
	end
	if ( getElementType(source) == "player" ) then
		theVehicle = getElementData (source, "cl_ownedvehicle")
	end
	if theVehicle then
		local lights = getVehicleOverrideLights ( theVehicle )
		if ( getElementData( theVehicle, "cl_enginestate" ) == false )  then
			setElementData( theVehicle, "cl_enginestate", true, true)
			setVehicleEngineState( theVehicle, true )
		else
			setElementData(theVehicle, "cl_enginestate", false, true)
			setVehicleEngineState(theVehicle, false)
		end
		setVehicleOverrideLights(theVehicle, lights)
	else
		errMsg("You must have a vehicle to control the engine.", source )
	end
end
--|=============================================================|
--|=========================Handlers============================|
--|=========================^^^^^^^^============================|
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), initCarLocks)
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), initCarLocks)
addEventHandler("onPlayerJoin", getRootElement(), onPlayerJoin)
addEventHandler ("onPlayerQuit", getRootElement(), onPlayerQuit)
addEventHandler("onPlayerWasted", getRootElement(), onPlayerWasted)
addEventHandler("onVehicleStartEnter", getRootElement(), onVehicleStartEnter)
addEventHandler("onVehicleEnter", getRootElement(), onVehicleEnter)
addEventHandler ("onVehicleRespawn", getRootElement(), onVehicleRespawn)
addEventHandler("onVehicleExplode", getRootElement(), onVehicleExplode)
addCommandHandler ( "engine", doToggleEngine )
addCommandHandler ( "lights", doToggleLights, false)
addCommandHandler ( "lock", doLockVehicle )
addCommandHandler ( "unlock", doUnlockVehicle )