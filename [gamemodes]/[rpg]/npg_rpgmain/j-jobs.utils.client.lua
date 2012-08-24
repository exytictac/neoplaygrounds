--[[
	RPG Jobs v2.0.1 [utils.client]
	
	Made By: JR10
	
	Copyright (c) 2011
]]

local screenX , screenY = guiGetScreenSize ( )
local curTeamName

addEventHandler ( "onClientRender" , root ,
	function ( )
		for index , teamChar in ipairs ( getElementsByType ( "ped" , resourceRoot ) ) do
			local teamName = getElementData ( teamChar , "teamName" )
			local charName = getElementData ( teamChar , "charName" )
			local posX , posY , posZ = getElementPosition ( teamChar )
			local camX , camY , camZ = getCameraMatrix ( )
			local RGB = getElementData ( teamChar , "RGB" )
			local distance = getDistanceBetweenPoints3D ( camX , camY , camZ , posX , posY , posZ )
			if distance < 12 then
				local sX , sY = getScreenFromWorldPosition ( posX , posY , posZ + 1.25 )
				if sX then
					dxDrawFramedText ( charName , sX , sY , sX , sY , tocolor ( RGB [ 1 ] , RGB [ 2 ] , RGB [ 3 ] , 255 ) , ( screenX / 1440 ) * 2 , "default-bold" , "center" , "center" , false , false , false )
				end
				sX , sY = getScreenFromWorldPosition ( posX , posY , posZ + 1 )
				if sX then
					dxDrawFramedText ( teamName , sX , sY , sX , sY , tocolor ( RGB [ 1 ] , RGB [ 2 ] , RGB [ 3 ] , 255 ) , ( screenX / 1440 ) * 2 , "default-bold" , "center" , "center" , false , false , false )
				end
			end
		end
	end
)

function dxDrawFramedText ( message , left , top , width , height , color , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left + 1 , top + 1 , width + 1 , height + 1 , tocolor ( 0 , 0 , 0 , 255 ) , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left + 1 , top - 1 , width + 1 , height - 1 , tocolor ( 0 , 0 , 0 , 255 ) , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left - 1 , top + 1 , width - 1 , height + 1 , tocolor ( 0 , 0 , 0 , 255 ) , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left - 1 , top - 1 , width - 1 , height - 1 , tocolor ( 0 , 0 , 0 , 255 ) , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left , top , width , height , color , scale , font , alignX , alignY , clip , wordBreak , postGUI )
end

addEventHandler ( "onClientPedDamage" , resourceRoot ,
	function ( )
		cancelEvent ( )
	end
)

addEventHandler ( "onClientResourceStart" , resourceRoot ,
	function ( )
		tcGUI = build_tcGUI ( )
		dGUI = build_dGUI ( )
	end
)

function build_tcGUI()
	
	local gui = {}
	
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 305, 137
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Joining Team", false)
	guiWindowSetSizable(gui["_root"], false)
	guiWindowSetMovable(gui["_root"], false)
	guiSetAlpha(gui["_root"], 1)
	guiSetVisible(gui["_root"], false)
	
	gui["tcInfoL"] = guiCreateLabel(0, 15, 311, 31, "Are you sure you want to join 'Police'", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["tcInfoL"], "center", false)
	guiLabelSetVerticalAlign(gui["tcInfoL"], "center")
	guiLabelSetColor(gui["tcInfoL"], 255, 0, 0)
	
	gui["tcAcceptB"] = guiCreateButton(50, 95, 75, 23, "Accept", false, gui["_root"])
	if on_tcAcceptB_clicked then
		addEventHandler("onClientGUIClick", gui["tcAcceptB"], on_tcAcceptB_clicked, false)
	end
	
	gui["tcCancelB"] = guiCreateButton(180, 95, 75, 23, "Cancel", false, gui["_root"])
	if on_tcCancelB_clicked then
		addEventHandler("onClientGUIClick", gui["tcCancelB"], on_tcCancelB_clicked, false)
	end
	
	return gui, windowWidth, windowHeight
end

function on_tcAcceptB_clicked(button, state, absoluteX, absoluteY)
	if (button ~= "left") or (state ~= "up") then
		return
	end
	guiSetVisible ( tcGUI [ "_root" ] , false )
	showCursor ( false )
	triggerServerEvent ( "server:setPlayerTeam" , localPlayer , curTeamName )
	setElementFrozen ( localPlayer , false )
end

function on_tcCancelB_clicked(button, state, absoluteX, absoluteY)
	if (button ~= "left") or (state ~= "up") then
		return
	end
	guiSetVisible ( tcGUI [ "_root" ] , false )
	showCursor ( false )
end

addEvent ( "client:showTeamCheckGUI" , true )
addEventHandler ( "client:showTeamCheckGUI" , root ,
	function ( teamName , colorTable )
		guiSetText ( tcGUI [ "tcInfoL" ] , "Are you sure you want to join '" .. teamName .. "'" )
		guiLabelSetColor ( tcGUI [ "tcInfoL" ] , colorTable [ 1 ] , colorTable [ 2 ] , colorTable [ 3 ] )
		guiSetVisible ( tcGUI [ "_root" ] , true )
		showCursor ( true )
		curTeamName = teamName
	end
)

addEvent ( "client:recieveSettings" , true )
addEventHandler ( "client:recieveSettings" , root ,
	function ( traderColor , mechanicColor , hitmanColor , policeColor , offdutyColor , busColor, taxiColor, limoColor, militaryColor, medicColor, ShowCursor , dutyKey )
		settingTraderTeamColor = traderColor
		settingMechanicTeamColor = mechanicColor
		settingHitmanTeamColor = hitmanColor
		settingPoliceTeamColor = policeColor
		settingOffdutyTeamColor = offdutyColor
		settingBusTeamColor = busColor
		settingTaxiTeamColor = taxiColor
		settingLimoTeamColor = limoColor
		settingMilitaryTeamColor = militaryColor
		settingMedicTeamColor = medicColor
		settingShowCursor = ShowCursor
		settingDutyKey = dutyKey
		bindKey ( settingShowCursor , "down" ,
			function ( key )
				showCursor ( not isCursorShowing ( ) )
			end
		)
		bindKey ( settingDutyKey , "up" ,
			function ( key , keyState )
			if getElementData ( localPlayer, "gamemode" ) ~= "rpg" then return end
				if not getPlayerTeam ( localPlayer ) then
					outputChatBox ( "You are not in a team that supports duty" )
					return
				end
				if not isPlayerInStandardTeams ( localPlayer ) and getTeamName ( getPlayerTeam ( localPlayer ) ) ~= "Off Duty Workers" then
					outputChatBox ( "You are not in a team that supports duty" )
					return
				end
				local teamName = getTeamName ( getPlayerTeam ( localPlayer ) )
				local r , g , b = getTeamColor ( getPlayerTeam ( localPlayer ) ) 
				guiSetText ( dGUI [ "dTeamL" ] , "Team: " .. teamName )
				guiLabelSetColor ( dGUI [ "dTeamL" ] , r , g , b )
				if teamName == "Off Duty Workers" then
					guiSetText ( dGUI [ "dDutyB" ] , "On Duty" )
				else
					guiSetText ( dGUI [ "dDutyB" ] , "Off Duty" )
				end
				guiSetVisible ( dGUI [ "_root" ] , not guiGetVisible ( dGUI [ "_root" ] ) )
				showCursor ( guiGetVisible ( dGUI [ "_root" ] ) )
			end
		)
	end
)

addEventHandler ( "onClientResourceStart" , resourceRoot ,
	function ( )
		triggerServerEvent ( "server:sendSettings" , localPlayer )
	end
)

function build_dGUI()
	
	local gui = {}
	
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 291, 131
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Duty", false)
	guiWindowSetSizable(gui["_root"], false)
	guiWindowSetMovable(gui["_root"], false)
	guiSetAlpha(gui["_root"], 1)
	guiSetVisible(gui["_root"], false)
	
	gui["dTeamL"] = guiCreateLabel(0, 15, 291, 41, "Team:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["dTeamL"], "center", false)
	guiLabelSetVerticalAlign(gui["dTeamL"], "center")
	guiLabelSetColor(gui["dTeamL"], 0, 170, 0)
	
	gui["dDutyB"] = guiCreateButton(20, 85, 251, 31, "Off Duty", false, gui["_root"])
	if on_dDutyB_clicked then
		addEventHandler("onClientGUIClick", gui["dDutyB"], on_dDutyB_clicked, false)
	end
	
	return gui, windowWidth, windowHeight
end

function on_dDutyB_clicked(button, state, absoluteX, absoluteY)
	if (button ~= "left") or (state ~= "up") then
		return
	end
	triggerServerEvent ( "server:Duty" , localPlayer )
	local teamName = getTeamName ( getPlayerTeam ( localPlayer ) )
	if teamName == "Off Duty Workers" then
		local r , g , b = getTeamColor ( getTeamFromName ( getElementData(localPlayer, "duty.Team") ) )
		guiSetText ( dGUI [ "dTeamL" ] , "Team: " .. getElementData(localPlayer, "duty.Team") )
		guiLabelSetColor ( dGUI [ "dTeamL" ] , r , g , b )
		guiSetText ( dGUI [ "dDutyB" ] , "Off Duty" )
	else
		local r , g , b = getTeamColor ( getTeamFromName ( "Off Duty Workers" ) )
		guiSetText ( dGUI [ "dTeamL" ] , "Team: Off Duty Workers" )
		guiLabelSetColor ( dGUI [ "dTeamL" ] , r , g , b )
		guiSetText ( dGUI [ "dDutyB" ] , "On Duty" )
	end
end

function isPlayerInStandardTeams(player)
	if getPlayerTeam(player) then
		if getTeamName(getPlayerTeam(player)) == "Police" or  getTeamName(getPlayerTeam(player)) == "Trader" or getTeamName(getPlayerTeam(player)) == "Hitman" or getTeamName(getPlayerTeam(player)) == "Mechanic" or getTeamName ( getPlayerTeam ( player ) ) == "Seeker" or getTeamName ( getPlayerTeam ( player ) ) == "Medics" or getTeamName ( getPlayerTeam ( player ) ) == "Taxi Driver" or getTeamName ( getPlayerTeam ( player ) ) == "Bus Driver" or getTeamName ( getPlayerTeam ( player ) ) == "Military" or getTeamName ( getPlayerTeam ( player ) ) == "Limo Driver"or getTeamName ( getPlayerTeam ( player ) ) == "Medic" then
			return true
		else
			return false
		end
	end
end