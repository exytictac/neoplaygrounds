


local taxiTable = {
{1537, -1888, 14},
{1461, -1726, 14},
{1684, -1294, 14},
{2854, -1156, 25},
{2830, -2116, 11},
{2638, -2411, 14},
{1763, -2172, 14},
{620, -1692, 16}
}



function getNewTaxiLocation(thePlayer, ID)
	local x, y, z = taxiTable[ID][1], taxiTable[ID][2], taxiTable[ID][3]
	triggerClientEvent(thePlayer,"taxi_set_location",thePlayer,x,y,z)
end




addEvent ( "taxi_finish", true )
addEventHandler("taxi_finish",root,
function (client)
if getElementData(client,"gamemode") ~= "rpg" then return end
	if not isPedInVehicle(client) then return end
		if not taxis[getElementModel(getPedOccupiedVehicle(client))] then return end
			if #taxiTable == tonumber(getElementData(client,"taxiData")) then
				setElementData(client,"taxiData",1)
			else
				setElementData(client,"taxiData",tonumber(getElementData(client,"taxiData"))+1)
			end
		getNewTaxiLocation(client, tonumber(getElementData(client,"taxiData")))
	end
)
