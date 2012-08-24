
-- ******************************************
-- * AFS Staff / Anti vehicles hack         *
-- * Written by Tommy (c) 2010              *
-- ******************************************

function getAuth ( player ) 
	return getElementData ( player, "auth" ) or 0
end

-- ********************
-- *  Event handlers  *
-- ********************
addEventHandler("onPlayerVehicleEnter", getRootElement(),
	function()
		local theVehicle = getPedOccupiedVehicle(source)
		local id = getElementModel(theVehicle)
		local playerClass = getElementData(source, "auth")
		if (playerClass == false) then
			playerClass = 1
		end

		if (id == 432) then
			-- Only staff can use this vehicle. Otherwise, we destroy the vehicle
			-- and we report that in the cheatlog.
			if (playerClass < 1) then
				triggerEvent("reportToStaffLog", getRootElement(), source, "Disallowed vehicle", getVehicleName(theVehicle))
				destroyElement(theVehicle)

				return
			end
		end

		if (id == 432 or id == 425 or id == 520 or id == 447 or id == 476 or id == 430 or id == 464) then
			-- Only staff can shoot with these vehicles.
			if (playerClass <= 1) then
				toggleControl(source, "vehicle_fire", false)
				toggleControl(source, "vehicle_secondary_fire", false)
			else
				-- Enable shoots for staff :D .
				toggleControl(source, "vehicle_fire", true)
				toggleControl(source, "vehicle_secondary_fire", true)
			end
		end
	end
)


function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
		end
	else
		return false
	end
end

function setElementSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	end
	return false
end

addEventHandler( "onClientKey", getRootElement(),
function(button, press)
	theVehicle = getPedOccupiedVehicle(getLocalPlayer())
	getspeed = getElementSpeed(theVehicle,2)
	if getAuth ( getLocalPlayer() ) >= 2 then
		if (button == "mouse_wheel_up") and (theVehicle) and (isPedInVehicle(getLocalPlayer())) and not (getspeed == 0) then
			setElementSpeed(theVehicle, 2, getspeed+10)
		elseif (button == "mouse_wheel_down") and (theVehicle) and (isPedInVehicle(getLocalPlayer())) and not (getspeed == 0) then
			setElementSpeed(theVehicle, 2, getspeed-15)
		end
	else
		cancelEvent ( )
	end
end
)

