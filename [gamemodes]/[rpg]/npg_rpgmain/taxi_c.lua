local screenWidth, screenHeight = guiGetScreenSize ( ) -- Get the screen resolution (width and height)
local client = getLocalPlayer( )
local marker = nil
local blip = nil
dimension = 100

addEvent("taxi_set_location",true)
addEventHandler("taxi_set_location",root,
function (x, y, z)
	marker = createMarker(tostring(x), tostring(y), tostring(z)-1, "cylinder", 3.5, 255, 255, 0 )
	ped = createPed(math.random (0,299),tostring(x) + 5, tostring(y), tostring(z) ) -- x,y,z is given
	blip = createBlipAttachedTo( marker, 0, 2, 255, 255, 0, 255 )
	setElementDimension ( marker, dimension )
	setElementDimension ( blip, dimension )
	setElementDimension ( ped, dimension )
	addEventHandler("onClientMarkerHit",marker,onTaxiStopHit)
end
)


function RenderThanks ( )
	dxDrawText ( "Thanks for the ride, ".. getPlayerName ( client ), 44, screenHeight - 320, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 2.02, "arial" )
end

function onTaxiStopHit(hitPlayer)
	if not hitPlayer == client then return end
		triggerServerEvent("taxi_finish",client,client)
		removeEventHandler("onClientMarkerHit",marker,onTaxiStopHit)
		destroyElement(marker) 
		destroyElement(ped) 
		destroyElement(blip)
		addEventHandler ( "onClientRender", root, RenderThanks )
		setTimer ( function() removeEventHandler('onClientRender', root, RenderThanks) end, 5000, 1)
		givePlayerMoney ( math.random ( 1,500 ) )
end


		


addEventHandler("onClientVehicleExit",client,
function ( thePlayer, seat )
	if getPlayerTeam(thePlayer, "Taxi Driver") then
		if thePlayer == client then
			removeEventHandler("onClientMarkerHit",marker,onTaxiStopHit)
		if isElement ( marker ) then destroyElement ( marker ) end
		if isElement ( blip ) then destroyElement ( blip ) end
		if isElement ( ped ) then destroyElement ( ped ) end
		end
	end
end
)
