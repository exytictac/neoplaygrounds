MH              = {}                          -- Host for main MH functions
HNS_DIMENSION   = 420		     		      -- The dimension in which HnS will initiate
HUNTING_TIME	= 45*1000     			      -- The amount of time a player has to find a hiding spot
PLAYERS         = {}             			  -- The players inside HnS
HIDING          = false                       -- The person who is hiding
TEAM            = createTeam("Manhunt")       -- Creates Manhunt team
setElementData(TEAM, "lol", "hi", true)
SPAWN_FILE      = "spawns.xml"

--[[
	Gets the time a player gets to hide
--]]
function MH:getHidingTime()
	return HIDING_TIME
end

--[[
	Removes a player from Hide and Seek
--]]
function MH:leave(player)
	if not PLAYERS[player] then return end
	PLAYERS[player] = false
	setElementDimension(player, 0)
	return true
end

--[[
	Sets the hider at Hide and Seek
--]]
function MH:setHider(p)
	-- ...
end

--[[
	Gets the hide at Hide and Seek
--]]
function MH:getHider()
	-- ...
end

--[[
	If the player is hiding, it resets the time the player has to hide
--]]
function MH:resetPlayerHidingTime(p)
	-- ...
end

--[[
	Sets the hiding time
--]]
function MH:setHidingTime(time)
	HIDING_TIME = time
end

--[[
	Gets the players who are in Hide and Seek
--]]
function MH:getPlayers()
	return PLAYERS
end

--[[
	Gets the team of Hide and Seek
--]]
function MH:getTeam()
	return TEAM
end

--[[
	Counts the players who are playing hide and seek
--]]
function MH:countPlayers()
	return table.getn(PLAYERS)
end

--[[
	Checks if a player is playing Hide and Seek
--]]
function MH:isPlaying(p)
	return PLAYERS[p] or false
end

--[[
	Adds a player to Hide and Seek
--]]
function MH:join(player)
	if MH:isPlaying(player) then
		return false, "You are already in Hide and Seek!"
	end
	if not MH:isStarted() then
		return false, "Hide and Seek has not been started"
	end
	
	PLAYERS[player] = true
	setElementDimension(player, MH_DIMENSION)
end