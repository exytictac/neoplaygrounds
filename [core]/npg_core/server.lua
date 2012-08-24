-- ///////////////////////////////////////////////
-- / NPG - General                               /
-- / Written by NPG Team  (c) 2011-2012          /
-- ///////////////////////////////////////////////



function __( ... )
	return exports.npg_lang:__( ... );
end

o = outputChatBox

local gamemode = {}

--[[CUSTOM EVENTS]]--
addEvent ( "onPlayerTryLogin", true )
addEvent ( "onPlayerTryRegister", true )
addEvent ( "onGuiRequest", true )
addEvent ( "onPlayerReadRules", true )
addEvent ( "onGamemodeLeave", true )
addEvent ( "onPlayerHideHud", true )
---------------------

function hideHud ( p )
    showPlayerHudComponent ( p, "all", false )
    showPlayerHudComponent ( p, "crosshair", true )
end
addEventHandler ( "onPlayerHideHud", root, hideHud )


addEventHandler ( "onGamemodeLeave", root,
	function ( gm )
		if getPlayerGamemode ( source ) then
			if getPlayerGamemode ( source ) == gm then
				exports.npg_textactions:sendMessage(source, 'You are in that Gamemode already!', 255, 0, 0, false)
			else
				setElementInterior ( source, 0 )
				triggerEvent ( "saveUserData", source )
				o ( "works", source,0,0,0 )
			end
		else
			cancelEvent ( )
			o ( "not in the gamemode", source )
		end
	end
)

function getPlayerGamemode(pl)
	return pl and getElementData(pl or source, "gamemode") or false
end

function getGamemodeName(pl)
	local gmName = tostring(getPlayerGamemode(pl))
	if gmName == "freeroam" then
		return "Freeroam"
	elseif gmName == "rpg" then
		return "RPG"
	elseif gmName == "race" then
		return "Race"
	elseif gmName == "manhunt" then
		return "Manhunt"
	elseif gmName == "king of the hill" or "koth" then
		return "King of the Hill"
	else
		return "None"
	end
end
------------------------

--[[CAMERA RELATED PART]]--
addEventHandler ( "onPlayerJoin", root,
    function()
		hideHud ( source )
        showChat ( source, false )
    end
)

addEventHandler ( "onPlayerLogin", root, function ( )
	triggerClientEvent ( source, "onClientPlayerLogin", source )
end)

function getAuth(thePlayer)
	return getElementData(thePlayer, "auth") or 0
end
	
addEventHandler ( "onPlayerLogout", root, function ( )
	if true then--getAuth ( source ) >= 2 then for now we allow
		exports.npg_textactions:sendMessage(source,'You successfully logged out!',0, 255, 0, false)
	else
		cancelEvent ( ) 
	end 
end)
	
---------------------------

--[[LOGIN GUI SYSTEM]]--
addEventHandler ( "onPlayerTryLogin", root, function ( name, pass )
	    if isGuestAccount ( getPlayerAccount ( source ) ) then
		    local acc = getAccount ( name )
		    if acc then
			    local result = logIn ( source, acc, pass )
				if not result then 
					triggerClientEvent ( source, "onClientPlayerFailLogin", source, "Wrong password", source ) 
				end
			else
				triggerClientEvent ( source, "onClientPlayerFailLogin", source, "No account", source) 
			end
		else 
			triggerClientEvent ( source, "onClientPlayerLogin", source) 
		end
	end 
)

addEventHandler ( "onPlayerTryRegister", root, function(name, pass, email)
	    if ( isGuestAccount( getPlayerAccount(source) ) ) then
		    local acc = getAccount ( name )
		    if not acc then
			    local acc = addAccount ( name, pass )
			    if acc then
					if ( email ~= nil ) then
						triggerEvent("buildUserData", source, a, email)
						logIn ( source, acc, pass )
					else
						triggerClientEvent ( source, "onClientPlayerFailRegister", source, "No e-mail", source )
					end
				else
					triggerClientEvent ( source, "onClientPlayerFailRegister", source, "Unknown register", source)
				end
			else
				triggerClientEvent ( source, "onClientPlayerFailRegister", source, "Account exists", source)
			end
		else
			triggerClientEvent ( source, "onClientPlayerLogin", source)
		end
	end
)		

--[[VARIOUS CONFIGURATIONS: CHAT, SPAWNING, GUI LOADING]]--
addEventHandler ( "onGuiRequest", root,
    function ( )
	    if isGuestAccount ( getPlayerAccount ( source ) ) then
            showChat ( source, false )
		    setTimer ( triggerClientEvent, 100, 1, source, "onClientPlayerGuiLoad", source )
			setTimer ( triggerClientEvent, 100, 1, source, "onClientPlayerLanguageCam", source )
		elseif not isGuestAccount(getPlayerAccount(source)) and not getElementData ( source, "gamemode" ) then
			setTimer ( triggerClientEvent, 100, 1, source, "onClientPlayerGuiGMLoad", source )
		end
	end 
)

function output ( player, ... )
	return outputChatBox(table.concat({...}), player, 255,255,255)
end


function isPlayerLogged(pl)
    return not isGuestAccount(getPlayerAccount(pl))
end

function isPlayerReady(pl)
	return getPlayerGamemode(pl) and true or false
end

function checkTeam()
	if not isPlayerReady ( source ) == true then
		setPlayerTeam ( source, nil )
	end
end
addEventHandler ( "onPlayerLogin", root, checkTeam )


