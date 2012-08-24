addEvent ( "onClientPlayerGuiLoad", true )
addEvent ( "onClientPlayerLogin", true )

gui = { }
sw, sh = guiGetScreenSize ( )
player = getLocalPlayer ( )
resRoot = getResourceRootElement ( )
gmNames = { [-2]="Race", [-1]="Freeroam", [1]="Deathmatch", [2]="RolePlay" }
wp, hp = sw/800, sh/600
iconWidth = 96 * wp
iconHeight = 96 * hp
lang = true
languages = { [true]="English", [false]="Español" }
langs = { [true]="en", [false]="es" }
setElementData ( player, "language", languages[lang], true )

function getTextFromID ( id )
    local file = xmlLoadFile ( "language_texts.xml" )
	for i, v in ipairs ( xmlNodeGetChildren ( file ) ) do
	    if xmlNodeGetAttribute ( v, "id" ) == id then
		    return xmlNodeGetAttribute ( v, langs[lang] ), xmlUnloadFile ( file )
	    end
	end
	xmlUnloadFile ( file )
	return id
end

function guiGetActiveWindow ( )
    for i, v in ipairs ( gui ) do
	    if guiGetVisible ( v["wnd"] ) then return v["wnd"] end
	end
	return nil
end

--[[LANGUAGE PANEL]]--
	gui[1] = { }
	
	gui[1]["wnd"]  = guiCreateWindow ( sw/2 - 87.5, -90, 175, 90, "Language Select", false )
	gui[1]["text"] = guiCreateLabel  ( 10,  25, 155, 15, "Choose your Language", false, gui[1]["wnd"] )
	gui[1]["lang"] = guiCreateButton ( 10,  55, 80, 25, languages[lang], false, gui[1]["wnd"] )
	gui[1]["ok"]   = guiCreateButton ( 100, 55, 60, 25, "OK", false, gui[1]["wnd"] )
	
	guiLabelSetHorizontalAlign ( gui[1]["text"], "center", false )
	
	addEventHandler ( "onClientGUIClick", gui[1]["lang"],
	    function ( )
	        lang = not lang
			setElementData ( player, "language", languages[lang], true )
			guiSetText ( source, languages[lang] )
			guiSetText ( gui[1]["wnd"],   getTextFromID ( "text:wnd-lang" ) )
			guiSetText ( gui[1]["text"], getTextFromID ( "text:choose-lang" ) )
		end, false )
		
	addEventHandler ( "onClientGUIClick", gui[1]["ok"],
		function ( )
	        Animation.createAndPlay ( gui[1]["wnd"], Animation.presets.guiMove ( sw/2 - 87.5, -90, 750 ) )
	        Animation.createAndPlay ( gui[1]["wnd"], Animation.presets.guiFadeOut ( 500 ) )
			setTimer ( guiSetVisible, 550, 1, gui[1]["wnd"], false )
			triggerServerEvent ( "onPlayerSwitchGui", player )
			setTimer (
			    function ( )
			        guiSetText ( gui[2]["wnd"], getTextFromID ( "text:wnd-login" ) )
			        guiSetText ( gui[2]["text1"], getTextFromID ( "account" ) )
			        guiSetText ( gui[2]["text2"], getTextFromID ( "password" ) )
			        guiSetText ( gui[2]["text3"], getTextFromID ( "text:label-no-account" ) )
			        --guiSetText ( gui[2]["text4"], getTextFromID ( "text:label-miss-pass" ) )
			        guiSetText ( gui[2]["edit1"], getPlayerName ( player ) )
			        guiSetText ( gui[2]["ok"], getTextFromID ( "login" ) )
			        Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiMove ( sw/2 - 102.5, sh/2 - 112.5, 750 ) )
	                Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiFadeIn ( 750 ) )
			    end, 1750, 1 )
		end, false )
----------------------

--[[LOGIN PANEL]]--
	gui[2] = { }
	
    gui[2]["wnd"] = guiCreateWindow  ( sw/2 - 102.5, -170, 550, 382, "", false )
	gui[2]["text1"] = guiCreateLabel ( 76,143,60,20, "", false, gui[2]["wnd"] )
	gui[2]["text2"] = guiCreateLabel ( 76,189,60,20, "", false, gui[2]["wnd"] )
	gui[2]["text3"] = guiCreateLabel ( 10, 85,  180, 20, "", false, gui[2]["wnd"] )
	gui[2]["text4"] = guiCreateLabel ( 10, 105, 180, 20, "", false, gui[2]["wnd"] )
	gui[2]["edit1"] = guiCreateEdit  ( 135,136,210,36, "", false, gui[2]["wnd"] )
	gui[2]["edit2"] = guiCreateEdit  ( 135, 126, 210, 36, "", false, gui[2]["wnd"] )
	gui[2]["ok"] = guiCreateButton   ( 10, 135, 180, 25, "", false, gui[2]["wnd"] )
	
	guiEditSetMaxLength ( gui[2]["edit1"], 22 )
	guiEditSetMaxLength ( gui[2]["edit2"], 30 )
	guiLabelSetVerticalAlign ( gui[2]["text1"], "center" )
	guiLabelSetVerticalAlign ( gui[2]["text2"], "center" )
	addEventHandler ( "onClientPlayerFailLogin", player, function ( errorMessage ) outputError ( getTextFromID ( errorMessage ), 3000 ) end )
	for i = 3, 4 do
	    addEventHandler ( "onClientMouseEnter", gui[2]["text"..tostring ( i )], function ( ) guiLabelSetColor ( source, 0, 255, 0 ) end, false )
		addEventHandler ( "onClientMouseLeave", gui[2]["text"..tostring ( i )], function ( ) guiLabelSetColor ( source, 255, 255, 255 ) end, false )
	end
	
	addEventHandler ( "onClientGUIClick", gui[2]["ok"],
        function ( )
		    local name = guiGetText ( gui[2]["edit1"] )
			local pass = guiGetText ( gui[2]["edit2"] )
			if name ~= "" and pass ~= "" then triggerServerEvent ( "onPlayerTryLogin", player, name, pass )
			else outputError ( getTextFromID ( "error:no-name-pass" ), 3000 ) end
		end, false )
		
	addEventHandler ( "onClientGUIClick", gui[2]["text3"],
        function ( )
		    Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiMove ( sw/2 - 102.5, -170, 750 ) )
	        Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiFadeOut ( 500 ) )
			setTimer ( guiSetVisible, 750, 1, gui[2]["wnd"], false )
			setTimer (
			    function ( )
			        guiSetText ( gui[3]["wnd"], getTextFromID ( "text:wnd-register" ) )
			        guiSetText ( gui[3]["text1"], getTextFromID ( "account" ) )
			        guiSetText ( gui[3]["text2"], getTextFromID ( "password" ) )
			        guiSetText ( gui[3]["text3"], getTextFromID ( "confirm" ) )
			        guiSetText ( gui[3]["edit1"], getPlayerName ( player ) )
			        guiSetText ( gui[3]["no"], getTextFromID ( "cancel" ) )
			        guiSetText ( gui[3]["ok"], getTextFromID ( "register" ) )
				    guiSetVisible ( gui[3]["wnd"], true )
			        Animation.createAndPlay ( gui[3]["wnd"], Animation.presets.guiMove ( sw/2 - 102.5, sh/2 - 85, 750 ) )
	                Animation.createAndPlay ( gui[3]["wnd"], Animation.presets.guiFadeIn ( 750 ) )
			    end, 1750, 1 )
		end, false )
		
	addEventHandler ( "onClientPlayerLogin", player,
	    function ( )
	        Animation.createAndPlay ( guiGetActiveWindow ( ), Animation.presets.guiMove ( sw/2 - 102.5, -170, 750 ) )
	        Animation.createAndPlay ( guiGetActiveWindow ( ), Animation.presets.guiFadeOut ( 500 ) )
			setTimer ( guiSetVisible, 750, 1, gui[2]["wnd"], false )
			setTimer (
			    function ( )
				    guiSetVisible ( gui[4]["text"], true )
					for i = -2, 2 do
	    				if i ~= 0 then
		  					Animation.createAndPlay ( gui[4]["button"..tostring(i)], Animation.presets.guiFadeIn ( 1500 ) )
						end
					end
			    end, 3000, 1 )
	    end )
-------------------

--[[REGISTER PANEL]]--
    gui[3] = { }
	
	gui[3]["wnd"] = guiCreateWindow ( sw/2 - 102.5, -170, 205, 150, "", false )
	gui[3]["text1"] = guiCreateLabel ( 10, 25, 65, 20, "", false, gui[3]["wnd"] )
	gui[3]["text2"] = guiCreateLabel ( 10, 55, 65, 20, "", false, gui[3]["wnd"] )
	gui[3]["text3"] = guiCreateLabel ( 10, 85, 65, 20, "", false, gui[3]["wnd"] )
	gui[3]["edit1"] = guiCreateEdit ( 85, 25, 120, 20, "", false, gui[3]["wnd"] )
	gui[3]["edit2"] = guiCreateEdit ( 85, 55, 120, 20, "", false, gui[3]["wnd"] )
	gui[3]["edit3"] = guiCreateEdit ( 85, 85, 120, 20, "", false, gui[3]["wnd"] )
	gui[3]["no"] = guiCreateButton ( 110, 115, 80, 25, "", false, gui[3]["wnd"] )
	gui[3]["ok"] = guiCreateButton ( 10,  115, 80, 25, "", false, gui[3]["wnd"] )
	
	
	for i = 1, 3 do
	    guiLabelSetVerticalAlign ( gui[3]["text" .. tostring ( i )], "center" )
	    if i ~= 1 then guiEditSetMaxLength ( gui[3]["edit" .. tostring ( i )], 30 ) end
	end
	guiEditSetMaxLength ( gui[3]["edit1"], 22 )
	addEventHandler ( "onClientPlayerFailRegister", player, function ( errorMessage ) outputError ( getTextFromID ( errorMessage ), 3000 ) end )
	
	addEventHandler ( "onClientGUIClick", gui[3]["no"],
        function ( )
		    Animation.createAndPlay ( gui[3]["wnd"], Animation.presets.guiMove ( sw/2 - 102.5, -170, 750 ) )
	        Animation.createAndPlay ( gui[3]["wnd"], Animation.presets.guiFadeOut ( 500 ) )
			setTimer ( guiSetVisible, 750, 1, gui[3]["wnd"], false )
			setTimer (
			    function ( )
			        guiSetText ( gui[2]["edit1"], getPlayerName ( player ) )
				    guiSetVisible ( gui[2]["wnd"], true )
			        Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiMove ( sw/2 - 102.5, sh/2 - 112.5, 750 ) )
	                Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiFadeIn ( 750 ) )
			    end, 1750, 1 )
		end, false )
	
	addEventHandler ( "onClientGUIClick", gui[3]["ok"],
        function ( )
		    local name  = guiGetText ( gui[3]["edit1"] )
			local pass1 = guiGetText ( gui[3]["edit2"] )
			local pass2 = guiGetText ( gui[3]["edit3"] )
			if name ~= "" and pass1 ~= "" and pass2 ~= "" then
			    if pass1 == pass2 then triggerServerEvent ( "onPlayerTryRegister", player, name, pass1 )
			    else outputError ( getTextFromID ( "error:different-passwords" ), 3000 ) end
			else outputError ( getTextFromID ( "error:no-name-pass" ), 3000 ) end
		end, false )
----------------------

--[[GAMEMODE SELECTOR]]--
    gui[4] = { }
	
    gui[4]["text"] = guiCreateLabel ( (sw / 2) - (250 * wp), sh * 0.7, 500 * wp, 100 * wp, "", false )
	guiLabelSetHorizontalAlign ( gui[4]["text"], "center" )
	guiLabelSetVerticalAlign ( gui[4]["text"], "center" )
	guiSetFont ( gui[4]["text"], "default-bold-small" )
	guiLabelSetColor ( gui[4]["text"], 255, 255, 255 )
	for i = -2, 2 do
	    if i ~= 0 then
		    gui[4]["button"..tostring(i)] = guiCreateStaticImage ( (sw / 2) + (i * (iconWidth * 1.25 * wp)) - (iconWidth / 2), (sh / 2) - (iconHeight / 2), iconWidth, iconHeight, "icons/"..gmNames[i]:lower ( )..".png", false )
	        local button = gui[4]["button"..tostring(i)]
			guiSetAlpha ( button, 0 )
			addEventHandler ( "onClientMouseEnter", button,
			    function ( )
				    if guiGetAlpha ( source ) < 0.75 or not guiGetEnabled ( source ) then return end
				    Animation.createAndPlay ( source, Animation.presets.guiMoveResize ( (sw / 2) + (i * (iconWidth * 1.25 * wp)) - (iconWidth * 0.875), (sh / 2) - (iconHeight * 0.875), iconWidth * 1.75, iconHeight * 1.75, 100 ) )
				    guiSetText ( gui[4]["text"], gmNames[i] )
				end, false )
			addEventHandler ( "onClientMouseLeave",button,
			    function ( )
				    if guiGetAlpha ( source ) < 0.75 or not guiGetEnabled ( source ) then return end
				    Animation.createAndPlay ( source, Animation.presets.guiMoveResize ( (sw / 2) + (i * (iconWidth * 1.25 * wp)) - (iconWidth / 2), (sh / 2) - (iconHeight / 2), iconWidth, iconHeight, 100 ) )
				    guiSetText ( gui[4]["text"], "" )
				end, false )
			addEventHandler ( "onClientGUIClick", button,
			    function ( )
				    if guiGetAlpha ( source ) < 0.75 or not guiGetEnabled ( source ) then return end
					guiSetEnabled ( source, false )
					guiSetText ( gui[4]["text"], "" )
					for v = -2, 2 do
					    if v ~= 0 and v ~= i then
				            Animation.createAndPlay ( gui[4]["button"..tostring(v)], Animation.presets.guiMoveResize ( (sw / 2) + (i * (iconWidth * 1.25 * wp)), (sh / 2), 0, 0, 250 ) )
						    setTimer ( guiSetVisible, 250, 1, gui[4]["button"..tostring(v)], false )
						end
					end
					setTimer (
					    function ( button )
					        Animation.createAndPlay ( button, Animation.presets.guiMoveResize ( (sw / 2) - iconWidth, (sh / 2) - iconHeight, iconWidth * 2.5, iconHeight * 2.5, 250 ) )
						    setTimer ( guiSetPosition, 250, 1, button, (sw / 2) - iconWidth, (sh / 2) - iconHeight, false )
							setTimer ( guiSetSize, 250, 1, button, iconWidth * 2.5, iconHeight * 2.5, false )
					        triggerEvent ( "onClientPlayerSelectGamemode", player, gmNames[i]:lower ( ) )
						end, 500, 1, source )
					setTimer (
					    function ( button )
					        Animation.createAndPlay ( button, Animation.presets.guiFadeOut ( 250 ) )
					        setTimer ( guiSetVisible, 250, 1, button, false )
						end, 800, 1, source )
				end )
		end
	end
-------------------------



addEventHandler ( "onClientPlayerGuiLoad", player,
    function ( )
	    guiSetVisible ( gui[1]["wnd"], true )
        showCursor ( true )
        guiSetInputEnabled ( true )
	    Animation.createAndPlay ( gui[1]["wnd"], Animation.presets.guiMove ( sw/2 - 87.5, sh/2 - 57.5, 750 ) )
        Animation.createAndPlay ( gui[1]["wnd"], Animation.presets.guiFadeIn ( 750 ) )
	end )

triggerServerEvent ( "onGuiRequest", player )

for i, v in ipairs ( gui ) do
    if type ( v ) ~= "table" then return end
    guiSetAlpha   ( v["wnd"], 0 )
    guiSetVisible ( v["wnd"], 0 )
    guiWindowSetMovable ( v["wnd"], false )
    guiWindowSetSizable ( v["wnd"], false )
end

addEventHandler ( "onClientPlayerSpawn", player,
    function ( )
		for i, v in ipairs ( gui ) do
    		if type ( v ) ~= "table" then return end
    		guiSetVisible ( v["wnd"], false )
		end
	    guiSetInputEnabled ( false )
	    showCursor ( false )
		outputChatBox ( "GENERAL: isCursorShowing: "..tostring (isCursorShowing()) )
	end )
