--[[
RolePlay:
-Money day(You get +10000$ if you join the roleplay, in that day)

Freeroam:
-Disco day(Vehicle headlights and water color changes instantly)
-Flood day(Water would go +300 levels
-Zombie day(Zombies all around of you)

Race:
-Free Upgrades Day(Max 5 free NOS's in that day)
-Race skill(You get +5 points)

DM/DD:
-Vehicle damage proof(2 uses in that day)
]]

local me = getLocalPlayer()

addEvent("onClientPlayerSelectGamemode", true )
addEventHandler("onClientPlayerSelectGamemode", me,
    function ( gm )
		triggerServerEvent("onPlayerRequestBonus", me, gm)
	end
)
	