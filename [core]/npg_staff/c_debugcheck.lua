--/DEBUGSCRIPT , only Owners
player = getLocalPlayer ( )

function getPlayerClass()
	return getElementData(player,"auth") or 0
end

function checkDebug( )
	if (getPlayerClass( player ) >= 4) then
		if (isDebugViewActive()) then
			triggerServerEvent("kickUnauthorized", player)
		end	
	end
end
setTimer(checkDebug, 50, 0)
