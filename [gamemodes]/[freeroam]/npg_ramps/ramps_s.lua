local playerRamps = { }
local playerDoubleRamp = { }


-- *******************
-- *    Functions    *
-- *******************
addEvent("spawnRamp", true)
addEventHandler("spawnRamp", getRootElement(),
	function(thePlayer, modelID, vx, vy, vz, rz)
	if getElementData ( thePlayer, "gamemode" ) ~= "freeroam" then return end
			local theVehicle = getPedOccupiedVehicle(thePlayer)

			if (theVehicle and getPedOccupiedVehicleSeat(thePlayer) == 0) then
		
				-- Delete the old normal ramps if they exist.
				if (playerRamps[thePlayer] ~= nil) then
					destroyElement(playerRamps[thePlayer])
				end
			
				-- Delete the new double ramp if they exist.
				if ( playerDoubleRamp[thePlayer] ~= nil ) then
					destroyElement(playerDoubleRamp[thePlayer][1])
					destroyElement(playerDoubleRamp[thePlayer][2])
					playerDoubleRamp[thePlayer] = nil
				end

				-- Create the ramp.
				playerRamps[thePlayer] = createObject(modelID, vx, vy, vz, 0, 0, rz)
				setElementDimension(playerRamps[thePlayer], getElementDimension(thePlayer))
				setElementInterior(playerRamps[thePlayer], getElementInterior(thePlayer))
			end		
	end
)

addEvent("spawnDoubleRamp", true)
addEventHandler("spawnDoubleRamp", getRootElement(),
	function(thePlayer, vx, vy, vz, rz, ramp2vx, ramp2vy)
if getElementData ( thePlayer, "gamemode" ) ~= "freeroam" then return end
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle and getPedOccupiedVehicleSeat(thePlayer) == 0 then
		
			-- Delete the double ramps if they exist.
			if playerDoubleRamp[thePlayer] ~= nil then
				destroyElement(playerDoubleRamp[thePlayer][1])
				destroyElement(playerDoubleRamp[thePlayer][2])
				playerDoubleRamp[thePlayer] = nil
			end

			
			-- Delete the old normal ramps if they exist.
			if playerRamps[thePlayer] ~= nil then
				destroyElement(playerRamps[thePlayer])
				playerRamps[thePlayer] = nil
			end

			-- Create the double ramps.
			playerDoubleRamp[thePlayer] = {}
			playerDoubleRamp[thePlayer][1] = createObject(1632, vx, vy, vz, 0, 0, rz)
			playerDoubleRamp[thePlayer][2] = createObject(1632, ramp2vx, ramp2vy, vz + 4, 14, 0, rz)
			setElementDimension(playerDoubleRamp[thePlayer][1], getElementDimension(thePlayer))
			setElementInterior(playerDoubleRamp[thePlayer][1], getElementInterior(thePlayer))
			setElementDimension(playerDoubleRamp[thePlayer][2], getElementDimension(thePlayer))
			setElementInterior(playerDoubleRamp[thePlayer][2], getElementInterior(thePlayer))
		end
	end
)

addEventHandler("onPlayerQuit", getRootElement(),
	function()
		if (playerRamps[source] ~= nil) then
			destroyElement(playerRamps[source])
			playerRamps[source] = nil
		end
		if playerDoubleRamp[thePlayer] ~= nil then
			destroyElement(playerDoubleRamp[thePlayer][1])
			destroyElement(playerDoubleRamp[thePlayer][2])
			playerDoubleRamp[thePlayer] = nil
		end
	end
)

addEventHandler("onPlayerWasted", getRootElement(),
	function()
		if (playerRamps[source] ~= nil) then
			destroyElement(playerRamps[source])
			playerRamps[source] = nil
		end
		if playerDoubleRamp[thePlayer] ~= nil then
			destroyElement(playerDoubleRamp[thePlayer][1])
			destroyElement(playerDoubleRamp[thePlayer][2])
			playerDoubleRamp[thePlayer] = nil
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function()
		if (getElementType(source) == "vehicle") then
			if (getPedOccupiedVehicle(getLocalPlayer()) == source) then
				if (playerRamps[source] ~= nil) then
					destroyElement(playerRamps[source])
					playerRamps[source] = nil
				end
				if playerDoubleRamp[thePlayer] ~= nil then
					destroyElement(playerDoubleRamp[thePlayer][1])
					destroyElement(playerDoubleRamp[thePlayer][2])
					playerDoubleRamp[thePlayer] = nil
				end
			end
		end
	end
)
