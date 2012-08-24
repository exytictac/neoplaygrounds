-- NPG Feature Manager by Noddy
-- Some addons made by CapY

local dimensions = {
	--["race"] = 0,
	["freeroam"] = 1,
	["koth"] = 200,
	["manhunt"] = 420,
	["rpg"] = 100
}

poolTable = {
	["player"] = {},
	["vehicle"] = {},
	["colshape"] = {},
	["ped"] = {},
	["marker"] = {},
	["object"] = {},
	["pickup"] = {},
	["team"] = {},
	["blip"] = {}
}

local indexedPools =
{
	player = {},
	vehicle = {},
	team = {}
}


function getElement(elementType, id)
	return indexedPools[elementType] and indexedPools[elementType][tonumber(id)]
end

function getWorkingDimension(area)
	return tonumber(dimensions[area]) or 0 -- OR DIE IN A HOLE
end

function table.vfind(t, val)
	for i,v in pairs(t) do
		if v==val then return true end
	end
end
function table.kfind(t, i)
	for k,v in pairs(t) do
		if k == i then return true end
	end
end
function table.same(t, i)
	if #t ~= #i then return false end
	for k,v in pairs(t) do
		if i[k] ~= v then return false end
	end
end

function isPlayerLoggedIn(p)
	return isGuestAccount( getPlayerAccount(p) )
end

function getClassName(player)
	if class == 1 then
		return 'VIP'
	elseif class == 2 then
		return "Moderator"
	elseif class == 3 then
		return "Administrator"
	else
		return "Guest"
	end
end

function getClassFromName(name)
	name = tostring(name):lower()
	if name == 'guest' then
		return 0
	elseif name == 'vip' then
		return 1
	elseif name == 'mod' or name == 'moderator' then
		return 2
	elseif name =='admin'or name=='administrator' then
		return 3
	end
end

function getPlayerGamemode(pl)
	return pl and getElementData(pl, "gamemode") or false
end

function getGamemodeName(pl)
	local gmName = tostring(getPlayerGamemode(pl))
	if gmName == "freeroam" then
		return "Freeroam"
	elseif gmName == "rpg" then
		return "RPG"
	elseif gmName == "race" then
		return "Race"
	elseif gmName == "manhunt" then
		return "Manhunt"
	elseif gmName == "gungame" then
		return "GunGame"
	else
		return "None"
	end
end

function isPlayerReady(pl)
	return getPlayerGamemode(pl) and true or false
end

function isValidType(elementType)
	return poolTable[elementType] ~= nil
end

function getPlayerMinigame(p)
    return getElementData(p, "minigame")
end

function getAuth(thePlayer)
	return getElementData(thePlayer, "auth") or 0
end


function dec2hex(v)
	return string.format("%X", type(v)=="string" and tonumber(v) or v)..""
end

function getPoolElementsByType(elementType)
	if (elementType=="pickup") then
		return getElementsByType("pickup")
	end

	if isValidType(elementType) then
		return poolTable[elementType]
	end
	return false
end