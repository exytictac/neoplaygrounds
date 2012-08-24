--[[
	Type: Gamemode
	Started: 6th July (Wednesday) 2011
	Finished: ...
	Official Developer: noddy

	You may edit this script to modify functionality to your liking, however this license must remain intact, you must 
	also state what you modified.

	This script is copyrighted by Neo Playgrounds 2011-2012
]]

addEvent("onPlayerStartManhunt", true)

local destroy      = destroyElement
local DESTROYQ     = { }
local g_PlayerData = { }
local SPAWNS       = { PED = {}, VEH = {} }
local BOUNCERS     = {
    getElementByID("bd-bounce-1"),
    getElementByID("bd-bounce-2"),
    getElementByID("bd-bounce-3")
}
INT                = 15
DIM                = 420
GRAV               = 0.008
local node         = xmlLoadFile("server/spawns.xml")
local pednode      = xmlFindChild(node, "ped", 0)
local vehnode      = xmlFindChild(node, "veh", 0)
local PROTECT = createColCuboid(-1502, 944, 1020, 230, 110, 14)
local ACTIVEVEH = 411


function StartRound(vehid)
	for i,v in ipairs(getElementsByType'vehicle') do
		if getElementDimension(v)==DIM then destroyElement(v) end
	end

	for i,v in pairs(g_PlayerData) do
		if isElement(i) then
			ROUND = true
			spawnThePlayer(i)
			ACTIVEVEH = vehid or ACTIVEVEH
			g_PlayerData[i]['active'] = true
			local x,y,z,rotx,roty,rotz = unpack(getRandomFromTable(SPAWNS.VEH))
			veh = createVehicle(tonumber(ACTIVEVEH) or 411, x,y,z,rotx,roty,rotz,'NPGFTW', true)
			setElementDimension(veh, DIM)
			setElementInterior(veh, INT)
			setTimer(warpPedIntoVehicle,200,1,i, veh)
			setElementVelocity(veh, 0,0,0)
			setElementHealth(veh, 1000)
			setElementCollisionsEnabled(veh, false)
			setElementFrozen(veh, true)
			g_PlayerData[i].veh = veh
			triggerClientEvent(i, 'mh:countdown', root)
		else g_PlayerData[i]=nil end
	end
	setTimer(function()
		for i,v in pairs(g_PlayerData) do
			if isElement(i) then
				if g_PlayerData[i] and g_PlayerData[i]['active'] then
					setElementFrozen(v.veh, false)
					setTimer(setElementCollisionsEnabled, 3000, 1, v.veh, true)
				end
			end
		end
	end,1000, 1)
end
addCommandHandler('mhspawn', StartRound)
--
function bounceItem(hit, dim)
	if dim and getElementType(hit) == "vehicle" then
		local player = getVehicleOccupant(hit,0)
		if g_PlayerData[player] and g_PlayerData[player]['active'] then
			setElementVelocity (hit, 0.75, 0.75, -0.1 )
		end
	end
end

function onResourceStart(res)
	if res == getThisResource() then
		setGravity(GRAV)
		for i,spawnNode in ipairs(xmlNodeGetChildren(pednode)) do
			local tstring = tostring(xmlNodeGetValue(spawnNode))
			SPAWNS.PED[i] = split(tstring, string.byte(" "))
		end
		for i,spawnNode in ipairs(xmlNodeGetChildren(vehnode)) do
			local tstring = tostring(xmlNodeGetValue(spawnNode))
			SPAWNS.VEH[i] = split(tstring, string.byte(" "))
		end
		
		for _,blip in ipairs(getElementsByType("blip")) do
			destroyElement(blip)
		end
		
		for _,veh in ipairs(getElementsByType("vehicle")) do
			if getElementDimension(veh) == DIM then
				destroyElement(veh)
			end
		end
		
		for _,pl in ipairs(getElementsByType('player')) do
			if getElementData(pl, 'gamemode') == 'manhunt' then
				onGamemodeEnter(pl)
			end
		end
		
		for _,marker in ipairs(BOUNCERS) do
			addEventHandler("onMarkerHit", marker, bounceItem)
		end
		
		--[[for _, player in ipairs(getElementsByType"player") do
			if getElementData(player, "gamemode")=="manhunt" then
				redirectPlayer(player)
			end
		end]]
	end
end

function spawnThePlayer(pl)
	local x,y,z = unpack(getRandomFromTable(SPAWNS.PED))
	spawnPlayer(pl, x,y,z, 0, getRandomFromTable(getValidPedModels()), INT, DIM)
	setElementPosition(pl,x,y,z)
	setElementInterior(pl, INT)
	setElementDimension(pl, DIM)
	setCameraInterior(pl, INT)
	setCameraTarget(pl, pl)
	setPedGravity(pl, GRAV)
	setTimer(setCameraTarget, 100, 1, pl, pl)
end

function onVehicleStartExit(player, seat, jack, door)
	if getElementData(player, "gamemode") ~= "manhunt" then return end
	if g_PlayerData[player].active == true then
		setElementHealth(source, 0)
		--Would have faded out the veh
		--setTimer(startSpectate, 1000, 1, player)
	end
end

function onPlayerQuit(reason)
	if g_PlayerData[source] then
		destroyElement(g_PlayerData(source,'blip') or source)
		g_PlayerData(source, nil)
	end
end

function onGamemodeEnter(pl)
	if not g_PlayerData[pl] then
		g_PlayerData[pl] = {active=false}
	end
	spawnThePlayer(pl)
	local blip = createBlipAttachedTo(pl,0,2)
	g_PlayerData[pl]['blip']=blip
	setElementInterior(blip, INT)
	setElementDimension(blip, DIM)
	--bindKey(pl, "2", "down", shops.rocketcar)
	bindKey( pl, "vehicle_fire", "down", shops.rocketcar)
	setTimer(fadeCamera, 1000, 1, pl, true)
	setTimer(showChat, 1000, 1, pl, true)
end

function onPlayerWasted()
	if getElementData(source,"gamemode")~="manhunt" then return end
	setTimer(spawnThePlayer,1000, 1, source)
	
	local v = getPedOccupiedVehicle(source)
	if v then
		destroyElement(v)
	end
	
	g_PlayerData[source]['active'] = false
end

function sendManhuntMessage(text,r,g,b,m)
	for i,v in pairs(g_PlayerData) do
		exports.npg_textactions:sendMessage(i,text,r,g,b,m)
	end
end

function onVehicleExplode()
	if getElementDimension(source) == DIM then
		setTimer(destroyElement, 2000, 1, source)
		local p = getVehicleOccupant(source, 0)
		if g_PlayerData[p]['active'] then
			g_PlayerData[p]['active'] = false
			local alive = 0
			for i,v in pairs(g_PlayerData) do
				if v.active then
					alive = alive+1
				end
			end
			if alive == 2 then
				sendManhuntMessage(getPlayerName(p)..' came third in Manhunt', 255,20,20)
			elseif alive == 1 then
				sendManhuntMessage(getPlayerName(p)..' came second in Manhunt', 255,20,20)
				for i,v in pairs(g_PlayerData) do
					if v.active then
						sendManhuntMessage(getPlayerName(i)..' came first in Manhunt', 255,20,20)
						g_PlayerData[i]['active'] = false
					end
					ROUND = false
				end
			end
		end
	end
end

local function protectDerby(player)
	if g_PlayerData[player] and not g_PlayerData[player]['active'] and ROUND then
		spawnThePlayer(player)
		outputChatBox("You cannot interfere with a match!", player, 255, 0, 0)
	end
end

addEventHandler("onVehicleStartExit"    , root, onVehicleStartExit)
addEventHandler("onResourceStart"       , root, onResourceStart   )
addEventHandler("onPlayerQuit"          , root, onPlayerQuit      )
addEventHandler("onPlayerWasted"        , root, onPlayerWasted    )
addEventHandler("onPlayerStartManhunt"  , root, onGamemodeEnter   )
addEventHandler("onVehicleExplode"      , root, onVehicleExplode  )
addEventHandler("onColShapeHit"         , PROTECT, protectDerby   )


addEvent('mh:SelectVehicle', true)
addEventHandler('mh:SelectVehicle'      , root, StartRound)

addCommandHandler("kill", function(p) 
	if getElementData(p,"gamemode")=="manhunt" then 
		killPed(p) 
	end
end)

addCommandHandler("setstate", function(pl) 
	g_PlayerData[pl] = g_PlayerData[pl] or {active=false}
	g_PlayerData[pl].active = not g_PlayerData[pl].active
	outputChatBox("Current gameplay status set to "..tostring(g_PlayerData[pl].active), pl)
end)
addCommandHandler("r", redirectPlayer)
