-- Ramp spawning system by noddy

-- *******************
-- *    Functions    *
-- *******************

function spawnRamp(key, keyState, rampType)
	if getElementData(getLocalPlayer(), "gamemode") ~= "freeroam" then return end
	local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (theVehicle) then
			if isVehicleOnGround ( theVehicle ) then
				-- Get current position of the vehicle.
				local px, py, pz = getElementPosition(theVehicle)
				local rz, rz, rz = getElementRotation(theVehicle)

				if (rampType == "loop-de-loop") then
					radius = 32
				elseif (rampType == "big-loop") then
					radius = 48
				else
					radius = 24
				end
		
		
				local offset = math.rad(rz - 270)
				local vx = px + radius * math.cos(offset)
				local vy = py + radius * math.sin(offset)
				local vz = getGroundPosition(vx, vy, pz) + 2.4

				if (rampType == "fat-ramp") then
					rampID = 1655
					vz = vz - 1.2
				elseif (rampType == "short-ramp") then
					rampID = 1632
					vz = vz - 1.2
				elseif (rampType == "loop-de-loop") then
					rampID = 13641
					vz = vz - 1.2
					rz = rz + 90
				elseif (rampType == "big-loop") then
					rampID = 13592
					vz = vz + 7.5
					rz = rz + 90
				end
		
				-- Create the ramp.
				triggerServerEvent("spawnRamp", getRootElement(), getLocalPlayer(), rampID, vx, vy, vz, rz)	
			else
				cancelEvent ( )
			end
		end
end

function spawnDoubleRamp(key, keyState, rampType)
	if getElementData(getLocalPlayer(), "gamemode") ~= "freeroam" then return end
	local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
	if theVehicle then
		if isVehicleOnGround ( theVehicle ) then
		
			-- Get current position of the vehicle.
			local px, py, pz = getElementPosition(theVehicle)
			local rz, rz, rz = getElementRotation(theVehicle)

			local offset = math.rad(rz - 270)
			local vx = px + 24 * math.cos(offset)	-- The rule applied below is the same for this
			local vy = py + 24 * math.sin(offset)   -- vy = py + radius, but the radius is always 24, so no need.
			local vz = getGroundPosition(vx, vy, pz) + 2.4
		
			local ramp2vx = px + 31.1 * math.cos(offset) -- Radius for the 2nd ramp is 31.1
			local ramp2vy = py + 31.1 * math.sin(offset) 

			vz = vz - 1.2
		
			-- Create the ramp.
			triggerServerEvent("spawnDoubleRamp", getRootElement(), getLocalPlayer(), vx, vy, vz, rz, ramp2vx, ramp2vy)
		else
			cancelEvent ( )
		end
	end
end

-- ********************
-- *  Event handlers  *
-- ********************
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		bindKey("1", "down", spawnRamp, "short-ramp")
		bindKey("2", "down", spawnRamp, "loop-de-loop")
		bindKey("3", "down", spawnDoubleRamp)
		bindKey("4", "down", spawnRamp, "fat-ramp")
		bindKey("5", "down", spawnRamp, "big-loop")
	end
)
