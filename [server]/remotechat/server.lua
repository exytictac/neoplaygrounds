function outputChatBoxRemote ( playerName, message, type, serverport )
    if serverport ~= getServerPort() then
        outputChatBox ( "From " .. playerName .. " on " .. serverport .. ": " .. message )
    end
end
 
function playerChatCallback()
end
 
function playerChat ( message, type )
    callRemote ( "178.33.90.181:22222", getResourceName(getThisResource()), "outputChatBoxRemote", playerChatCallback, getPlayerName(source), message, type, getServerPort() )
    callRemote ( "178.33.90.181:22006", getResourceName(getThisResource()), "outputChatBoxRemote", playerChatCallback, getPlayerName(source), message, type, getServerPort() )
end
addEventHandler ( "onPlayerChat", getRootElement(), playerChat )