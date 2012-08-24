shops.rocketcarData       = {}

function shops.rocketcar(me)
	local use
	if not shops.rocketcarData[me] then
		shops.rocketcarData[me] = {}
		shops.rocketcarData[me]["use"] = true
	end
	
    if shops.rocketcarData[me]["use"] and isPedInVehicle(me) then
		shops.rocketcarData[me]["use"] = false
		setTimer(
			function()
				shops.rocketcarData[me]["use"] = true
			end
		, 2000, 1)
		triggerClientEvent("mh:shop.rocketcar:shootrocket", root, me)		
	end
end