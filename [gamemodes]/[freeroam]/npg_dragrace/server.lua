-- *************************************************
-- *  NPG_dragrace - server.lua                    *
-- *  Written by CapY and Noddy - NPG Team (c) 2012*  
-- *************************************************

local DragStatus = false -- false=none, 0=waiting, 1=happening
local dragPlayers = {}
local dimension = 0
local frDimension = 1
local CARMODEL = 411
local spawns = {
	{-1665.427734375, -160.54296875, 13.78920173645, 0, 359.99450683594, 315.615234375},
	{-1658.3291015625, -167.8896484375, 13.789279937744, 0, 359.99450683594, 317.49938964844},
	{-1651.1669921875, -174.88671875, 13.789273262024, 0, 359.98901367188, 315.31311035156}
}
local markers = {
	{-1585.5911865234, -92.589302062988, 13.186800003052, "checkpoint", 25, 0, 0, 255, 205},
	{-1365.4417724609, 127.99739837646, 13.186800003052, "checkpoint", 25, 0, 0, 255, 205},
	{-1085.57421875, 406.91558837891, 13.186800003052, "checkpoint", 25, 0, 0, 255, 205}
}


function markerHit ( player )
	if isElement ( markers[i] ) == player then
		destroyElement ( markers[i] )
	end
end

for i, v in ipairs ( markers ) do
	markers[i] = createMarker(unpack(v))
	setElementDimension(markers[i], dimension)
	addEventHandler ( "onMarkerHit", markers[i], markerHit )
end





function getRandomSpawn()
	local t = spawns[math.random(#spawns)]
	return t[1],t[2],t[3], t[4],t[5],t[6]
end

function getPlayersFromMinigame( mg )
   local tab = {}
   for i,v in ipairs(getElementsByType('player')) do
     if getElementData(v, 'minigame') == mg then table.insert(tab, v) end 
   end
   return tab
end

addCommandHandler ( "drag", 
	function ( player )
		if (getElementData ( player, "gamemode" ) ~= "freeroam") then return end
		if not getElementData(player, 'minigame') and getElementInterior(player)==0 then
			triggerEvent ( 'drag:join', player )
		end
	end
)


addEvent('drag:join', true)
addEventHandler ( "drag:join", root, function()
		if DragStatus == 1 then
			outputChatBox('You may not join the drag race at this moment', source, 255, 0, 0)
			return
		elseif DragStatus == false then
			for i,v in ipairs(getElementsByType"vehicle") do
				if getElementDimension(v) == 0 then
					destroyElement(v)
				end
			end
		end
		DragStatus = 0
		fadeCamera ( source, false, 1.5)
		setTimer ( fadeCamera, 1500, 1, source, true, 1.5 )  
		setElementDimension ( source, 0 )
		setElementData( source, 'minigame', 'fr:drag', true)
		local x,y,z,rotx,roty,rotz = getRandomSpawn()
		local car = createVehicle(tonumber(CARMODEL) and tonumber(CARMODEL) or 411, x,y,z,rotx,roty,rotz, getPlayerName(source), false, math.random(0, 3), math.random(0, 3))
		for i,v in ipairs(getPlayersFromMinigame('fr:drag')) do
			triggerClientEvent(v, 'drag:playerjoined', source)
		end
		warpPedIntoVehicle(source, car)
	end
)

function dragDropCommand ( p )
	if getElementData ( p, "minigame" ) == "fr:drag" then
		dropPlayerFromDrag ( p )
	end
	fadeCamera ( p, true, 1.5, 0, 0, 0 )
end
addCommandHandler('dragnorm', dragDropCommand )



addEventHandler( "onVehicleStartExit", root, function(player)
	if getElementData(player, 'minigame') == 'fr:drag' then
		outputChatBox( "#ab23af[DRAG] #ff0000You cannot exit the vehicle during a drag race", player, 0, 0, 0, true)
		cancelEvent()
	end
end)

addEvent ( "drag:removeh", true )
addEventHandler ( "drag:removeh", resourceRoot,
	function ( )
		removePedFromVehicle ( source )
	end
)


function dropPlayerFromDrag(player)
	setElementData(player, 'JoinedDrag', false)
	setElementData(player, 'minigame', false, true)
	outputChatBox(getPlayerName(player)..'#ffff00 has left the drag race', root, 218, 152, 112)
	
	removePedFromVehicle(player)
	fadeCamera(player, false, 1.5, 0, 0, 0 )
	setTimer ( function ( )
		fadeCamera ( player, true, 1.5, 0, 0, 0 )
		end, 
	1500, 1 )
	--setTimer(l, 2500, 1, player, true, 1.5 )
	--setTimer( setElementPosition, 1555, 1, player, unpack(dragPlayers[l][1]) )
	setElementDimension(player, frDimension )
	
	if players() == 1 then
		local l
		for _, v in ipairs(dragPlayers) do
			l = v
		end
		outputChatBox(getPlayerName(l)..'#ffff00 has won the drag race', root, 218, 152, 112)
		giveMoney(l, 1000 )
		DragStarting = false
		DragStarted = false
	elseif players() == 0 then
		outputChatBox('The drag race ended without a winner', root, 218, 152, 112)
		DragStarting = false
		DragStarted = false
	end
end

addEventHandler ( "onResourceStop", resourceRoot, 
	function ( )
		for i, v in ipairs ( getPlayersFromMinigame ( 'fr:drag' ) ) do
			dragDropCommand ( v )
		end
	end
)