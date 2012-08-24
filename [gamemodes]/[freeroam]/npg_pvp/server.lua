-- ***********************************************
-- * NPG - General                               *
-- * Written by NPG Team  (c) 2011               *
-- ***********************************************

addEventHandler("onPlayerJoin",getRootElement(),
	function ()
		setElementData(source,"afk_state",false)
		setElementData(source,"invincible",false)
		setElementData(source,"pvp",false)
	end
)

addEventHandler( "onResourceStart", getResourceRootElement(getThisResource()),
	function ()
		for i,v in pairs(getElementsByType("player")) do
			setElementData(v,"afk_state",false)
		end
	end
)

addEventHandler ("onPlayerQuit", getRootElement(), 
	function()
		triggerClientEvent("afk:updatelist", getRootElement(), source, false)
	end
)


function toggleAFK(thePlayer)
	if getElementData(thePlayer, "gamemode") ~= "freeroam" then return end
		if getElementData(thePlayer,"afk_state") == false then
			triggerClientEvent("afk:updatelist", getRootElement(), thePlayer, true)
			setElementData(thePlayer, "invincible", true, true)
			setElementFrozen(thePlayer,true)
			setPedGravity(thePlayer, 0)
			setElementData(thePlayer,"afk_state",true)
			toggleControl ( thePlayer, "vehicle_secondary_fire", false )
			toggleControl ( thePlayer, "vehicle_fire", false )
			toggleControl ( thePlayer, "fire", false )
			toggleControl ( thePlayer, "forwards", false )
			toggleControl ( thePlayer, "backwards", false )
			toggleControl ( thePlayer, "left", false )
			toggleControl ( thePlayer, "right", false )
			vehicle = getPedOccupiedVehicle(thePlayer)
			if vehicle and getVehicleController(vehicle)==thePlayer then
				setElementFrozen(vehicle,true)
				setVehicleDamageProof(vehicle,true)
			end
		elseif getElementData(thePlayer,"afk_state") == true then
			triggerClientEvent("afk:updatelist", getRootElement(), thePlayer, false)
			setElementData(thePlayer,"afk_state",false)
			setElementData(thePlayer, "invincible", false, true)
			setTimer(setElementFrozen, 50, 1, thePlayer,false)
			setPedGravity(thePlayer,0.008)
			local x,y,z = getElementPosition (thePlayer)
			setElementPosition(thePlayer, x, y, z + 0.01)
			toggleControl ( thePlayer, "vehicle_secondary_fire", true )
			toggleControl ( thePlayer, "vehicle_fire", true )
			toggleControl ( thePlayer, "fire", true )
			toggleControl ( thePlayer, "forwards", true )
			toggleControl ( thePlayer, "backwards", true )
			toggleControl ( thePlayer, "left", true )
			toggleControl ( thePlayer, "right", true )
			vehicle = getPedOccupiedVehicle(thePlayer)
			if vehicle and getVehicleController(vehicle)==thePlayer then
				setElementFrozen(vehicle,false)
				setVehicleDamageProof(vehicle,false)
			end
		end
	end
addCommandHandler("afk", toggleAFK)

addCommandHandler("pvp", function(p)
		if getElementData(p, "gamemode") ~= "freeroam" then return end
		local state = getElementData(p, "invincible")
		setElementData(p, "invincible", not state, true)
		
		state = getElementData(p, "pvp")
		setElementData(p, "pvp", not state, true)
		outputChatBox("PvP: "..state and "#ff0000disabled" or "#00ff00enabled", p, 255,255,0, true)
	end
)