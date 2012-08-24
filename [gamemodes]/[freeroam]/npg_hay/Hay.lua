local hayCollisionsCircle = createColCircle(-8.9533233642578, -11.124545097351, 50)
setElementDimension(hayCollisionsCircle, 1)
local minigameHayMarker = createMarker (-10,-10,0, "checkpoint", 70, 0, 128, 255, 100, getRootElement())
setElementDimension(minigameHayMarker, 1)


function onMainColHit(thePlayer, matchingDimension)
	if (not matchingDimension) then return end
	if getElementData(thePlayer, "gamemode") ~= "freeroam" and getElementData(thePlayer, "minigame") == true then return end
	if (getElementType(thePlayer) == "player") then
		if isElementWithinMarker ( thePlayer, minigameHayMarker ) then
			outputChatBox("#FFFF00Welcome to the Hay minigame", thePlayer, 255, 100, 100, true)
			toggleControl (thePlayer, "fire", false)
			toggleControl (thePlayer, "next_weapon", false)
			toggleControl (thePlayer, "previous_weapon", false)
			toggleControl (thePlayer, "aim_weapon", false)
			toggleControl (thePlayer, "vehicle_fire", false)
			toggleControl(thePlayer, "enter_exit", false )
			toggleControl (thePlayer, "vehicle_secondary_fire", false)
			setElementData ( thePlayer, "hay:currentlevel", 0, true )
			toggleControl (thePlayer, "vehicle_fire", false)
			showPlayerHudComponent (thePlayer, "ammo", false)
			showPlayerHudComponent (thePlayer, "weapon", false)
			setElementData(thePlayer, "minigame", true)
			triggerClientEvent(thePlayer, "hay:client", root,"join")
			if getPedOccupiedVehicle(thePlayer) then
				destroyElement(getPedOccupiedVehicle(thePlayer))
			end
			if doesPedHaveJetPack(thePlayer) then
				removePedJetPack(thePlayer)
			end
			if tonumber(getElementData(thePlayer, "hay:currentlevel")) or 100 >= 2 then
			end
		end
	elseif getElementType(thePlayer) == "vehicle" then
		local occupants = getVehicleOccupants(thePlayer)
        local seats = getVehicleMaxPassengers(thePlayer)
		destroyElement(thePlayer)
		for seat = 0, seats do -- Repeat with seat = 0, incrementing until it reaches the amount of passenger seats the vehicle has
			local occupant = occupants[seat] -- Get the occupant
			if occupant and getElementType(occupant)=="player" then -- If the seat is occupied by a player...
			end
        end
	elseif getElementType(thePlayer) == "projectile" then
		destroyElement(thePlayer)
	end
end



function onMainColLeave(thePlayer, matchingDimension)
	if (not matchingDimension) or (getElementType(thePlayer)~="player") then return end
	if getElementData(thePlayer, "gamemode") == "freeroam" and getElementData(thePlayer, "minigame") then 
		outputChatBox("#FFFF00You left the Hay minigame", thePlayer, 255, 100, 100, true)
		toggleControl (thePlayer, "fire", true)
		toggleControl (thePlayer, "next_weapon", true)
		toggleControl(thePlayer, "enter_exit", true)
		toggleControl (thePlayer, "previous_weapon", true)
		toggleControl (thePlayer, "aim_weapon", true)
		toggleControl (thePlayer, "vehicle_fire", true)
		toggleControl (thePlayer, "vehicle_secondarry_fire", true)
		toggleControl (thePlayer, "vehicle_fire", true)
		showPlayerHudComponent (thePlayer, "ammo", true)
		showPlayerHudComponent (thePlayer, "weapon", true)
		setElementData(thePlayer, "minigame", false, true)
		setElementData(thePlayer, "hay:currentlevel", false, true)
		triggerClientEvent(thePlayer, "hay:client", root, "leave")
end
end

addEventHandler ( "onColShapeLeave", hayCollisionsCircle,  onMainColLeave)
addEventHandler ("onColShapeHit", hayCollisionsCircle, onMainColHit)


addEventHandler ( "onPlayerWasted", resourceRoot,
	function ( )
		if isElementWithinMarker ( source, minigameHayMarker ) then
			setTimer (
				function ()
					spawnPlayer ( source, 24.45340, -26.35221, 3.11719 )
				end, 
			3000, 1 )
		else 
			return
		end
	end
)	



local options = {
	x = 4,
	y = 4,
	--z = 49, -- +1
	z = 39, -- +1
	--b = 245,
	b = 123,
	r = 4,
	dimension = 1
}
-- Don't touch below!
local matrix, objects, moving = {}, {}, {}
local xy_speed, z_speed, barrier_x, barrier_y, barrier_r

function move ()
	--outputDebugString("move entered")
	local rand
	repeat
		rand = math.random ( 1, options.b )
	until (moving[rand] ~= 1)
	local object = objects[ rand ]
	local move = math.random ( 0, 5 )
	--outputDebugString("move: " .. move)
	local x,y,z
	local x2,y2,z2 = getElementPosition ( object )
	local free = {}
	copyTable(matrix,free)
	getFree(free)
	x = x2 / -4
	y = y2 / -4
	z = z2 / 3
	if (move == 0)  and (x ~= 1) and (free[x-1][y][z] == 0) then
		moving[rand] = 1
		local s = 4000 - xy_speed * z
		setTimer (done, s, 1, rand, x, y, z)
		x = x - 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2 + 4, y2, z2, 0, 0, 0 )
	elseif (move == 1) and (x ~= options.x) and (free[x+1][y][z] == 0) then
		moving[rand] = 1
		local s = 4000 - xy_speed * z
		setTimer (done, s, 1, rand, x, y, z)
		x = x + 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2 - 4, y2, z2, 0, 0, 0 )
	elseif (move == 2) and (y ~= 1) and (free[x][y-1][z] == 0) then
		moving[rand] = 1
		local s = 4000 - xy_speed * z
		setTimer (done, s, 1, rand, x, y, z)
		y = y - 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2, y2 + 4, z2, 0, 0, 0 )
	elseif (move == 3) and (y ~= options.y) and (free[x][y+1][z] == 0) then
		moving[rand] = 1
		local s = 4000 - xy_speed * z
		setTimer (done, s, 1, rand, x, y, z)
		y = y + 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2, y2 - 4, z2, 0, 0, 0 )
	elseif (move == 4) and (z ~= 1) and (free[x][y][z-1] == 0) then
		moving[rand] = 1
		local s = 3000 - z_speed * z
		setTimer (done, s, 1, rand, x, y, z)
		z = z - 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2, y2, z2 - 3, 0, 0, 0 )
	elseif (move == 5) and (z ~= options.z) and (free[x][y][z+1] == 0) then
		moving[rand] = 1
		local s = 3000 - z_speed * z
		setTimer (done, s, 1, rand, x, y, z)
		z = z + 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2, y2, z2 + 3, 0, 0, 0 )
	end
end


function onThisResourceStart ( )
	--Calculate speed velocity
	xy_speed = 2000 / (options.z + 1)
	z_speed = 1500 / (options.z + 1)

	--Clean matrix
	for x = 1,options.x do
		matrix[x] = {}
		for y = 1,options.y do
			matrix[x][y] = {}
			for z = 1,options.z do
				matrix[x][y][z] = 0
			end
		end
	end

    --Place number of haybails in matrix
	local x,y,z
	for count = 1,options.b do
		repeat
			x = math.random ( 1, options.x )
			y = math.random ( 1, options.y )
			z = math.random ( 1, options.z )
		until (matrix[x][y][z] == 0)
		matrix[x][y][z] = 1
		objects[count] = createObject ( 3374, x * -4, y * -4, z * 3 ) --, math.random ( 0, 3 ) * 90, math.random ( 0, 1 ) * 180 , math.random ( 0, 1 ) * 180 )
		setElementDimension(objects[count], options.dimension)
	end

	--Place number of rocks in matrix
	for count = 1,options.r do
		repeat
			x = math.random ( 1, options.x )
			y = math.random ( 1, options.y )
			z = math.random ( 1, options.z )
		until (matrix[x][y][z] == 0)
		matrix[x][y][z] = 1
		setElementDimension(createObject ( 1305, x * -4, y * -4, z * 3, math.random ( 0, 359 ), math.random ( 0, 359 ), math.random ( 0, 359 ) ), options.dimension)
	end
	
	--Calculate tower center and barrier radius
	barrier_x = (options.x + 1) * -2
	barrier_y = (options.y + 1) * -2	
	if (options.x > options.y) then 
		barrier_r = options.x / 2 + 20 
	else
		barrier_r = options.y / 2 + 20 
	end
	
	--Place top-haybail + minigun
	setElementDimension(createObject ( 3374, barrier_x, barrier_y, options.z * 3 + 3 ), options.dimension)
	thePickup = createPickup ( barrier_x, barrier_y, options.z * 3 + 6 - 1, 3, 1273, 100 )
	setElementDimension(thePickup, options.dimension)
	setTimer ( move, 100, 0 )
	
	--[[hayCollisionsCircle = createColCircle(barrier_x, barrier_y, barrier_r)
	setElementDimension(hayCollisionsCircle, 1)]]
end

function msToTimeStr(ms)
	if not ms then
		return ''
	end
	local centiseconds = tostring(math.floor(math.fmod(ms, 1000)/10))
	if #centiseconds == 1 then
		centiseconds = '0' .. centiseconds
	end
	local s = math.floor(ms / 1000)
	local seconds = tostring(math.fmod(s, 60))
	if #seconds == 1 then
		seconds = '0' .. seconds
	end
	local minutes = tostring(math.floor(s / 60))
	--return minutes .. ':' .. seconds .. ':' .. centiseconds
	return minutes .. ' minutes and ' .. seconds .. ' seconds.'
end

function onPickupHit ( player )
	if source == thePickup then
		if getElementType(player) ~= "player" or getElementDimension(player) ~= 1 then return end
		if getElementData(player, "hay:timetaken") >= 60000 then
			outputChatBox(getPlayerName( player ) .. "#FFFF00 has reached the top of the hay-stack in " .. msToTimeStr(tonumber(getElementData(player, "hay:timetaken"))), root, 0, 255, 100, true)
			givePlayerMoney (player, 1000)
setTimer ( setElementPosition, 1500, 1, player,  77, -26, 2 )
		else
			outputChatBox(getPlayerName(player).." has been caugh cheating, shame on him!", root, 255,0,0)
			setElementPosition (player, -19.21, -30.34, 3.1171875)
			setTimer(killPed, 500, 1, player)
		end
	end
end

function done ( id, x, y, z )
	moving[id] = 0
	matrix[x][y][z] = 0
end

function getFree ( src )
	local x,y,z
	local players = getElementsByType( "player" )
	for k,v in ipairs(players) do
		x,y,z = getElementPosition( v )
		x = math.floor(x / -4 + 0.5)
		y = math.floor(y / -4 + 0.5)
		z = math.floor(z / 3 + 0.5)
		if (x >= 1) and (x <= options.x) and (y >= 1) and (y <= options.y) and (z >= 1) and (z <= options.z) then
			src[x][y][z] = 2
		end
	end
end

function copyTable ( src, des )
	for k,v in ipairs(src) do
		if (type(v) == "table") then
			des[k] = {}
			copyTable(src[k],des[k])
		else
			des[k] = v
		end
	end
end

addEventHandler( "onResourceStart", getResourceRootElement(getThisResource()), onThisResourceStart)
addEventHandler( "onPickupHit", root, onPickupHit)
