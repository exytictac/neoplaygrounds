
local dimensions = {
	["freeroam"] = 1,
	["koth"] = 200,
	["manhunt"] = 420,
	["rpg"] = 100
}

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
	return getElementData ( p, "account" ) and true or false
end


function getPlayerAchievements ( p )
	return getElementData ( p, "achievements" ) or 0
end

function getPlayerPoints ( p )
	return getElementData ( p, "points" ) or 0
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

function getPlayerMinigame(p)
    return getElementData(p, "minigame")
end

function getAuth(thePlayer)
	return getElementData(thePlayer, "auth") or 0
end

function hasMoney(thePlayer, amount)
	amount = tonumber( amount ) or 0
	if thePlayer and isElement(thePlayer) and amount > 0 then
		amount = math.floor( amount )
		
		return getMoney(thePlayer) >= amount
	end
	return false
end

function getMoney(thePlayer)
	return getElementData(thePlayer, getPlayerGamemode ( thePlayer )) and "money" or 0
end


function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function dec2hex(v)
	return string.format("%X", type(v)=="string" and tonumber(v) or v)..""
end

