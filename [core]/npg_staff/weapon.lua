
-- ******************************************
-- * AFS Staff / Anti weapon hack           *
-- * Written by Tommy (c) 2010              *
-- ******************************************

local weaponsList = {
	"Brass Knuckles",
	"Golf club",
	"Nightstick",
	"Knife",
	"Baseball bat",
	"Shovel",
	"Pool cue",
	"Katana",
	"Chainsaw",
	"Long purple dildo",
	"Short tan dildo",
	"Vibrator",
	"??",
	"Flowers",
	"Cane",
	"Grenade",
	"Tear gas",
	"Molotov cocktails",
	"??",
	"??",
	"??",
	"Pistol",
	"Silenced pistol",
	"Desert eagle",
	"Shotgun",
	"Sawn-off shotgun",
	"SPAZ-12 Combat Shotgun",
	"Uzi",
	"MP5",
	"AK-47",
	"M4",
	"TEC-9",
	"Country rifle",
	"Sniper rifle",
	"Rocket Launcher",
	"Heat-seeking RPG",
	"Flamethrower",
	"Minigun",
	"Satchel charges",
	"Satchel detonator",
	"Spraycan",
	"Fire extinguisher",
	"Camera",
	"Night-vision goggles",
	"Infrared goggles",
	"Parachute"
}

addEventHandler("onPlayerWeaponSwitch", getRootElement(),
	function(previousWeapon, newWeapon)
		if (getElementType(source) == "player") then
			if (getElementDimension(source) ~= 100) then
				if (newWeapon == 0) then
					-- Exit the function.
					return
				end

				local playerClass = getElementData(source, "auth")
				if (playerClass == 0) then
					-- For all players, the following weapons are allowed: parachute, camera,
					-- purple dildo and vibrator.
					if (newWeapon == 46 or newWeapon == 43 or newWeapon == 10 or newWeapon == 12) then
						-- Exit the function.
						return
					end
				else
					return
				end

				-- If a disallowed weapon has been detected, we report it.
				triggerEvent("reportToStaffLog", getRootElement(), source, "Disallowed weapon", weaponsList[newWeapon])
				setTimer(takeWeapon, 50, 1, source, newWeapon)
			end
		end
	end
);
