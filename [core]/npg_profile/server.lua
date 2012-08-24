function isPlayerLogged( thePlayer )
    return getElementData( thePlayer, "account") and true or false
end

function callServerFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onClientCallsServerFunction", true)
addEventHandler("onClientCallsServerFunction", resourceRoot , callServerFunction)

function callClientFunction(client, funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    triggerClientEvent(client, "onServerCallsClientFunction", resourceRoot, funcname, unpack(arg or {}))
end


addEvent ( "getSerial", true )
addEventHandler ( "getSerial", root,
	function ( player )
		serial = getPlayerSerial ( player )
		triggerClientEvent ( source, "returnSerial", source, serial )
	end
)
