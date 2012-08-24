--[[
RolePlay:
-Money day(You get +1000$ if you join the roleplay, in that day)

Freeroam:
-Disco(Vehicle headlights and water color changes instantly)
 and Flood (Water would go +300 levels)

Race:
-Free Upgrades Day(Max 5 free NOS's in that day)
-Race skill(You get +5 points)

DM/DD:
-Vehicle damage proof(2 uses in that day)
]]--

local bonus = {
	rp = 1000
}
addEvent("onPlayerRequestBonus", true )
addEventHandler("onPlayerRequestBonus", root, 
function ( gamemode, bypass )
		local time = getRealTime()
		bypass = tonumber(bypass) or 0
		local acc = getPlayerAccount ( source )
		if time.weekday == 0 then --Sunday
			-- We check the gamemode, check if bonus has been granted, if not granted - give bonus
			if gamemode == "roleplay" and bypass == 1 then 
				if getAccountData(acc, "roleplay.bonusgranted") == "0" then
					setElementData(source, "cash", getElementData ( source, "cash" )+bonus.rp, true)
					setAccountData(acc, "roleplay.bonusgranted", "1")
				end
			end
		else
			-- Reset the granted value
			setAccountData(acc, "roleplay.bonusgranted", "0")
			setAccountData(acc, "race.bonusgranted", "0")
			setAccountData(acc, "hns.bonusgranted", "0")
			setAccountData(acc, "dmdd.bonusgranted", "0")
		end
	end
)