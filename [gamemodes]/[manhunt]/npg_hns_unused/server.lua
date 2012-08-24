--[[
	Only the mods
	- /hns : toggle HNS GUI
	- /hns open : open the game to new players (disables hns lobby)
	- /hns close : close the game to new players (enables hns lobby)
	- /hns restart : stop the current round
	- /hns hide player* : set the hider to be player
	- /hns area ID : set the current play area
]]
addEvent("onManhuntPlayerStart", true)
addEventHandler("onManhuntPlayerStart", root, function()
		if not source then return end
		spawnPlayer(source, 0,0,0,0, 0, 0, HNS_DIMENSION, TEAM)
		setTimer(fadeCamera,600,1,true)
	end
)

function commandManhunt(player,_, func, top)
	if top then top = getPlayerFromName(top) end
	if func then
		if func=="restart" then
			MH:restartRound()
		end
	end
end

addCommandHandler("manhunt", commandManhunt)