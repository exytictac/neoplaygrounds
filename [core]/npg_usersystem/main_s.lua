misc = exports['misc']


function getVersion( )
    return "0.1"
end


--[[
    TEXT DISPLAY EVENTS
]]
--create our "Hello World" text item
local serverDisplay, serverDisplayText = "Welcome to Neo Playgrounds \n\n Resources are currently being downloaded.\n Please wait a while until you can enjoy the full NPG experience."

--[[
    SCOREBOARD DATA
]]
setTimer(function()
        for i,v in pairs(getElementsByType"player") do
            local time = tonumber(getElementData(v, "timeSpent"))
            if not misc:isPlayerLoggedIn ( v ) then
                time = nil
            else
                setElementData(v,"timeSpent",time+1)
                if (time < 60) then
                    setElementData(v,"Time Spent", tostring(time) .. "mins")
                else
                    setElementData(v,"Time Spent", tostring(math.floor(time / 60)) .. "hrs " .. math.floor(time % 60) .. "mins")
                end
                setElementData(v, "Money", getPlayerMoney(v), true)
            end
        end
    end, 60000, 0 )
 -- We do it every minute

--[[
    MAIN CONTENT
]]
classCol = {
    [0] = {255,255,0},
    [1] = {0, 255,0},
    [2] = {255,128,0},
    [3] = {255,0,0}
}

local dimensions = {
    --["race"] = 0,
    ["freeroam"] = 1,
    ["gungame"] = 200,
    ["manhunt"] = 420,
    ["rpg"] = 100
}

function dec2hex(v)
    return string.format("%X", type(v)=="string" and tonumber(v) or v)..""
end




-- ******************
-- * Event handlers *
-- ******************


addEventHandler("onResourceStart", resourceRoot,
    function()

        setGameType( "NPG: 0.1" )
        setRuleValue( "author", "CapY, Noddy, Noel, Otto" )
        setRuleValue( "homepage", "http://neoplaygrounds.com" )
        setRuleValue( "forum", "http://forums.neoplaygrounds.com" )
        setRuleValue( "version", getVersion( ) )
        setMapName( "MTA:SA" )
        setFPSLimit ( 100 )
        
        local playersList = getElementsByType("player")
        for i, thePlayer in pairs(playersList) do
            setElementData(thePlayer, "reportsCount", 0)
            bindKey(thePlayer, 'F5', 'down', 'stafflog')
        end
        
		-- Get all of the players
        for i, v in ipairs (getElementsByType("player")) do
			-- Check if a player is logged
            if misc:isPlayerLoggedIn ( v ) then
				-- If he is not in any gamemode
                if misc:isPlayerReady ( v ) == false then
					-- Then hide hud and components
                    showChat ( v, false )
                    showPlayerHudComponent ( v, "all", false )
                    showPlayerHudComponent ( v, "crosshair", true )
                    triggerClientEvent ( v, "onClientSet", v )
                end
			-- Else do nothing
            else
                return
            end
        end
        
        setTimer( 
            function( )
                outputServerLog( "    _____  _____  ______ " )
                outputServerLog( "   |  _  ||  _  ||  _   |" )
                outputServerLog( "   | | | || |_| || |_|  |" )
                outputServerLog( "   |_| |_||  ___||____| |" )
                outputServerLog( "          | |      ___| |" )
                outputServerLog( "          |_|     |_____|       " .. getVersion( ) )
            end, 50, 1
        )
    
        -- The money!
        exports.scoreboard:addScoreboardColumn('Time Spent', root, 4, 0.13)
        -- Set weather.
        setWeather(1)
        
        -- Set display if downloading
        serverDisplay = textCreateDisplay ( ) --create the display
        serverDisplayText = textCreateTextItem (serverDisplayText , 0.5, 0.5, "high", 255, 255,255, 255, 2 , "center", "top") --create our "Hello World" text item
        textDisplayAddText ( serverDisplay, serverDisplayText ) --add this to the display
        
        -- Disable clouds (it's laggy).
        setCloudsEnabled(false)
    
        for i, p in ipairs(getElementsByType("player")) do

            -- Recreate player's blip.
            setPlayerNametagColor(p, unpack(classCol[getAuth(p)] or {255,255,0}))   
            for i, v in ipairs(getElementsByType"player") do
                if isGuestAccount(getPlayerAccount(v)) then
                    redirectPlayer(v, "play.neoplaygrounds.com", getServerPort ( ))
                else
                    showChat ( v, true )
                end
            end
        end
    end
)

addEvent("onLoadedAtClient", true)
addEventHandler("onLoadedAtClient", resourceRoot,
    function(p)
        setTimer(textDisplayRemoveObserver, 50,1, serverDisplay, p)
    end
)


addEventHandler("onPlayerLogin", root,
    function()
        -- Get player account.
        local theAccount = getPlayerAccount(source)
        setElementData(source, "account", theAccount, true)
        setElementData(source, "accountName", getAccountName(theAccount), true)
        
        --Trigger the information image
        triggerClientEvent ( "onClientPlayerInformationShowUp", source )
        
        fadeCamera ( source, false )
        setTimer ( fadeCamera, 1550, 1, source, true )
            
        --Set player's blur to 0
        setPlayerBlurLevel ( source, 0 )
    
        -- Load user's data.
        triggerEvent("loadUserData", root, source)

        -- Create player's blip and set its nametag color.
        setPlayerNametagColor(source, unpack(classCol[getAuth(source)] or {255,255,0}))
        
        if misc:getAuth(source) >= 1 then
            addEventHandler( "onClientKey", getRootElement(), handleSpeed )
        end
    end
)

addEventHandler("onPlayerQuit", root,
    function( theAccount, newAccount)       
        -- Save user's data.
        triggerEvent("saveUserData", root, source)
        setElementData(source, "account", false)
        setElementData(source, "accountName", false)
    end
)


addEventHandler ( "onPlayerCommand", root, function(cmd)
		-- If the command is "register"
        if cmd == "register" then
			-- Then cancel it
            cancelEvent()
            outputChatBox ( "To register an account, you must use the general method.", source, 255,0,0 )
        end
    end
)


addEventHandler("onPlayerJoin", root,
    function()
		-- Set a text when downloading
        textDisplayAddObserver ( serverDisplay, source )
		-- Set the player country
        setElementData ( source, "Country", exports['admin']:getPlayerCountry ( source ) )
        local n = getPlayerName(source)
		-- Remove hex code or NPG tag from player's name, if used
        setPlayerName(source, string.gsub(n:gsub("#%x%x%x%x%x%x", ""), "npg", ""))
		-- Bind staff window key
        bindKey(source, 'F5', 'down', 'stafflog')
		-- Set the source report count to zero
        setElementData(source, "reportsCount", 0)
    end
)


local advertisement = { "www.", ".tk", ".com", ".net" }

addEventHandler( "onPlayerChangeNick", root,
    function( old, nick )
        for key, value in ipairs( advertisement ) do
			-- If nick is matching the value
            if nick == value or nick:find( value ) then
				-- Then don't change his nickname
                cancelEvent( )
                return
            end
        end
        if string.find(string.lower(nick),"npg") then
			-- If the source is above rank 1
            if getAuth ( source ) >= 1 then
				-- Then allow him usage of NPG tag
                return true
            else
				-- Else prevent him from using it
                cancelEvent()
                outputChatBox ( "You aren't allowed to use this tag", source, 0,255,0 )
            end
            if string.find(nick,"#%x%x%x%x%x%x") then
                cancelEvent()
                setPlayerName(source, nick:gsub('#%x%x%x%x%x%x', ''))
            end
        end
    end
)

addEventHandler("onPlayerConnect", root,
    function(playerNick, playerIP, playerUsername, playerSerial, clientVersion)
    local version = getVersion()
        if playerSerial == tonumber("45A0D4AC0C0D693FE9B2B6378EDC3124") then
            outputServerLog("[DKR] - User joined the game: SANDER")
            return
        end
        
        for key, value in ipairs( advertisement ) do
            if playerNick == value or playerNick:find( value ) then
                cancelEvent( true, "'" .. playerNick .. "' is not allowed as nick. Go to Settings > Multiplayer to change it.")
                return
            end
        end
        -- Check if the version is earlier than 1.3
        if ( version.mta < "1.3" ) then
            cancelEvent( true, "Please install the latest version of MTA:SA from http://mtasa.com" )
        end
        
        if ( version.type == "Custom" ) then
			cancelEvent( true, "Please install an official build of MTA:SA, custom clients are not allowed!" )
		end


        --[[ TODO: Check if the player is not blacklisted.
        local blacklistNode = xmlLoadFile("blacklist.xml")
        if blacklistNode then
            serialNodes = xmlNodeGetChildren(blacklistNode)
            for i, node in ipairs(serialNodes) do
                if (xmlNodeGetValue(node) == playerSerial) then
                    cancelEvent(true, "You can't join this server because you are blacklisted.")
                    
                    xmlUnloadFile(blacklistNode)
                    return
                end
            end

            xmlUnloadFile(blacklistNode)
        end
        ]]
    end
)


addCommandHandler( "reloadacl",
    function( player )
        if misc:getAuth(p) >= 2 then
            if aclReload( ) then
                outputServerLog( "ACL has been reloaded. (Requested by " .. ( not player and "Console" or getAccountName( getPlayerAccount( player ) ) or getPlayerName(player) ) .. ")" )
                if player then
                    outputChatBox( "ACL has been reloaded.", player, 0, 255, 0 )
                end
            else
                outputServerLog( "ACL reload failed. (Requested by " .. ( not player and "Console" or getAccountName( getPlayerAccount( player ) ) or getPlayerName(player) ) .. ")" )
                if player then
                    outputChatBox( "ACL reload failed.", player, 255, 0, 0 )
                end
            end
        else
            outputChatBox ( "You don't have any rights to do that action!", player, 255,0,0 )
        end
    end
)

function hidetag(p, command)
    if misc:getAuth(p) >= 1 then
        setElementData(p, "hideTag", not (getElementData(p, "hideTag") and true or false))
    end
end

--// Add command handlers
addCommandHandler("hidetag", hidetag)

--// Basic acccount management
addCommandHandler ( "delacc",
    function ( player, _, accname )
	local acc = getAccount ( accname )
        if misc:getAuth ( player ) >= 2 then
            if acc then 
                removeAccount ( acc ) 
                outputChatBox ( "Account deleted!", player )
            else 
                outputChatBox ( "No such account.", player )
            end 
        else
            outputChatBox ( "Access denied!", player, 255,0,0 )
        end
    end
)
    
addCommandHandler ( "accs",
    function ( player )
        for i, v in ipairs ( getAccounts ( ) ) do
            if i <= 50 then outputChatBox ( getAccountName ( v ), player )
            else break end
        end
    end )


addCommandHandler ( "addacc",
    function ( _, player, accname, pass )
	local account = getPlayerAccount ( source )
		if not misc:isPlayerLoggedIn ( player ) then
			if ( accname ~= "" and accname ~= nil and pass ~= "" and pass ~= nil ) then
				addAccount ( accname, pass )
				local acc = getAccount ( accname )
				if acc then
					setAccountData ( acc, "rpg.newUser", true )
					setAccountData ( acc, "freeroam.newUser", true )
					setAccountData ( acc, "manhunt.newUser", true )
					setAccountData ( acc, "race.newUser", true )
					setAccountData ( acc, "gungame.newUser", true )
					setAccountData ( acc, "general.rulesRead", true )
					outputConsole ( "Account: "..accname.." successfully added with password ".. pass, player )
				else
					outputConsole ( "Error while creating account!", player )
				end
			else
				outputConsole ( "Syntax /addacc <name> <password>", player )
			end
		elseif account then
			setAccountData ( account, "rpg.newUser", true )
			setAccountData ( account, "freeroam.newUser", true )
			setAccountData ( account, "manhunt.newUser", true )
			setAccountData ( account, "race.newUser", true )
			setAccountData ( account, "gungame.newUser", true )
			setAccountData ( account, "general.rulesRead", true )
		end
    end
)

--[[addCommandHandler ( "check",
	function ( accname, cmd )
		if not isPlayerLogged ( source ) then
			if ( accname ~= "" and accname ~= nil ) then
				local acc = getAccount ( accname )
				if acc then
					if getAccountData ( acc, "general.rulesRead" ) == true then
						outputConsole ( "sucess", source )
					else
						outputConsole ( "not success", source )
					end
				else 
					outputConsole ( "no such acc", source )
				end
			else
				outputConsole ( "wrong", source )
			end
		else
		--	outputConsole ( "not logged in", source )
			local account = getPlayerAccount ( source )
			if account then
				if getAccountData ( account, "general.rulesRead" ) == true then
						outputConsole ( "sucess", source )
					else
						outputConsole ( "not success", source )
					end
			else
				outputConsole ( "something went wrong, blame orange!", source )
			end					
		end
		--outputConsole ( "Syntax /check <username>", source )
	end
)]]
        


addEventHandler( "onResourceStop", resourceRoot,
    function( )
        removeRuleValue( "author" )
        removeRuleValue( "homepage" )
        removeRuleValue( "forum" )
        local playersList = getElementsByType("player")
        for i, thePlayer in pairs(playersList) do
            if (playerMuteTimer[thePlayer] ~= nil) then
                setPlayerMuted(thePlayer, false)
            end
        end
    end
)


addCommandHandler( "restartall",
    function( player )
    if misc:getAuth ( player ) >= 2 then
        for index, resource in ipairs ( getResources ( ) ) do
            if getResourceState ( resource ) == "running" and getResourceName ( resource ) ~= getThisResource ( ) then
                if not restartResource ( resource ) then
                    outputServerLog( "restartall: Failed to restart '" .. getResourceName ( resource ) .. "' . Try starting it manually. If error persists, restarting the server is recommended." )
                end
            end
        end
        outputServerLog( "restartall: Restarting all resources" .. " (Requested by " .. ( not player and "Console" or getAccountName( getPlayerAccount( player ) ) or getPlayerName(player) ) .. ")" )
        if player then
            outputChatBox( "All resources have been restarted.", player, 0, 255, 153 )
        end
    end
    end
)

addCommandHandler( "startall",
    function( player )
    if misc:getAuth ( player ) >= 2 then
        for index, resource in ipairs ( getResources ( ) ) do
            if getResourceState ( resource ) == "loaded" then
                if not startResource ( resource ) then
                    outputServerLog( "startall: Failed to start resource '" .. getResourceName ( resource ) .. "' . Try starting it manually. If error persists, restarting the server is recommended." )
                end
            end
        end
        outputServerLog( "startall: Starting all resources. " .. " (Requested by " .. ( not player and "Console" or getAccountName( getPlayerAccount( player ) ) or getPlayerName(player) ) .. ")" )
        if player then
            outputChatBox ( "All resources have been started.", player, 0, 255, 153 )
        end
    end
    end
)

-- GTA:SA Modifications check

local resourceName = getResourceName( resource )

addEvent( resourceName .. ":gtasa", true )
addEventHandler( resourceName .. ":gtasa", root,
    function( cheat )
        if source == client and type( cheat ) == "string" then
            ban( client, "GTA:SA Cheat - " .. cheat )
        else
            ban( client, "Fake " .. resourceName .. ":gtasa event with param " .. tostring( cheat ) )
        end
    end
)

addEvent( resourceName .. ":update", true )
addEventHandler( resourceName .. ":update", root,
    function( gameSpeed, isNormalGameSpeed, gravity )
        if hasObjectPermissionTo( client, "command.crun", false ) then
            return -- we can skip that part as clients are allowed to do so
        elseif source == client and type( gameSpeed ) == "number" and type( isNormalGameSpeed ) == "boolean" and type( gravity ) == "number" then
            if gameSpeed ~= getGameSpeed( ) or ( getGameSpeed( ) == 1 ) ~= isNormalGameSpeed then
                ban( client, "Gamespeed Modification: " .. gameSpeed .. " - expected " .. getGameSpeed( ) )
            elseif gravity * 100000 ~= getGravity( ) * 100000 then
                ban( client, "Gravity Modification: " .. gravity .. " - expected " .. getGravity( ) )
            end
        else
            ban( client, "Fake " .. resourceName .. ":update event with param " .. tostring( gameSpeed ) .. "; " .. tostring( isNormalGameSpeed ) .. "; " .. tostring( gravity ) )
        end
    end
)


-- Health hacks check

addEventHandler("onPlayerWasted", getRootElement(),
    function(ammo, attacker, weapon, bodypart)
        if misc:isPlayerReady ( source ) then
            if (getElementHealth(source) == 100) then
                -- If the health is still 100, we report it.
                triggerEvent("reportToStaffLog", getRootElement(), source, "Health hack", "(none)")
            end
        end
    end
)


-- Player ID managment


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
        if misc:isPlayerLoggedIn( player ) then
            local target, targetName, id = getFromName( player, target )
            if target then
                outputChatBox( targetName .. "'s ID is " .. id .. ".", player, 255, 204, 0 )
            end
        end
    end
)

addEventHandler('onPlayerChat', getRootElement(),
    function(msg, type, target)
    local target, targetName, id = getFromName( source, target )
    acc = getPlayerAccount ( source )
        if isGuestAccount ( acc ) then
            if type == 0 then
                cancelEvent()
                outputChatBox("You cannot chat while logged off!", source, 255, 0 ,0 )
                outputServerLog("CHAT: "..getPlayerName(source).." tried to chat while logged off ")
            else
                local r, g, b = getPlayerNametagColor(source)
                if target then
                outputChatBox("["..id.."]"..getPlayerName(source) .. ': #FFFFFF' .. msg:gsub('#%x%x%x%x%x%x', ''), getRootElement(), r, g, b, true)
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


-- LP usage
function showLampPost(thePlayer, command, ...)
    if misc:getAuth(thePlayer) >= 1 then
        local theMessage = table.concat({...}, " ")
        triggerClientEvent("showLampPost", getRootElement(), theMessage)
    else
        outputChatBox("You can't use this command.", thePlayer, 255, 0, 0, false)
    end
end

addCommandHandler("lp", showLampPost)


-- [NPG] tag check

function noThanks(pl)
    local thePlayerNick = getPlayerName(pl)
    setPlayerName(thePlayerNick, string.gsub(thePlayerNick:gsub('#%x%x%x%x%x%x', ''),"npg",""))
end


-- Anti spam


local playerTickCount = { }
local playerIsTalking = { }
local playerMessagesCount = { }
local playerMuteTimer = { }

function unmutePlayer(thePlayer)
    -- Unmute the player.
    setPlayerMuted(thePlayer, false)
    playerMuteTimer[thePlayer] = nil
    -- Display a message in the chatbox and Debug box.
    outputDebugString("*SPAM: ".. getPlayerName(thePlayer) .. " has been unmuted.", 3)
    outputChatBox ( getPlayerName ( thePlayer ) .. " has been unmuted ( Mute expired )", root, 0, 255, 0 )
    triggerClientEvent(thePlayer, "showLampPost", getRootElement(), "YOU HAVE BEEN UNMUTED \n\n DO NOT SPAM NEXT TIME","255,0,0" )
    
end

function mutePlayer(thePlayer)
    -- Mute the player for 30 seconds.
    setPlayerMuted(thePlayer, true)
    playerMuteTimer[thePlayer] = setTimer(unmutePlayer, 30000, 1, thePlayer)
    
    -- Display a message in the chatbox and debug box
    outputDebugString("*SPAM: ".. getPlayerName(thePlayer) .. " has been muted for spamming.", 3)
    outputChatBox ( getPlayerName ( thePlayer ) .. " has been muted ( Chat flooding )", root, 255, 0, 0 )
    triggerClientEvent(thePlayer, "showLampPost", getRootElement(), " YOU HAVE BEEN MUTED FOR SPAMMING \n\n DO NOT SPAM","255,0,0", 10000)
end

addEventHandler("onPlayerChat", getRootElement(),
    function(message)
        playSoundFrontEnd ( getRootElement(), 33 )
        if (not playerIsTalking[source]) then
            -- The player is talking.
            playerIsTalking[source] = true
            playerTickCount[source] = getTickCount()
        else
            -- The player is still talking. We check the time between each post.
            if (getTickCount() - playerTickCount[source] > 6000) then
                -- The player is not spamming.
                playerTickCount[source] = getTickCount()
                playerMessagesCount[source] = 0
            else
                if (playerMessagesCount[source] == nil) then
                    playerMessagesCount[source] = 0
                end
            
                -- Check the numbers of posts.
                if (playerMessagesCount[source] >= 4) then
                    -- The player is spamming. We mute him.
                    playerTickCount[source] = getTickCount()
                    cancelEvent()
                    mutePlayer(source)
                    
                    -- Do a report to the staff log.
                    triggerEvent("reportToStaffLog", getRootElement(), source, "Spam", tostring(playerMessagesCount[source]) .. " messages in 6 seconds")
                end
                
                playerMessagesCount[source] = playerMessagesCount[source] + 1
            end
        end
    end
)

addEventHandler("onPlayerJoin", getRootElement(),
    function()
        playerIsTalking[source] = false
        playerMuteTimer[source] = nil
        playerMessagesCount[source] = 0
    end
)

-- Staff log


local reportsCount = 0

local reportDate = { }
local reportPlayer = { }
local reportType = { }
local reportInfo = { }



addCommandHandler("stafflog",
    function(source)
        if misc:getAuth(source) >= 2 then
            triggerClientEvent(source, "openStaffLog", getRootElement())
        end
    end
)

function initializeReportsList()
    local i = 0
    while (i < reportsCount) do
        triggerClientEvent(source, "addReportToList", getRootElement(), reportDate[i], reportPlayer[i], reportType[i], reportInfo[i])
        i = i + 1
    end
end

addEvent("reportToStaffLog", true)
addEventHandler("reportToStaffLog", getRootElement(),
    function(thePlayer, typeReport, moreInfo)
        local time = getRealTime()

        reportDate[reportsCount] = tostring(time.hour) .. ":" .. tostring(time.minute) .. ":" .. tostring(time.second) .. ", " .. tostring(time.year) + 1900 .. "-" .. tostring(time.month) .. "-" .. tostring(time.monthday)
        reportPlayer[reportsCount] = getPlayerName(thePlayer)
        reportType[reportsCount] = typeReport
        reportInfo[reportsCount] = moreInfo

        local playerReportsCount = getElementData(thePlayer, "reportsCount")
        if (playerReportsCount == false) then
            playerReportsCount = 1
        else
            playerReportsCount = playerReportsCount + 1
        end
        setElementData(thePlayer, "reportsCount", playerReportsCount)

        triggerClientEvent(thePlayer, "addReportToList", getRootElement(), reportDate[reportsCount], reportPlayer[reportsCount], reportType[reportsCount], reportInfo[reportsCount])
        reportsCount = reportsCount + 1
    end
)

function deleteAllReports()
    reportDate = { }
    reportPlayer = { }
    reportType = { }
    reportInfo = { }
    reportsCount = 0

    local playersList = getElementsByType("player")
    for i, thePlayer in pairs(playersList) do
        setElementData(thePlayer, "reportsCount", 0)
    end
end

addEvent("initializeReportsList", true)
addEventHandler("initializeReportsList", getRootElement(), initializeReportsList)
addEvent("deleteAllReports", true)
addEventHandler("deleteAllReports", getRootElement(), deleteAllReports)


-- Staff/Owners online


local adminsOnline = 0
local moderatorsOnline = 0

function updateAdminsOnline()
    adminsOnline = 0

    for i, thePlayer in ipairs(getElementsByType("player")) do
        if misc:getAuth(thePlayer) >= 3 then
            adminsOnline = adminsOnline+1
        end
    end
end

function updateModeratorsOnline()
    moderatorsOnline = 0

    for i, thePlayer in ipairs(getElementsByType("player")) do
        if tonumber(misc:getAuth(thePlayer)) == 2 then
            moderatorsOnline = moderatorsOnline + 1
        end
    end
end

function sendStrings()
    triggerClientEvent("staffonline:setstrings", getRootElement(), adminsOnline, moderatorsOnline)
end
function updateStrings()
    setTimer(updateAdminsOnline, 1000, 1)
    setTimer(updateModeratorsOnline, 1000, 1)
    setTimer(sendStrings, 2000, 1)
end
addEvent("staffonline:getStringsFromServer", true)
addEventHandler("staffonline:getStringsFromServer", getRootElement(),updateStrings)
addEventHandler("onPlayerLogout", getRootElement(),updateStrings)
addEventHandler("onPlayerQuit", getRootElement(),updateStrings)
addEventHandler("onPlayerChangeNick", getRootElement(),updateStrings)
addEventHandler("onPlayerLogin", getRootElement(), updateStrings)

addEventHandler("onElementDataChange", getRootElement(),
    function(dataName)
        if dataName == "hideTag" or dataName == "stealthMode" then
            updateStrings()
        end
    end
)

-- Vehicle anti-hacks and managment

addEventHandler("onPlayerVehicleEnter", getRootElement(),
    function()
        local theVehicle = getPedOccupiedVehicle(source)
        local id = getElementModel(theVehicle)
        local playerClass = getElementData(source, "auth")
        if (playerClass == false) then
            playerClass = 1
        end

        if (id == 432) then
            -- Only staff can use this vehicle. Otherwise, we destroy the vehicle
            -- and we report that in the cheatlog.
            if (misc:getAuth(source) < 1) then
                triggerEvent("reportToStaffLog", getRootElement(), source, "Disallowed vehicle", getVehicleName(theVehicle))
                destroyElement(theVehicle)

                return
            end
        end

        if (id == 432 or id == 425 or id == 520 or id == 447 or id == 476 or id == 430 or id == 464) then
            -- Only staff can shoot with these vehicles.
            if (misc:getAuth(source)<= 1) then
                toggleControl(source, "vehicle_fire", false)
                toggleControl(source, "vehicle_secondary_fire", false)
            else
                -- Enable shoots for staff :D .
                toggleControl(source, "vehicle_fire", true)
                toggleControl(source, "vehicle_secondary_fire", true)
            end
        end
    end
)


function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return (x^2 + y^2 + z^2) ^ 0.5 * 100
        else
            return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
        end
    else
        return false
    end
end

function setElementSpeed(element, unit, speed)
    if (unit == nil) then unit = 0 end
    if (speed == nil) then speed = 0 end
    speed = tonumber(speed)
    local acSpeed = getElementSpeed(element, unit)
    if (acSpeed~=false) then
        local diff = speed/acSpeed
        local x,y,z = getElementVelocity(element)
        setElementVelocity(element,x*diff,y*diff,z*diff)
        return true
    end
    return false
end


function handleSpeed(button, press)
    theVehicle = getPedOccupiedVehicle(getLocalPlayer())
    getspeed = getElementSpeed(theVehicle,2)
    if (button == "mouse_wheel_up") and (theVehicle) and (isPedInVehicle(getLocalPlayer())) and not (getspeed == 0) then
        setElementSpeed(theVehicle, 2, getspeed+10)
    elseif (button == "mouse_wheel_down") and (theVehicle) and (isPedInVehicle(getLocalPlayer())) and not (getspeed == 0) then
        setElementSpeed(theVehicle, 2, getspeed-15)
    end
end

-- Anti-weapon hacks

local weaponsList = {
    "Brass Knuckles",
    "Golf club",
    "Nightstick",
    "Knife",
    "Baseball bat",
    "Shovel",
    "Pool cue",
    "Katana",
    "Chainsaw",
    "Long purple dildo",
    "Short tan dildo",
    "Vibrator",
    "??",
    "Flowers",
    "Cane",
    "Grenade",
    "Tear gas",
    "Molotov cocktails",
    "??",
    "??",
    "??",
    "Pistol",
    "Silenced pistol",
    "Desert eagle",
    "Shotgun",
    "Sawn-off shotgun",
    "SPAZ-12 Combat Shotgun",
    "Uzi",
    "MP5",
    "AK-47",
    "M4",
    "TEC-9",
    "Country rifle",
    "Sniper rifle",
    "Rocket Launcher",
    "Heat-seeking RPG",
    "Flamethrower",
    "Minigun",
    "Satchel charges",
    "Satchel detonator",
    "Spraycan",
    "Fire extinguisher",
    "Camera",
    "Night-vision goggles",
    "Infrared goggles",
    "Parachute"
}

addEventHandler("onPlayerWeaponSwitch", getRootElement(),
    function(previousWeapon, newWeapon)
        if (getElementType(source) == "player") then
            if (getElementDimension(source) ~= 100) then
                if (newWeapon == 0) then
                    -- Exit the function.
                    return
                end

                if (misc:getAuth(source) == 0) then
                    -- For all players, the following weapons are allowed: parachute, camera,
                    -- purple dildo and vibrator.
                    if (newWeapon == 46 or newWeapon == 43 or newWeapon == 10 or newWeapon == 12) then
                        -- Exit the function.
                        return
                    end
                else
                    return
                end

                -- If a disallowed weapon has been detected, we report it.
                triggerEvent("reportToStaffLog", getRootElement(), source, "Disallowed weapon", weaponsList[newWeapon])
                setTimer(takeWeapon, 50, 1, source, newWeapon)
            end
        end
    end
);