addEvent ( "onClientPlayerSelectGamemode", true )


function getPlayerGamemode(pl)
	return pl and getElementData(pl, "gamemode") or false
end


function loadPlayers()
    guiGridListClear( gridList )
    for id, playeritem in ipairs(getElementsByType("player")) do
        local row = guiGridListAddRow ( gridList )
        guiGridListSetItemText ( gridList, row, column, getPlayerName ( playeritem ), false, false )
    end
end
addEventHandler("onClientPlayerJoin",root,loadPlayers)
addEventHandler("onClientPlayerQuit",root,loadPlayers)
addEventHandler("onClientPlayerChangeNick",root,loadPlayers)



function getClassName(class)
	class = tostring ( getAuth ( getLocalPlayer ( ) ) )
	if class == 1 then
		return "VIP"
	elseif class == 2 then
		return "Moderator"
	elseif class == 3 then
		return "Administrator"
	else
		return "Guest"
	end
end


local player = getLocalPlayer ( )
local cTimer = { }
local label = nil

function onUserClick ( points, achievements, account, player )
    local player = getPlayerFromName ( guiGridListGetItemText( gridList, guiGridListGetSelectedItem( gridList ), 1 ) )
   -- if ( getElementData(player, "account") == true ) then
		if ( player ) then
			local timeSpent = getElementData ( player, 'timeSpent' ) or "Unknown"
			local country = getElementData ( player, 'Country' ) or "N/A"
			local gamemode = getElementData ( player, 'gamemode' ) or "None"
			local rank = getElementData ( player, 'auth' ) or 0
			local warnlevel = getElementData ( player, 'warning' ) or 0
			local account = getElementData ( player, "accountName" ) or 'not logged in'
			local points = getElementData ( player, "points" ) or 0
			local achievements = getElementData ( player, "achievements" ) or 0
			Animation.createAndPlay(label['account'], Animation.presets.guiFadeIn(300))
			Animation.createAndPlay(label['ping'], Animation.presets.guiFadeIn(300))
			Animation.createAndPlay(label['points'], Animation.presets.guiFadeIn(300))
			Animation.createAndPlay(label['timespent'], Animation.presets.guiFadeIn(300))
			Animation.createAndPlay(label['gamemode'], Animation.presets.guiFadeIn(300))
			Animation.createAndPlay(label['rank'], Animation.presets.guiFadeIn(300))
			Animation.createAndPlay(label['achievements'], Animation.presets.guiFadeIn(300))
			Animation.createAndPlay(label['country'], Animation.presets.guiFadeIn(300))
			Animation.createAndPlay(label['warnings'], Animation.presets.guiFadeIn(300))
			if guiGetAlpha ( label['please'] ) <= 0.5 then
				cancelEvent ( )
			else
				Animation.createAndPlay(label['please'], Animation.presets.guiFadeOut(300))
			end
			guiSetText ( label['country'], "Country: "..country )
			guiSetText ( label['timespent'], timeSpent and ("Time online: "..tostring(math.floor(timeSpent / 60)) .. " hours and " .. math.floor(timeSpent % 60) .. " minutes" ) )
			guiSetText ( label['ping'], "Ping: "..getPlayerPing ( player ) or "65536" )
			guiSetText ( label['rank'], "Rank: " .. rank )
			guiSetText ( label['warnings'], "Warn level: " .. warnlevel )
			guiSetText ( label['achievements'], "Achievements Unlocked: " .. achievements )
			guiSetText ( label['achievements'], "Achievements Unlocked: " .. points )
			guiSetText ( label['gamemode'], "Current Gamemode: " .. gamemode )
			guiSetText ( label['account'], "Account name: " .. account )
		else
			for i, v in pairs ( label ) do
				if guiGetAlpha ( v ) <= 0.1 then
					cancelEvent ( )
				else
					Animation.createAndPlay(label['account'], Animation.presets.guiFadeOut(300))
					Animation.createAndPlay(label['ping'], Animation.presets.guiFadeOut(300))
					Animation.createAndPlay(label['points'], Animation.presets.guiFadeOut(300))
					Animation.createAndPlay(label['timespent'], Animation.presets.guiFadeOut(300))
					Animation.createAndPlay(label['please'], Animation.presets.guiFadeIn(300))
					Animation.createAndPlay(label['achievements'], Animation.presets.guiFadeOut(300))
					Animation.createAndPlay(label['country'], Animation.presets.guiFadeOut(300))
					Animation.createAndPlay(label['gamemode'], Animation.presets.guiFadeOut(300))
					Animation.createAndPlay(label['rank'], Animation.presets.guiFadeOut(300))
					Animation.createAndPlay(label['warnings'], Animation.presets.guiFadeOut(300))
				end
			end
		end
	--else
		--cancelEvent ( )
	--end	
end


local g_Window = nil
function initializeWindow( )

	if g_Window then return end
	
	local screenWidth, screenHeight = guiGetScreenSize()
    windowWidth, windowHeight = 493, 445
    local left = screenWidth/2 - windowWidth/2
    local top = screenHeight/2 - windowHeight/2
    g_Window = {}
	label = {}
 
 
    g_Window.startTime = getTickCount()
    g_Window.startSize = {0, 0}
    g_Window.endSize = {windowWidth, windowHeight}
    g_Window.endTime = g_Window.startTime + 600
    addEventHandler("onClientRender", getRootElement(), popWindowUp)


    profileWindow = guiCreateWindow(screenWidth/2 - windowWidth/2, screenHeight/2 - windowHeight/2, windowWidth, windowHeight, "Information system", false)
    guiWindowSetSizable(profileWindow, false)
    guiWindowSetMovable(profileWindow, false)
    guiSetVisible ( profileWindow, false )
    label['account'] = guiCreateLabel(192,93,210,16, "Account name:", false, profileWindow)
    gridList = guiCreateGridList(14,53,159,371,false, profileWindow)
    column = guiGridListAddColumn( gridList, "Information",0.9)
    if ( column ) then
        loadPlayers()
    end
    guiGridListSetSelectionMode(gridList,2)
    label_player = guiCreateLabel(192,57,59,16,"Player:", false, profileWindow)
    guiLabelSetColor(label_player, 255, 0, 0)
    guiSetFont(label_player,"default-bold-small")
    label['country'] = guiCreateLabel(192,110,250,16,"Country:", false, profileWindow)
    label['ping'] = guiCreateLabel(192,130,250,16,"Ping: ", false, profileWindow)
    label['points'] = guiCreateLabel(192,150,250,16,"NPG Points: ", false,  profileWindow)
    label['timespent'] = guiCreateLabel(192,172,250,16,"Time online: ", false, profileWindow)
    label['achievements'] = guiCreateLabel(192,190,250,16,"Achievements Unlocked: ", false, profileWindow)
	label['gamemode'] = guiCreateLabel(192,210,250,16,"Current Gamemode: ", false, profileWindow)
    label['please'] = guiCreateLabel(192,230,300,16,"Please select a user", false, profileWindow)
	label['rank'] = guiCreateLabel(192,250,250,16,"Rank: ", false, profileWindow)
	label['warnings'] = guiCreateLabel(192,270,250,16,"Warning level: ", false, profileWindow)
    button_close = guiCreateButton(350,390,104,29,"Cancel",false, profileWindow )
    addEventHandler ( "onClientGUIClick", gridList, onUserClick, false )
end


function toggleWindow( )
	if not getPlayerGamemode ( player ) or limitTimer then return end
	limitTimer = setTimer(function()limitTimer=nil end, 500, 1)
	
	if isElement ( profileWindow ) then
		on_closeBtn_clicked ( )
		return
	end
		
	showCursor ( true )
	initializeWindow ( )
	
	loadPlayers()	
	
	if guiGridListGetSelectedItem( gridList ) == -1 then
		Animation.createAndPlay(label['please'], Animation.presets.guiFadeIn(300))
		guiSetAlpha(label['account'], 0)
		guiSetAlpha(label['ping'], 0)
		guiSetAlpha(label['points'], 0)
		guiSetAlpha(label['timespent'], 0)
		guiSetAlpha(label['achievements'], 0)
		guiSetAlpha(label['country'], 0)
		guiSetAlpha(label['gamemode'],0)
		guiSetAlpha(label['rank'], 0)
		guiSetAlpha(label['warnings'], 0)
	end
end
bindKey ( "f2", "down", toggleWindow )


function on_closeBtn_clicked(button, state, absoluteX, absoluteY)
 
    if not g_Window then return end
 
 	guiSetEnabled(profileWindow, false)
 	
    showCursor(false)
    guiWindowSetMovable(profileWindow, false)
 
    local screenWidth, screenHeight = guiGetScreenSize()
    local posX, posY = guiGetPosition(profileWindow, false)
 
    g_Window.startTime = getTickCount()
    g_Window.startSize = {windowWidth, windowHeight}
    g_Window.startCenter = 
    {
        posX + windowWidth/2,
        posY + windowHeight/2,
    }
 
    g_Window.endSize = {0, 0}
    g_Window.endTime = g_Window.startTime + 300
    g_Window.endCenter = 
    {
        screenWidth, 
        screenHeight
    }
 
    addEventHandler("onClientRender", getRootElement(), popWindowDown)
end


 
function popWindowUp()
    local now = getTickCount()
    local elapsedTime = now - g_Window.startTime
    local duration = g_Window.endTime - g_Window.startTime
    local progress = elapsedTime / duration
 
    local width, height, _ = interpolateBetween ( 
        g_Window.startSize[1], g_Window.startSize[2], 0, 
        g_Window.endSize[1], g_Window.endSize[2], 0, 
        progress, "OutElastic")
 
    guiSetSize(profileWindow, width, height, false)
	guiSetVisible(profileWindow, true)
 
    local screenWidth, screenHeight = guiGetScreenSize()
    guiSetPosition(profileWindow, screenWidth/2 - width/2, screenHeight/2 - height/2, false)
 
 
    if now >= g_Window.endTime then
        guiBringToFront(profileWindow)
        removeEventHandler("onClientRender", getRootElement(), popWindowUp)
		addEventHandler ( "onClientGUIClick", button_close, on_closeBtn_clicked, false )
        showCursor(true)
        guiWindowSetMovable(profileWindow, true)
    end
end
 
function popWindowDown()
    local now = getTickCount()
    local elapsedTime = now - g_Window.startTime
    local duration = g_Window.endTime - g_Window.startTime
    local progress = elapsedTime / duration
 
    local width, height, _ = interpolateBetween ( 
        g_Window.startSize[1], g_Window.startSize[2], 0, 
        g_Window.endSize[1], g_Window.endSize[2], 0, 
        progress, "InQuad")
 
    guiSetSize(profileWindow, width, height, false)
 
    if now >= g_Window.endTime then
        removeEventHandler("onClientRender", getRootElement(), popWindowDown)
		destroyElement(profileWindow)
        g_Window = nil
		label = nil
    end
end