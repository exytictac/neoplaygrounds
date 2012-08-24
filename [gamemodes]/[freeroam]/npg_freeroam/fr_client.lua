CONTROL_MARGIN_RIGHT = 5
LINE_MARGIN = 5
LINE_HEIGHT = 16

g_Root = getRootElement()
g_ResRoot = getResourceRootElement(getThisResource())
g_Me = getLocalPlayer()
server = createServerCallInterface()

function _p(player)
	return getElementData(player or localPlayer, 'gamemode') == 'freeroam'
end

function _pHay() 
	return getElementData(localPlayer,'minigame') and true or false 
end

---------------------------
-- Set skin window
---------------------------
function skinInit()
	setControlNumber(wndSkin, 'skinid', getElementModel(g_Me))
end

function showSkinID(leaf)
	if leaf.id then
		setControlNumber(wndSkin, 'skinid', leaf.id)
	end
end

function applySkin()
	local skinID = getControlNumber(wndSkin, 'skinid')
	if skinID then
		server.setMySkin(skinID)
		fadeCamera(true)
	end
end

wndSkin = {
	'wnd',
	text = 'Set skin',
	width = 250,
	x = -20,
	y = 0.3,
	controls = {
		{
			'lst',
			id='skinlist',
			width=230,
			height=290,
			columns={
				{text='Skin', attr='name'}
			},
			rows={xml='xml/skins.xml', attrs={'id', 'name'}},
			onitemclick=showSkinID,
			onitemdoubleclick=applySkin
		},
		{'txt', id='skinid', text='', width=50},
		{'btn', id='set', onclick=applySkin},
		{'btn', id='close', closeswindow=true}
	},
	oncreate = skinInit
}

function setSkinCommand(cmd, skin)
	if not _p() then return end
	if _pHay() then return end
	skin = skin and tonumber(skin)
	if skin then
		server.setMySkin(skin)
		fadeCamera(true)
		closeWindow(wndSpawnMap)
		closeWindow(wndSetPos)
	end
end
addCommandHandler('setskin', setSkinCommand)
addCommandHandler('ss', setSkinCommand)




---------------------------
--- Set animation window
---------------------------

function applyAnimation(leaf)
	if type(leaf) ~= 'table' then
		leaf = getSelectedGridListLeaf(wndAnim, 'animlist')
		if not leaf then
			return
		end
	end
	server.setPedAnimation(g_Me, leaf.parent.name, leaf.name, true, true)
end

function stopAnimation()
	server.setPedAnimation(g_Me, false)
end

wndAnim = {
	'wnd',
	text = 'Set animation',
	width = 250,
	x = -20,
	y = 0.3,
	controls = {
		{
			'lst',
			id='animlist',
			width=230,
			height=290,
			columns={
				{text='Animation', attr='name'}
			},
			rows={xml='xml/animations.xml', attrs={'name'}},
			expandlastlevel=false,
			onitemdoubleclick=applyAnimation
		},
		{'btn', id='set', onclick=applyAnimation},
		{'btn', id='stop', onclick=stopAnimation},
		{'btn', id='close', closeswindow=true}
	}
}

addCommandHandler('anim',
	function(command, lib, name)
		if not _p() then return end
		if _pHay() then return end
		server.setPedAnimation(g_Me, lib, name, true, true)
	end
)



---------------------------
-- Fighting style
---------------------------

addCommandHandler('setstyle',
	function(cmd, style)
		if not _p() then return end
		if _pHay() then return end
		style = style and tonumber(style)
		if style then
			server.setPedFightingStyle(g_Me, style)
		end
	end
)

---------------------------
-- Clothes window
---------------------------
function clothesInit()
	if getElementModel(g_Me) ~= 0 then
		errMsg('You must have the CJ skin set in order to apply clothes.')
		closeWindow(wndClothes)
		return
	end
	if not g_Clothes then
		triggerServerEvent('onClothesInit', g_Me)
	end
end

addEvent('onClientClothesInit', true)
addEventHandler('onClientClothesInit', g_Root,
	function(clothes)
		g_Clothes = clothes.allClothes
		for i,typeGroup in ipairs(g_Clothes) do
			for j,cloth in ipairs(typeGroup.children) do
				if not cloth.name then
					cloth.name = cloth.model .. ' - ' .. cloth.texture
				end
				cloth.wearing =
					clothes.playerClothes[typeGroup.type] and
					clothes.playerClothes[typeGroup.type].texture == cloth.texture and
					clothes.playerClothes[typeGroup.type].model == cloth.model
					or false
			end
			table.sort(typeGroup.children, function(a, b) return a.name < b.name end)
		end
		bindGridListToTable(wndClothes, 'clothes', g_Clothes, false)
	end
)

function clothListClick(cloth)
	setControlText(wndClothes, 'addremove', cloth.wearing and 'remove' or 'add')
end

function applyClothes(cloth)
	if not cloth then
		cloth = getSelectedGridListLeaf(wndClothes, 'clothes')
		if not cloth then
			return
		end
	end
	if cloth.wearing then
		cloth.wearing = false
		setControlText(wndClothes, 'addremove', 'add')
		server.removePlayerClothes(g_Me, cloth.parent.type)
	else
		local prevClothIndex = table.find(cloth.siblings, 'wearing', true)
		if prevClothIndex then
			cloth.siblings[prevClothIndex].wearing = false
		end
		cloth.wearing = true
		setControlText(wndClothes, 'addremove', 'remove')
		server.addPedClothes(g_Me, cloth.texture, cloth.model, cloth.parent.type)
	end
end

wndClothes = {
	'wnd',
	text = 'Clothes',
	x = -20,
	y = 0.3,
	width = 350,
	controls = {
		{
			'lst',
			id='clothes',
			width=330,
			height=390,
			columns={
				{text='Clothes', attr='name', width=0.6},
				{text='Wearing', attr='wearing', enablemodify=true, width=0.3}
			},
			rows={
				{name='Retrieving clothes list...'}
			},
			onitemclick=clothListClick,
			onitemdoubleclick=applyClothes
		},
		{'br'},
		{'btn', text='add', id='addremove', width=60, onclick=applyClothes},
		{'btn', id='close', closeswindow=true}
	},
	oncreate = clothesInit
}

function addClothesCommand(cmd, type, model, texture)
	if not _p() then return end
	if _pHay() then return end
	type = type and tonumber(type)
	if type and model and texture then
		server.addPedClothes(g_Me, texture, model, type)
	end
end
addCommandHandler('addclothes', addClothesCommand)
addCommandHandler('ac', addClothesCommand)

function removeClothesCommand(cmd, type)
	if not _p() then return end
	if _pHay() then return end
	type = type and tonumber(type)
	if type then
		server.removePlayerClothes(g_Me, type)
	end
end
addCommandHandler('removeclothes', removeClothesCommand)
addCommandHandler('rc', removeClothesCommand)

---------------------------
-- Warp to player window
---------------------------

function warpInit()
	local players = table.map(getElementsByType('player'), function(p) return { name = getPlayerName(p) } end)
	table.sort(players, function(a, b) return a.name < b.name end)
	bindGridListToTable(wndWarp, 'playerlist', players, true)
end

function warpTo(leaf)
	if not leaf then
		leaf = getSelectedGridListLeaf(wndWarp, 'playerlist')
		if not leaf then
			return
		end
	end
	local player = getPlayerFromNick(leaf.name)
	if player then
		server.warpMe(player)
	end
	closeWindow(wndWarp)
end

wndWarp = {
	'wnd',
	text = 'Warp to player',
	width = 300,
	controls = {
		{
			'lst',
			id='playerlist',
			width=280,
			height=330,
			columns={
				{text='Player', attr='name'}
			},
			onitemdoubleclick=warpTo
		},
		{'btn', id='warp', onclick=warpTo},
		{'btn', id='cancel', closeswindow=true}
	},
	oncreate = warpInit
}

function warpToCommand(cmd, player)
	if not _p() then return end
	if _pHay() then return end
	if player then
		player = getPlayerFromNick(player)
		if player then
			server.warpMe(player)
		end
	else
		createWindow(wndWarp)
		showCursor(true)
	end
end
addCommandHandler("wt", warpToCommand)
addCommandHandler("warpto", warpToCommand)
---------------------------
-- Stats window
---------------------------


-- Created: 30/ 4/2012 18:33
local wndStat = {
	info = {
		Fat = 21,
		Muscle = 23,
		Health = 24
	},
	current = {}
}

wndStat.wnd = guiCreateWindow(0.3258, 0.3691, 0.3398, 0.1289, "Change your statistics", true)
guiWindowSetSizable(wndStat.wnd, false)

do
	local placeholder = guiCreateLabel(10, 30, 41, 19,"Fat:", false, wndStat.wnd )
	guiLabelSetVerticalAlign(placeholder, "center")
	guiLabelSetHorizontalAlign(placeholder, "right", false)
	
	placeholder = guiCreateLabel(11, 51, 40, 19, "Muscle:", false, wndStat.wnd)
	guiLabelSetVerticalAlign(placeholder, "center")
	guiLabelSetHorizontalAlign(placeholder, "right", false)
	
	
	placeholder = guiCreateLabel(6, 75, 46, 19, "Max HP:", false, wndStat.wnd)
	guiLabelSetVerticalAlign(placeholder, "center")
	guiLabelSetHorizontalAlign(placeholder, "right", false)
end

wndStat.progFat = guiCreateProgressBar(52, 26, 321, 24, false, wndStat.wnd)
wndStat.editFat = guiCreateEdit(377, 26, 49, 22, "0%", false, wndStat.wnd)

wndStat.progMuscle = guiCreateProgressBar(52,49,321,24,false, wndStat.wnd)
wndStat.editMuscle = guiCreateEdit(377,51,49,22,"0%",false, wndStat.wnd)

wndStat.progHealth = guiCreateProgressBar(52,71,321,24,false, wndStat.wnd)
wndStat.editHealth = guiCreateEdit(377,75,49,22,"0%",false, wndStat.wnd)

wndStat.cancel = guiCreateButton(9,104,212,20,"Cancel changes",false, wndStat.wnd)
wndStat.save = guiCreateButton(223,104,203,20,"Save changes",false, wndStat.wnd)

wndStat.open = function()
	if guiGetVisible( wndStat.wnd ) then
		wndStat.saveFN(true)
		guiSetVisible( wndStat.wnd, false)
		return
	end
	
	guiSetVisible( wndStat.wnd, true )
	for i,v in pairs( wndStat.info ) do
		wndStat.current[i] = getPedStat(localPlayer, v)
		local percent = math.floor( (wndStat.current[i]/1000)*100 )
		guiProgressBarSetProgress( wndStat['prog'..i], percent )
		guiSetText( wndStat['edit'..i], percent.."%")
	end	
end

wndStat.update = function()
	local method
	if source == wndStat.progFat then
		method = "Fat"
	elseif source == wndstat.progMuscle then	
		method = "Muscle"
	elseif source == wndStat.progHealth then
		method = 'Health'
	end
	
	guiProgressBarSetProgress( wndStat['prog'..method], progress )
	guiSetText( wndStat['edit'..method], progress..'%')
	setPedStat( localPlayer, wndStat.info[method], math.floor( (progress/100)*1000 ) )
end

wndStat.saveFN = function(bool)
	if bool~=true then
		wndStat.open()
	end
end

guiSetVisible( wndStat.wnd, false )
---------------------------
-- Jetpack toggle
---------------------------
function toggleJetPack()
	if not _p() then return end
	if _pHay() then return end
	if not doesPedHaveJetPack(g_Me) then
		server.givePedJetPack(g_Me)
		guiCheckBoxSetSelected(getControl(wndMain, 'jetpack'), true)
	else
		server.removePedJetPack(g_Me)
		guiCheckBoxSetSelected(getControl(wndMain, 'jetpack'), false)
	end
end
addCommandHandler("jp", toggleJetPack)
addCommandHandler("jetpack", toggleJetPack)
bindKey('j', 'down','jp')


---------------------------
-- Fall off bike toggle
---------------------------
function toggleFallOffBike()
	setPedCanBeKnockedOffBike(g_Me, guiCheckBoxGetSelected(getControl(wndMain, 'falloff')))
end

---------------------------
-- Set position window
---------------------------
do
	local screenWidth, screenHeight = guiGetScreenSize()
	if screenHeight < 700 then
		g_MapSide = 450
	else
		g_MapSide = 700
	end
end

function setPosInit()
	local x, y, z = getElementPosition(g_Me)
	setControlNumbers(wndSetPos, { x = x, y = y, z = z })
	
	addEventHandler('onClientRender', g_Root, updatePlayerBlips)
end

function fillInPosition(relX, relY, btn)
	if (btn == 'right') then
		closeWindow (wndSetPos)
		return
	end

	local x = relX*6000 - 3000
	local y = 3000 - relY*6000
	local hit, hitX, hitY, hitZ
	hit, hitX, hitY, hitZ = processLineOfSight(x, y, 3000, x, y, -3000)
	setControlNumbers(wndSetPos, { x = x, y = y, z = hitZ or 0 })
end

function setPosClick()
	setPlayerPosition(getControlNumbers(wndSetPos, {'x', 'y', 'z'}))
	closeWindow(wndSetPos)
end

function setPlayerPosition(x, y, z)
	--if not _p() then return end
	local elem = getPedOccupiedVehicle(g_Me)
	local distanceToGround
	local isVehicle
	if elem then
		if getPlayerOccupiedSeat(g_Me) ~= 0 then
			errMsg('Only the driver of the vehicle can set its position.')
			return
		end
		distanceToGround = getElementDistanceFromCentreOfMassToBaseOfModel(elem) + 3
		isVehicle = true
	else
		elem = g_Me
		distanceToGround = 0.4
		isVehicle = false
	end
	local hit, hitX, hitY, hitZ = processLineOfSight(x, y, 3000, x, y, -3000)
	if not hit then
		if isVehicle then
			server.fadeVehiclePassengersCamera(false)
		else
			fadeCamera(false)
		end
		setTimer(setCameraMatrix, 1000, 1, x, y, z)
		local grav = getGravity()
		setGravity(0.001)
		g_TeleportTimer = setTimer(
			function()
				local hit, groundX, groundY, groundZ = processLineOfSight(x, y, 3000, x, y, -3000)
				if hit then
					local waterZ = getWaterLevel(x, y, 100)
					z = (waterZ and math.max(groundZ, waterZ) or groundZ) + distanceToGround
					if isPlayerDead(g_Me) then
						server.spawnMe(x, y, z)
					else
						setElementPosition(elem, x, y, z)
					end
					setCameraPlayerMode()
					setGravity(grav)
					if isVehicle then
						server.fadeVehiclePassengersCamera(true)
					else
						fadeCamera(true)
					end
					killTimer(g_TeleportTimer)
					g_TeleportTimer = nil
				end
			end,
			500,
			0
		)
	else
		if isPlayerDead(g_Me) then
			server.spawnMe(x, y, z + distanceToGround)
		else
			setElementPosition(elem, x, y, z + distanceToGround)
			if isVehicle then
				setTimer(setElementVelocity, 100, 1, elem, 0, 0, 0)
				setTimer(setVehicleTurnVelocity, 100, 1, elem, 0, 0, 0)
			end
		end
	end
end

function updatePlayerBlips()
	if not g_PlayerData then
		return
	end
	local wnd = isWindowOpen(wndSpawnMap) and wndSpawnMap or wndSetPos
	local mapControl = getControl(wnd, 'map')
	for elem,player in pairs(g_PlayerData) do
		if not player.gui.mapBlip then
			player.gui.mapBlip = guiCreateStaticImage(0, 0, 9, 9, elem == g_Me and 'img/localplayerblip.png' or 'img/playerblip.png', false, mapControl)
			player.gui.mapLabelShadow = guiCreateLabel(0, 0, 100, 14, player.name, false, mapControl)
			local labelWidth = guiLabelGetTextExtent(player.gui.mapLabelShadow)
			guiSetSize(player.gui.mapLabelShadow, labelWidth, 14, false)
			guiSetFont(player.gui.mapLabelShadow, 'default-bold-small')
			guiLabelSetColor(player.gui.mapLabelShadow, 255, 255, 255)
			player.gui.mapLabel = guiCreateLabel(0, 0, labelWidth + 10 , 14, player.name, false, mapControl)
			guiSetFont(player.gui.mapLabel, 'default-bold-small')
			guiLabelSetColor(player.gui.mapLabel, 0, 0, 0)
			for i,name in ipairs({'mapBlip', 'mapLabelShadow'}) do
				addEventHandler('onClientGUIDoubleClick', player.gui[name],
					function()
						server.warpMe(elem)
						closeWindow(wnd)
					end,
					false
				)
			end
		end
		local x, y = getElementPosition(elem)
		x = math.floor((x + 3000) * g_MapSide / 6000) - 4
		y = math.floor((3000 - y) * g_MapSide / 6000) - 4
		guiSetPosition(player.gui.mapBlip, x, y, false)
		guiSetPosition(player.gui.mapLabelShadow, x + 14, y - 4, false)
		guiSetPosition(player.gui.mapLabel, x + 13, y - 5, false)
	end
end

addEventHandler('onClientPlayerChangeNick', g_Root,
	function(oldNick, newNick)
		if (not g_PlayerData) then return end
		local player = g_PlayerData[source]
		player.name = newNick
		if player.gui.mapLabel then
			guiSetText(player.gui.mapLabelShadow, newNick)
			guiSetText(player.gui.mapLabel, newNick)
			local labelWidth = guiLabelGetTextExtent(player.gui.mapLabelShadow)
			guiSetSize(player.gui.mapLabelShadow, labelWidth, 14, false)
			guiSetSize(player.gui.mapLabel, labelWidth, 14, false)
		end
	end
)

function closePositionWindow()
	removeEventHandler('onClientRender', g_Root, updatePlayerBlips)
end

wndSetPos = {
	'wnd',
	text = 'Set position',
	width = g_MapSide + 20,
	controls = {
		{'img', id='map', src='img/map.png', width=g_MapSide, height=g_MapSide, onclick=fillInPosition, ondoubleclick=setPosClick},
		{'txt', id='x', text='', width=60},
		{'txt', id='y', text='', width=60},
		{'txt', id='z', text='', width=60},
		{'btn', id='ok', onclick=setPosClick},
		{'btn', id='cancel', closeswindow=true},
		{'lbl', text='Right click on map to close'}
	},
	oncreate = setPosInit,
	onclose = closePositionWindow
}

function getPosCommand(cmd, playerName)
	--if not _p() then return end
	local player, sentenceStart
	
	if playerName then
		player = getPlayerFromNick(playerName)
		if not player then
			errMsg('There is no player named "' .. playerName .. '".')
			return
		end
		playerName = getPlayerName(player)		-- make sure case is correct
		sentenceStart = playerName .. ' is '
	else
		player = g_Me
		sentenceStart = 'You are '
	end
	
	local px, py, pz = getElementPosition(player)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle then
		outputChatBox(sentenceStart .. 'in a ' .. getVehicleName(vehicle), 0, 255, 0)
	else
		outputChatBox(sentenceStart .. 'on foot', 0, 255, 0)
	end
	outputChatBox(sentenceStart .. 'at (' .. string.format("%.5f", px) .. ' ' .. string.format("%.5f", py) .. ' ' .. string.format("%.5f", pz) .. ')', 0, 255, 0)
end
addCommandHandler("gp", getPosCommand)

function setPosCommand(cmd, x, y, z, r)
	if not _p() then return end
	if _pHay() then return end
	local px, py, pz = getElementPosition(g_Me)
	local pr = getPedRotation(g_Me)
	if not x or x == '-' or not tonumber(x) then
		x = px
	end
	if not y or y == '-' or not tonumber(y) then
		y = py
	end
	if not z or z == '-' or not tonumber(z) then
		z = pz
	end
	setPlayerPosition(tonumber(x), tonumber(y), tonumber(z))
	if (isPedInVehicle(g_Me)) then
		local vehicle = getPedOccupiedVehicle(g_Me)
		if (vehicle and isElement(vehicle) and getVehicleController(vehicle) == g_Me) then
			setElementRotation(vehicle, 0, 0, tonumber(r) or pr)
		end
	else
		setPedRotation(g_Me, tonumber(r) or pr)
	end
end
addCommandHandler("sp", setPosCommand)

---------------------------
-- Spawn map window
---------------------------
function warpMapInit()
	addEventHandler('onClientRender', g_Root, updatePlayerBlips)
end

function showMap ( )
	toggleWindow(wndSpawnMap)
	Animation.createAndPlay(wndSpawnMap.element, Animation.presets.guiFadeIn(750))
end

function spawnMapDoubleClick(relX, relY)
	if Animation.playingAnimationsExist() then return end
	setPlayerPosition(relX*6000 - 3000, 3000 - relY*6000, 0)
	setTimer(guiSetVisible,750,1,wndSpawnMap.element,false)
	Animation.createAndPlay(wndSpawnMap.element, Animation.presets.guiFadeOut(750))
	setTimer ( setElementDimension, 500, 1, g_Me, 1 )
	setTimer(showPlayerHudComponent, 3000, 1, "all", true)
	closeSpawnMap()
	closeMap ( )
	if getElementInterior ( g_Me ) ~= 0 then
		setElementInterior ( g_Me, 0 )
	end
	showChat ( true )
	if isCursorShowing ( g_Me ) then
		showCursor( false )
		guiSetInputEnabled ( false )
	end
end



function closeSpawnMap()
	removeEventHandler('onClientRender', g_Root, updatePlayerBlips)
	for elem,data in pairs(g_PlayerData) do
		for i,name in ipairs({'mapBlip', 'mapLabelShadow', 'mapLabel'}) do
			if data.gui[name] then
				destroyElement(data.gui[name])
				data.gui[name] = nil
			end
		end
	end
end

wndSpawnMap = {
	'wnd',
	text = 'Select spawn position',
	width = g_MapSide + 20,
	controls = {
		{'img', id='map', src='img/map.png', width=g_MapSide, height=g_MapSide, ondoubleclick=spawnMapDoubleClick},
		{'lbl', text='Double click a location on the map to spawn.', width=g_MapSide-60, align='center'}
		--,{'btn', id='close', closeswindow=true}
	},
	oncreate = warpMapInit,
	onclose = closeSpawnMap
}

---------------------------
-- Interior window
---------------------------

function setInterior(leaf)
	server.setElementInterior(g_Me, leaf.world)
	local vehicle = getPedOccupiedVehicle(g_Me)
	if vehicle then
		server.setElementInterior(vehicle, leaf.world)
		for i=0,getVehicleMaxPassengers(vehicle) do
			local player = getVehicleOccupant(vehicle, i)
			if player and player ~= g_Me then
				server.setElementInterior(player, leaf.world)
				server.setCameraInterior(player, leaf.world)
			end
		end
	end
	setCameraInterior(leaf.world)
	setPlayerPosition(leaf.posX, leaf.posY, leaf.posZ + 1)
	closeWindow(wndSetInterior)
end

wndSetInterior = {
	'wnd',
	text = 'Set interior',
	width = 250,
	controls = {
		{
			'lst',
			id='interiors',
			width=230,
			height=300,
			columns={
				{text='Interior', attr='name'}
			},
			rows={xml='xml/interiors.xml', attrs={'name', 'posX', 'posY', 'posZ', 'world'}},
			onitemdoubleclick=setInterior
		},
		{'btn', id='close', closeswindow=true}
	}
}

---------------------------
-- Create vehicle window
---------------------------
function createSelectedVehicle(leaf)
	if not leaf then
		leaf = getSelectedGridListLeaf(wndCreateVehicle, 'vehicles')
		if not leaf then
			return
		end
	end
	server.giveMeVehicles(leaf.id)
end

wndCreateVehicle = {
	'wnd',
	text = 'Create vehicle',
	width = 300,
	controls = {
		{
			'lst',
			id='vehicles',
			width=280,
			height=340,
			columns={
				{text='Vehicle', attr='name'}
			},
			rows={xml='xml/vehicles.xml', attrs={'id', 'name'}},
			onitemdoubleclick=createSelectedVehicle
		},
		{'btn', id='create', onclick=createSelectedVehicle},
		{'btn', id='close', closeswindow=true}
	}
}

function createVehicleCommand(cmd, ...)
	if not _p() then return end
	if _pHay() then return end
	local vehID
	local vehiclesToCreate = {}
	local args = { ... }
	for i,v in ipairs(args) do
		vehID = tonumber(v)
		if not vehID then
			vehID = getVehicleModelFromName(v)
		end
		if vehID then
			table.insert(vehiclesToCreate, math.floor(vehID))
		end
	end
	server.giveMeVehicles(vehiclesToCreate)
end
addCommandHandler("cv", createVehicleCommand)

---------------------------
-- Repair vehicle
---------------------------
function repairVehicle()
	if not _p() then return end
	local vehicle = getPedOccupiedVehicle(g_Me)
	if vehicle then
		server.fixVehicle(vehicle)
	end
end
addCommandHandler("rp", repairVehicle)
addCommandHandler("repair", repairVehicle)

---------------------------
-- Flip vehicle
---------------------------
function flipVehicle()
	local vehicle = getPedOccupiedVehicle(g_Me)
	if vehicle then
		local rX, rY, rZ = getElementRotation(vehicle)
		server['set' .. 'VehicleRotation'](vehicle, 0, 0, (rX > 90 and rX < 270) and (rZ + 180) or rZ)
	end
end
addCommandHandler("flip", flipVehicle)



---------------------------
-- Vehicle upgrades
---------------------------
function upgradesInit()
	local vehicle = getPedOccupiedVehicle(g_Me)
	if not vehicle then
		errMsg('Please enter a vehicle to change the upgrades of.')
		closeWindow(wndUpgrades)
		return
	end
	local installedUpgrades = getVehicleUpgrades(vehicle)
	local compatibleUpgrades = {}
	local slotName, group
	for i,upgrade in ipairs(getVehicleCompatibleUpgrades(vehicle)) do
		slotName = getVehicleUpgradeSlotName(upgrade)
		group = table.find(compatibleUpgrades, 'name', slotName)
		if not group then
			group = { 'group', name = slotName, children = {} }
			table.insert(compatibleUpgrades, group)
		else
			group = compatibleUpgrades[group]
		end
		table.insert(group.children, { id = upgrade, installed = table.find(installedUpgrades, upgrade) ~= false })
	end
	table.sort(compatibleUpgrades, function(a, b) return a.name < b.name end)
	bindGridListToTable(wndUpgrades, 'upgradelist', compatibleUpgrades, true)
end

function selectUpgrade(leaf)
	setControlText(wndUpgrades, 'addremove', leaf.installed and 'remove' or 'add')
end

function addRemoveUpgrade(selUpgrade)
	-- Add or remove selected upgrade
	local vehicle = getPedOccupiedVehicle(g_Me)
	if not vehicle then
		return
	end
	
	if not selUpgrade then
		selUpgrade = getSelectedGridListLeaf(wndUpgrades, 'upgradelist')
		if not selUpgrade then
			return
		end
	end
	
	if selUpgrade.installed then
		-- remove upgrade
		selUpgrade.installed = false
		setControlText(wndUpgrades, 'addremove', 'add')
		server.removeVehicleUpgrade(vehicle, selUpgrade.id)
	else
		-- add upgrade
		local prevUpgradeIndex = table.find(selUpgrade.siblings, 'installed', true)
		if prevUpgradeIndex then
			selUpgrade.siblings[prevUpgradeIndex].installed = false
		end
		selUpgrade.installed = true
		setControlText(wndUpgrades, 'addremove', 'remove')
		server.addVehicleUpgrade(vehicle, selUpgrade.id)
	end
end

wndUpgrades = {
	'wnd',
	text = 'Vehicle upgrades',
	width = 300,
	x = -20,
	y = 0.3,
	controls = {
		{
			'lst',
			id='upgradelist',
			width=280,
			height=340,
			columns={
				{text='Upgrade', attr='id', width=0.6},
				{text='Installed', attr='installed', width=0.3, enablemodify=true}
			},
			onitemclick=selectUpgrade,
			onitemdoubleclick=addRemoveUpgrade
		},
		{'btn', id='addremove', text='add', width=60, onclick=addRemoveUpgrade},
		{'btn', id='ok', closeswindow=true}
	},
	oncreate = upgradesInit
}

function addUpgradeCommand(cmd, upgrade)
	if not _p() then return end
	if _pHay() then return end
	local vehicle = getPedOccupiedVehicle(g_Me)
	if vehicle and upgrade then
		server.addVehicleUpgrade(vehicle, tonumber(upgrade) or 0)
	end
end
addCommandHandler("au", addUpgradeCommand)

function removeUpgradeCommand(cmd, upgrade)
	if not _p() then return end
	if _pHay() then return end
	local vehicle = getPedOccupiedVehicle(g_Me)
	if vehicle and upgrade then
		server.removeVehicleUpgrade(vehicle, tonumber(upgrade) or 0)
	end
end
addCommandHandler("ru", removeUpgradeCommand)


---------------------------
-- Toggle lights
---------------------------
function forceLightsOn()
	local vehicle = getPedOccupiedVehicle(g_Me)
	if not vehicle then
		return
	end
	if guiCheckBoxGetSelected(getControl(wndMain, 'lightson')) then
		server.setVehicleOverrideLights(vehicle, 2)
		guiCheckBoxSetSelected(getControl(wndMain, 'lightsoff'), false)
	else
		server.setVehicleOverrideLights(vehicle, 0)
	end
end

function forceLightsOff()
	local vehicle = getPedOccupiedVehicle(g_Me)
	if not vehicle then
		return
	end
	if guiCheckBoxGetSelected(getControl(wndMain, 'lightsoff')) then
		server.setVehicleOverrideLights(vehicle, 1)
		guiCheckBoxSetSelected(getControl(wndMain, 'lightson'), false)
	else
		server.setVehicleOverrideLights(vehicle, 0)
	end
end


---------------------------
-- Color
---------------------------

function setColorCommand(cmd, ...)
	if not _p() then return end
	if _pHay() then return end
	local vehicle = getPedOccupiedVehicle(g_Me)
	if not vehicle then
		return
	end
	local colors = { getVehicleColor(vehicle) }
	local args = { ... }
	for i=1,6 do
		colors[i] = args[i] and tonumber(args[i]) or colors[i]
	end
	server.setVehicleColor(vehicle, unpack(colors))
end
addCommandHandler("sc", setColorCommand)


function openColorPicker()
	editingVehicle = getPedOccupiedVehicle(localPlayer)
	if (editingVehicle) then
		colorPicker.openSelect(colors)
	end
end

function closedColorPicker()
	local r1, g1, b1, r2, g2, b2 = getVehicleColor(editingVehicle, true)
	server.setVehicleColor(editingVehicle, r1, g1, b1, r2, g2, b2)
	local r, g, b = getVehicleHeadLightColor(editingVehicle)
	server.setVehicleHeadLightColor(editingVehicle, r, g, b)
	editingVehicle = nil
end

function updateColor()
	if (not colorPicker.isSelectOpen) then return end
	local r, g, b = colorPicker.updateTempColors()
	if (editingVehicle and isElement(editingVehicle)) then
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(editingVehicle, true)
		if (guiCheckBoxGetSelected(checkColor1)) then
			r1, g1, b1 = r, g, b
		end
		if (guiCheckBoxGetSelected(checkColor2)) then
			r2, g2, b2 = r, g, b
		end
		if (guiCheckBoxGetSelected(checkColor3)) then
			setVehicleHeadLightColor(editingVehicle, r, g, b)
		end
		setVehicleColor(editingVehicle, r1, g1, b1, r2, g2, b2)
	end
end
addEventHandler("onClientRender", root, updateColor)

---------------------------
-- Paintjob
---------------------------

function paintjobInit()
	local vehicle = getPedOccupiedVehicle(g_Me)
	if not vehicle then
		errMsg('You need to be in a car to change its paintjob.')
		closeWindow(wndPaintjob)
		return
	end
	local paint = getVehiclePaintjob(vehicle)
	if paint then
		guiGridListSetSelectedItem(getControl(wndPaintjob, 'paintjoblist'), paint+1)
	end
end

function applyPaintjob(paint)
	server.setVehiclePaintjob(getPedOccupiedVehicle(g_Me), paint.id)
end

wndPaintjob = {
	'wnd',
	text = 'Car paintjob',
	width = 220,
	x = -20,
	y = 0.3,
	controls = {
		{
			'lst',
			id='paintjoblist',
			width=200,
			height=130,
			columns={
				{text='Paintjob ID', attr='id'}
			},
			rows={
				{id=0},
				{id=1},
				{id=2},
				{id=3}
			},
			onitemclick=applyPaintjob,
			ondoubleclick=function() closeWindow(wndPaintjob) end
		},
		{'btn', id='close', closeswindow=true},
	},
	oncreate = paintjobInit
}

function setPaintjobCommand(cmd, paint)
	if not _p() then return end
	if _pHay() then return end
	local vehicle = getPedOccupiedVehicle(g_Me)
	paint = paint and tonumber(paint)
	if not paint or not vehicle then
		return
	end
	server.setVehiclePaintjob(vehicle, paint)
end


---------------------------
-- Main window
---------------------------

function updateGUI(updateVehicle)
	-- update position
	local x, y, z = getElementPosition(g_Me)
	setControlNumbers(wndMain, {xpos=math.ceil(x), ypos=math.ceil(y), zpos=math.ceil(z)})
	
	-- update jetpack toggle
	guiCheckBoxSetSelected( getControl(wndMain, 'jetpack'), doesPedHaveJetPack(g_Me) )
	
	if updateVehicle then
		-- update current vehicle
		local vehicle = getPedOccupiedVehicle(g_Me)
		if vehicle then
			setControlText(wndMain, 'curvehicle', getVehicleName(vehicle))
		else
			setControlText(wndMain, 'curvehicle', 'On foot')
		end
	end
end

function mainWndShow()
	if not getPedOccupiedVehicle(g_Me) then
		hideControls(wndMain, 'repair', 'flip', 'upgrades', 'color', 'paintjob', 'lightson', 'lightsoff')
	end
	updateTimer = updateTimer or setTimer(updateGUI, 2000, 0)
	updateGUI(true)
end

function mainWndClose()
	killTimer(updateTimer)
	updateTimer = nil
	colorPicker.closeSelect()
end

function onEnterVehicle(vehicle)
	setControlText(wndMain, 'curvehicle', getVehicleName(vehicle))
	showControls(wndMain, 'repair', 'flip', 'upgrades', 'color', 'paintjob', 'lightson', 'lightsoff')
	guiCheckBoxSetSelected(getControl(wndMain, 'lightson'), getVehicleOverrideLights(vehicle) == 2)
	guiCheckBoxSetSelected(getControl(wndMain, 'lightsoff'), getVehicleOverrideLights(vehicle) == 1)
end

function onExitVehicle(vehicle)
	setControlText(wndMain, 'curvehicle', 'On foot')
	hideControls(wndMain, 'repair', 'flip', 'upgrades', 'color', 'paintjob', 'lightson', 'lightsoff')
	closeWindow(wndUpgrades)
	closeWindow(wndColor)
end

function killLocalPlayer()
	server.killPed(g_Me)
end


function alphaCommand(command, alpha)
	if not _p() then return end
	if _pHay() then return end
	alpha = alpha and tonumber(alpha)
	if alpha then
		server.setElementAlpha(g_Me, alpha)
	end
end
addCommandHandler('kill', killLocalPlayer)



wndMain = {
	'wnd',
	text = 'Freeroam Panel',
	x = 5,
	y = 150,
	width = 280,
	controls = {
		
		{'br'},
		{'btn', id='skin', window=wndSkin},
		{'btn', id='anim', window=wndAnim},
		{'btn', id='clothes', window=wndClothes},
		{'btn', id='warp', window=wndWarp},
		{'btn', id='stats', onclick=wndStat.open},
		{'br'},
		{'chk', id='jetpack', onclick=toggleJetPack},
		{'chk', id='falloff', text='fall off bike', onclick=toggleFallOffBike},
		{'br'},
		
		{'lbl', text='Pos:'},
		{'lbl', id='xpos', text='x', width=45},
		{'lbl', id='ypos', text='y', width=45},
		{'lbl', id='zpos', text='z', width=45},
		{'btn', id='setpos', text='map', window=wndSetPos},
		{'btn', id='setinterior', text='int', window=wndSetInterior},
		{'br'},
		{'br'},
		
		{'br'},
		{'lbl', text='Vehicles'},
		{'br'},
		{'btn', id='createvehicle', window=wndCreateVehicle, text='create'},
		{'btn', id='repair', onclick=repairVehicle},
		{'btn', id='flip', onclick=flipVehicle},
		{'btn', id='upgrades', window=wndUpgrades},
		{'btn', id='color', onclick=openColorPicker},
		{'btn', id='paintjob', window=wndPaintjob},
		{'br'},
		{'chk', id='lightson', text='Lights on', onclick=forceLightsOn},
		{'chk', id='lightsoff', text='Lights off', onclick=forceLightsOff},
		{'br'},
		{'br'},
	},
	oncreate = mainWndShow,
	onclose = mainWndClose
}

function closeMap()
	if isWindowOpen ( wndSpawnMap ) then
		closeWindow ( wndSpawnMap )
	end
end


function toggleFRWindow()
	if not _p() then return end
	if _pHay() then return end
	if isWindowOpen(wndMain) then
		showCursor(false)
		hideAllWindows()
		colorPicker.closeSelect()
	else
		showCursor(true)
		showAllWindows()
		closeMap()
	end
end
addCommandHandler("fr", toggleFRWindow)
addCommandHandler("freeroam", toggleFRWindow)


function errMsg(msg)
	outputChatBox(msg, 255, 0, 0)
end

addEventHandler('onClientResourceStart', resourceRoot,
	function()
		fadeCamera(true)
		setTimer(getPlayers, 1000, 1)
		createWindow(wndMain)
		hideAllWindows()
		triggerServerEvent('onLoadedAtClient', g_ResRoot, g_Me)
		bindKey ( 'f1', 'down', toggleFRWindow )
	end
)

function loadFreeroam()
		showMap ( )
		showCursor(true)
end

addEvent ( "onHayQuit", true )
addEventHandler ( "onHayQuit", root, function ( )
		setTimer(getPlayers, 1000, 1)
		createWindow(wndMain)
		hideAllWindows()
		triggerServerEvent('onLoadedAtClient', g_ResRoot, g_Me)
		bindKey ( 'f1', 'down', toggleFRWindow )
	end
)

function getPlayers()
	g_PlayerData = {}
	table.each(getElementsByType('player'), joinHandler)
end

function joinHandler(player)
	if (not g_PlayerData) then return end
	g_PlayerData[player or source] = { name = getPlayerName(player or source), gui = {} }
end
addEventHandler('onClientPlayerJoin', g_Root, joinHandler)

addEventHandler('onClientPlayerQuit', g_Root,
	function()
		if (not g_PlayerData) then return end
		table.each(g_PlayerData[source].gui, destroyElement)
		g_PlayerData[source] = nil
	end
)

addEventHandler('onClientPlayerWasted', g_Me,
	function()
		onExitVehicle(g_Me)
	end
)

addEventHandler('onClientPlayerVehicleEnter', g_Me, onEnterVehicle)
addEventHandler('onClientPlayerVehicleExit', g_Me, onExitVehicle)

addEventHandler('onClientResourceStop', g_ResRoot,
	function()
		showCursor(false)
		setPedAnimation(g_Me, false)
	end
)


