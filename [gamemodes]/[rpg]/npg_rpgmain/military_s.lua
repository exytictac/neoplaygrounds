o = outputChatBox
local RPGDimension = 100

function getPlayerGamemode(pl)
	return pl and getElementData(pl, "gamemode") or false
end

marker = {}
gate = {}

marker[1] = createMarker ( 2719, -2405, 11, "cylinder", 9, 255,0,0,0 )
marker[2] = createMarker ( 2720, -2504, 13, "cylinder", 9, 255,0,0,0 )


gate[1] = createObject ( 2933, 2720, -2405, 14, 0, 0, 90 )
gate[2] = createObject ( 2933, 2720, -2504, 14, 0, 0, 90 )

for i, v in ipairs ( marker ) do
	setElementDimension ( v, RPGDimension )
	for z, n in ipairs ( gate ) do
		setElementDimension ( n, RPGDimension )
	end
end





addEventHandler ( "onMarkerHit", marker[2],	
	function ( hElement )
	local x,y,z = getElementPosition ( gate[2] )
		if isPlayerInTeam ( hElement, "Military" )  then
			moveObject ( gate[2], 1000, x, y - 10, z )
		else
			cancelEvent ( )
		end
	end
)
  
addEventHandler ( "onMarkerLeave", marker[2],
	function  ( lElement )
	local x,y,z = getElementPosition ( gate[2] )
		if isPlayerInTeam ( lElement, "Military" )  then
			moveObject ( gate[2], 1000, x, y + 10, z )
		else
			cancelEvent ( )
		end
	end
)

addEventHandler ( "onMarkerHit", marker[1],
	function ( hElement )
	local x,y,z = getElementPosition ( gate[1] )
		if isPlayerInTeam ( hElement, "Military" )  then
			moveObject ( gate[1], 1000, x, y + 10, z )
		else
			cancelEvent ( )
		end
	end
)
    
addEventHandler ( "onMarkerLeave", marker[1], 
	function ( lElement )
	local x,y,z = getElementPosition ( gate[1] )
		if isPlayerInTeam ( lElement, "Military" )  then
			moveObject ( gate[1], 1000, x, y - 10, z )
		else
			cancelEvent ( )
		end
	end
)