-- ///////////////////////////////////////////////
-- / NPG - General                               /
-- / Written by NPG Team  (c) 2011               /
-- ///////////////////////////////////////////////

-- WHEHEHE ORANJE CODE
function __( ... )
	return exports.npg_lang:__( ... );
end

function isPlayerLogged(thePlayer)
local theAccount = getElementData(thePlayer, "account")
	if theAccount == false then
		return false
	else
		return true
	end
end


-- lol now we got the other code

addEvent ( "onClientPlayerGuiLoad", true )
addEvent ( "onClientPlayerFirstJoin", true )
addEvent ( "onClientPlayerGuiGMLoad", true )
addEvent ( "onClientPlayerSet", true )
addEvent ( "onClientPlayerGamemodeLeave", true ) 


gui = { }
sw, sh = guiGetScreenSize()
player = getLocalPlayer()
gmNames = {
	[-2]= {"Manhunt", true},
	[-1]= {"Freeroam",true},
	[0]= {"Race",true},
	[1]= {"King Of The Hill", true},
	[2]= {"RPG", true}
}
wp, hp = sw/1024, sh/768
iconWidth, iconHeight = 96 * wp, 96 * hp
actualLanguage = 0
langFlags = {
	[-2] = {"Dutch", true, "nl"},
	[-1]={"Croatian", true, "hr"},
	[0]={"English", true, "en"},
	[1]={"Spanish", true, "es"},
	[2]={"Polish", true, "pl"}
}

font = guiCreateFont( "FortuneCity.ttf", 20 )
errorLabel = guiCreateLabel  ( 0, sh * 0.9, sw, 45, "", false )
guiLabelSetHorizontalAlign ( errorLabel, "center" )
guiSetAlpha ( errorLabel, 0 )
guiSetFont ( errorLabel, guiCreateFont ( "FortuneCity.ttf", 20 ) )

function outputError ( text, time )
    if type ( text ) == "string" and text ~= "" and type ( time ) == "number" and time > 750 and guiGetText ( errorLabel ) == "" then
        guiSetText ( errorLabel, text )
		Animation.createAndPlay ( errorLabel, Animation.presets.guiFadeIn ( 250 ) )
		setTimer (
		    function ( )
			    Animation.createAndPlay ( errorLabel, Animation.presets.guiFadeOut ( 250 ) )
                setTimer ( guiSetText, 300, 1, errorLabel, "" )
			end, 250 + time, 1 )
		return true
	end
	return false
end

addEventHandler ( "onClientPlayerGuiLoad", player, function() 
        showCursor(true)
        guiSetInputEnabled(true)
		setTimer(languageMenuShow, 2000, 1)
	end
)	

addEventHandler ( "onClientPlayerGuiGMLoad", player, function() 
        showCursor(true)
        guiSetInputEnabled(true)
		setTimer(
			function()
				eventGamemode ( )
			end
		, 2000, 1)
	end
)		


	
addEventHandler("onClientPlayerSpawn", player, function()
		for _, v in ipairs(gui) do
    		if type(v) == "table" then
				guiSetVisible(gui[1]["text"], false)
			end
		end
	    guiSetInputEnabled ( false )
	    showCursor ( false )
		if getElementData(player, "gamemode") then -- IF PLAYER CHOSE A GAMEMODE
			guiSetVisible ( errorLabel, false )
			showChat ( true )
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot, function()
		for i, v in ipairs ( gui ) do
			if i ~= 4 then
				if v["wnd"] then
					guiSetAlpha   ( v["wnd"], 0 )
					guiSetVisible ( v["wnd"], false )
					guiSetProperty ( v["wnd"], "AlwaysOnTop", "True" )
				end
				if v["text"] then
					guiSetProperty ( v["text"], "AlwaysOnTop", "True" )
				end
			end
		end
		
		-- Language Flag HACK?
		for i= -2, 2 do
			guiBringToFront(gui[1]["button"..tostring(i)])
		end
		
		if not getElementData( player, 'gamemode' ) then -- STUFF TO DO IF A PERSON HASNT CHOSEN A GAMEMODE YET
			setCameraMatrix( 12.879754066467, -130.16979980469, 14.660760879517, 3.9294919967651, -228.72940063477, 0.31169033050537, 0, 70 )
			setElementData ( player, "language", "en", true )
			exports.npg_textactions:sendMessage('Welcome to Neo Playgrounds')
		end
	end
)

addEventHandler ( "onClientPlayerSet", root, function()
	guiSetInputEnabled ( false )
	showChat ( false )
end
)

addEventHandler( "onClientPlayerGamemodeLeave", root, 
	function( gamemode ) 
	end)

triggerServerEvent ( "onGuiRequest", player )