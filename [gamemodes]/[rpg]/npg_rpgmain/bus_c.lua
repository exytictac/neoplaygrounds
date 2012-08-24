local client = getLocalPlayer( )
local marker = nil
local blip = nil
dimension = 100

addEvent("bus_set_location",true)
addEventHandler("bus_set_location",root,
function (x, y, z)
	marker = createMarker(tostring(x), tostring(y), tostring(z)-1, "cylinder", 3.5, 255, 255, 0 )
	blip = createBlipAttachedTo( marker, 0, 2, 255, 255, 0, 255 )
	setElementDimension ( marker, dimension )
	setElementDimension ( blip, dimension )
	addEventHandler("onClientMarkerHit",marker,onBusStopHit)
end
)

function onBusStopHit(hitPlayer)
if getElementData(hitPlayer,"gamemode") ~= "rpg" then return end
	if not hitPlayer == client then return end
		triggerServerEvent("bus_finish",client,client)
		if isElement(blip) then destroyElement(blip) end
			if isElement(marker) then
			removeEventHandler("onClientMarkerHit",marker,onBusStopHit)
			destroyElement(marker) 
			end
		end

addEventHandler("onClientVehicleExit",client,
function ( thePlayer, seat )
exports.gui:hint( "exited!", 3 )
	if getPlayerTeam(thePlayer, "Bus Driver") then
		if thePlayer == client then
			removeEventHandler("onClientMarkerHit",marker,onBusStopHit)
			if isElement ( marker ) then destroyElement ( marker ) end
			if isElement ( blip ) then destroyElement ( blip ) end
		end
	end
end
)
