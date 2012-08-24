﻿-- needs configurable blip colors, and team support
root = getRootElement ()
color = { 13, 199, 203 }
players = {}
resourceRoot = getResourceRootElement ( getThisResource () )

function onResourceStart ( resource )
  	for id, player in ipairs( getElementsByType ( "player" ) ) do
		if ( players[player] ) then
			createBlipAttachedTo ( player, 0, 2, players[source][1], players[source][2], players[source][3] )
		else
			createBlipAttachedTo ( player, 0, 2, color[1], color[2], color[3] )
		end
	end
end

function onPlayerSpawn ( spawnpoint )
	if ( players[source] ) then
		createBlipAttachedTo ( source, 0, 2, players[source][1], players[source][2], players[source][3] )
	else
		createBlipAttachedTo ( source, 0, 2, color[1], color[2], color[3] )
	end
end

function onPlayerQuit ()
	destroyBlipsAttachedTo ( source )
end

function onPlayerWasted ( totalammo, killer, killerweapon )
	destroyBlipsAttachedTo ( source )
end




addEventHandler ( "onPlayerJoin", root, onResourceStart )
addEventHandler ( "onPlayerSpawn", root, onPlayerSpawn )
addEventHandler ( "onPlayerQuit", root, onPlayerQuit )
addEventHandler ( "onPlayerWasted", root, onPlayerWasted )

function destroyBlipsAttachedTo(player)
	local attached = getAttachedElements ( player )
	if ( attached ) then
		for k,element in ipairs(attached) do
			if getElementType ( element ) == "blip" then
				destroyElement ( element )
			end
		end
	end
end