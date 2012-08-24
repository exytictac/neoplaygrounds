addEvent ( 'drag:playerjoined', true )
local res = getResourceRootElement()
local READY = false
local enterTimer
local startingMarker = createMarker(-1675.5791015625, -153.0537109375, 13, 'cylinder', 5, 255,128,0)
setElementDimension(startingMarker, 1)

addEventHandler('onClientMarkerHit', startingMarker, function(p, c)
	if (not c) or (p~=localPlayer) then return end
	outputChatBox('Please stay in the marker for 2 seconds to join the drag race')
	if isTimer(enterTimer) then killTimer(enterTimer) end
	enterTimer = setTimer(checkMarker, 2000, 1)
	if isPedInVehicle ( p ) then
			triggerServerEvent ( "removeVeh", p )
	end
end)

function checkMarker()
	if not READY and isElementWithinMarker(localPlayer, startingMarker) then
		guiSetVisible(gui['wnd'], true)
		Animation.createAndPlay(gui['wnd'], Animation.presets.guiFadeIn(500))
		showCursor(true)
		READY = true
	end
end

function output(msg)
	outputChatBox('#ab23af[DRAG] '..msg, 0, 0, 0, true)
end

function errMsg(msg)
	outputChatBox('#ff0000'..msg, 0, 0, 0, true)
end

function __( ... )
	return exports.npg_lang:__( ... );
end

local sw, sh = guiGetScreenSize()
local font = guiCreateFont( "PowerChord.ttf", 20 )

gui = {}
gui['wnd'] = guiCreateWindow(0.32,0.2833,0.3775,0.4067,"Drag Race",true)
guiWindowSetSizable(gui['wnd'],false)
gui['play'] = guiCreateButton(0.0298,0.8197,0.4702,0.1475,"PLAY",true,gui['wnd'])
gui['sp'] = guiCreateButton(0.4967,0.8197,0.4702,0.1475,"SPECTATE",true,gui['wnd'])

gui['grid'] = guiCreateGridList(0.0298,0.0861,0.9371,0.7254,true,gui['wnd'])
guiGridListSetSelectionMode(gui['grid'],2)
guiGridListAddColumn(gui['grid'],"Player",0.2)
guiGridListAddColumn(gui['grid'],"Position",0.2)
--[[
for i = 1, 3 do
    guiGridListAddRow(gui['grid'])
end

guiGridListSetItemText(gui['grid'],0,1,"P1", false, true)
guiGridListSetItemText(gui['grid'],0,2,"1", false, true)

guiGridListSetItemText(gui['grid'],1,1,"P2", false, true)
guiGridListSetItemText(gui['grid'],1,2,"2", false, true)

guiGridListSetItemText(gui['grid'],2,1,"P3", false, true)
guiGridListSetItemText(gui['grid'],2,2,"3", false, true)
]]
guiSetAlpha(gui['wnd'], 0)
guiSetVisible(gui['wnd'], false)

addEventHandler('onClientGUIClick', gui['play'], function()
		if getElementData(res, 'drag.state') == 1 then
			errMsg('A drag race is currently in progress, you may spectate and join the game when it is open')
		else
			Animation.createAndPlay(gui['wnd'], Animation.presets.guiFadeOut(500))
			setTimer(guiSetVisible, 550, 1, gui['wnd'], false)
			showCursor(false)
			triggerServerEvent('drag:join', localPlayer)
		end
	end, false
)

addEventHandler('onClientGUIClick', gui["sp"], function()
		if getElementData(res, 'drag.state') == false then
			errMsg('A drag race hasn\'t been started yet.')
		else
			--spectatePlayers()
		end
	end, false
)