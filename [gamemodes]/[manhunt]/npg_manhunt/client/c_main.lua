--[[
	Type: Gamemode
	Started: 6th July (Wednesday) 2011
	Finished: ...
	Official Developer: noddy

	You may edit this script to modify functionality to your liking, however this license must remain intact, you must 
	also state what you modified.

	This script is copyrighted by Neo Playgrounds 2011-2012
]]

local me = getLocalPlayer()

function initClient()
	--addEventHandler("onClientPreRender", root, drawNews)
	triggerServerEvent("onPlayerStartManhunt", root, me)
	setPedCanBeKnockedOffBike(me, false)
	showCursor(false)
	outputChatBox("Welcome to #ff0000Manhunt", 0,255,0,true)
end

addEvent("onClientPlayerSelectGamemode", true)
addEventHandler("onClientPlayerSelectGamemode", me, function(gm)
		if gm~="manhunt" then return end
		setTimer ( function ()initClient()
		fadeCamera(true)
		_initGUIs() end, 1500, 1 )
	end
)

function startGame(id)
	outputDebugString(tostring(id)..':'..tostring(getVehicleNameFromModel(id)))
	triggerServerEvent('mh:SelectVehicle', root, tostring(id))
end