-- King of the Hill gamemode created by qaisjp. Copyright Neo Playgrounds 2011

local debug=true
if debug then
	addCommandHandler('kothleave', function(p) setElementData(p, 'gamemode', false, true) end)
end


local teamNames = {'Red','Green','Blue'}
local teams={}

local function getAvailableTeams(playerLimit)
 	local list = {}
 	local n = playerLimit or 100
	for teamName, team in pairs(teams) do
		local count = countPlayersInTeam(team)
    	if count == n then
   		   list[teamName] = true
  		elseif count < n then
  		    n = count
   		    list = {[teamName]=true}
    	end
 	end
	return list
end

local function getPlayers(alive)
	local tab = {}
	for i,v in ipairs(getElementsByType('player')) do
		if getElementData(v,'gamemode')=='king of the hill' then 
			if alive then
				if not isPedDead(v) then
					table.insert(tab, v)
				end
			else
				table.insert(tab, v)
			end
		end
	end
	return tab
end

function addPlayerToTeam(p, team)
	if getAvailableTeams()[team:lower()] then
		setPlayerTeam(p, getTeamFromName('koth:'..team:lower()))
		return true
	end
	return false
end

addEvent('koth:setTeam', true)
addEventHandler('koth:setTeam', root, function(id)
		if addPlayerToTeam(source, teamNames[id])  then
			triggerClientEvent(source, 'koth:activeRound', root)
			return
		end
		triggerClientEvent(source,'koth:teamfull')
	end
)

addEvent('onPlayerSelectGamemode', true)
addEventHandler('onPlayerSelectGamemode', root, function(gm)
	if gm ~= 'king of the hill' then return end
	setElementDimension(source, 200)
end)

addEventHandler('onResourceStart', resourceRoot, function()
		setElementDimension ( getResourceMapRootElement( resource, 'koth.map' ) , 200 )
		
		exports.scoreboard:scoreboardForceTeamsHidden( true )
		
		teams.red = createTeam('koth:red', 255, 0, 0)
		teams.green = createTeam('koth:green', 0, 255, 0)
		teams.blue = createTeam('koth:blue', 0, 255, 255)
	end
)