addEvent("playerChatting", true )
addEvent("playerNotChatting", true )

function playerChatting()
	triggerClientEvent("chat:updateList", getRootElement(), source, true)
end

function playerNotChatting()
	triggerClientEvent("chat:updateList", getRootElement(), source, false)
end
addEventHandler("playerChatting", getRootElement(), playerChatting)
addEventHandler("playerNotChatting", getRootElement(), playerNotChatting)
addEventHandler ("onPlayerQuit", getRootElement(), playerNotChatting )