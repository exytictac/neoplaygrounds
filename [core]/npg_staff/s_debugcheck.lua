function kickIntruder( )
	outputDebugString ( getPlayerName ( source ).." was kicked by debugscript security.")
	kickPlayer(source, getRootElement(), "Unauthorized command.")
end
addEvent("kickUnauthorized", true)
addEventHandler("kickUnauthorized", getRootElement(), kickIntruder)	