--[[
Copyright (c) 2010 MTA: Paradise

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

local ids = { }

addEventHandler( "onPlayerJoin", root,
	function( )
		for i = 1, getMaxPlayers( ) do
			if not ids[ i ] then
				ids[ i ] = source
				setElementData( source, "playerid", i )		
				break
			end
		end
	end
)

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		for i, source in ipairs( getElementsByType( "player" ) ) do
			ids[ i ] = source
			setElementData( source, "playerid", i )
		end
	end
)

addEventHandler( "onPlayerQuit", root,
	function( type, reason, responsible )
		for i = 1, getMaxPlayers( ) do
			if ids[ i ] == source then
				ids[ i ] = nil
				
				if reason then
					type = type .. " - " .. reason
					if isElement( responsible ) and getElementType( responsible ) == "player" then
						type = type .. " - " .. getPlayerName( responsible )
					end
				end
				break
			end
		end
	end
)

function getFromName( player, targetName, ignoreLoggedOut )
	if targetName then
		targetName = tostring( targetName )
		
		local match = { }
		if targetName == "*" then
			match = { player }
		elseif tonumber( targetName ) then
			match = { ids[ tonumber( targetName ) ] }
		elseif ( getPlayerFromName ( targetName ) ) then
			match = { getPlayerFromName ( targetName ) }
		else	
			for key, value in ipairs ( getElementsByType ( "player" ) ) do
				if getPlayerName ( value ):lower():find( targetName:lower() ) then
					match[ #match + 1 ] = value
				end
			end
		end
		
		if #match == 1 then
			if isPlayerLogged( match[ 1 ] ) then
				return match[ 1 ], getPlayerName( match[ 1 ] ):gsub( "_", " " ), getElementData( match[ 1 ], "playerid" )
			else
				if player then
					outputChatBox( getPlayerName( match[ 1 ] ):gsub( "_", " " ) .. " is not logged in.", player, 255, 0, 0 )
				end
				return nil -- not logged in error
			end
		elseif #match == 0 then
			if player then
				outputChatBox( "No player matches your search.", player, 255, 0, 0 )
			end
			return nil -- no player
		elseif #match > 10 then
			if player then
				outputChatBox( #match .. " players match your search.", player, 255, 204, 0 )
			end
			return nil -- not like we want to show him that many players
		else
			if player then
				outputChatBox ( "Players matching your search are: ", player, 255, 204, 0 )
				for key, value in ipairs( match ) do
					outputChatBox( "  (" .. getElementData( value, "playerid" ) .. ") " .. getPlayerName( value ):gsub ( "_", " " ), player, 255, 255, 0 )
				end
			end
			return nil -- more than one player. We list the player names + id.
		end
	end
end

addCommandHandler( "id",
	function( player, commandName, target )
		if isPlayerLogged( player ) then
			local target, targetName, id = getFromName( player, target )
			if target then
				outputChatBox( targetName .. "'s ID is " .. id .. ".", player, 255, 204, 0 )
			end
		end
	end
)

addEventHandler('onPlayerChat', root,
	function(msg, type, target)
	local target, targetName, id = getFromName( source, target )
	acc = getPlayerAccount ( source )
		if isGuestAccount ( acc ) then
			if type == 0 then
				cancelEvent()
				outputChatBox("You cannot chat while not logged in!", source, 255, 0 ,0 )
				outputServerLog("CHAT: "..getPlayerName(source).." tried to chat while logged off ")
			else
				local r, g, b = getPlayerNametagColor(source)
				if target then
				outputChatBox("["..id.."]"..getPlayerName(source) .. ': #FFFFFF' .. msg:gsub('#%x%x%x%x%x%x', ''), root, r, g, b, true)
				outputServerLog( "CHAT: " .. getPlayerName(source) .. ": " .. msg )
				end
			end
		end
	end
)


function getID( player )
	local id = getElementData( player, "playerid" )
	if ids[ id ] == player then
		return id
	else
		for i = 1, getMaxPlayers( ) do
			if ids[ i ] == player then
				return id
			end
		end
	end
end


