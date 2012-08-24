function __( ... )
	return exports.npg_lang:__( ... );
end


gui[5] = { }
gui[5]["wnd"] = guiCreateWindow ( (sw / 2) - 300, (sh / 2) - 250, 600, 500, "", false )
gui[5]["text"] = guiCreateMemo ( 0.01, 0.1, 0.98, 0.75, "", true, gui[5]["wnd"] )
gui[5]["button"] = guiCreateButton ( 0.78, 0.94, 0.2, 0.05, "", true, gui[5]["wnd"] )
guiWindowSetMovable ( gui[5]["wnd"], false )
guiWindowSetSizable ( gui[5]["wnd"], false )
guiMemoSetReadOnly ( gui[5]["text"], true )

function showRulesWindow( )
	guiSetVisible ( gui[5]["wnd"], true )
	guiSetText ( gui[5]["text"], __("Rules") )
	Animation.createAndPlay ( gui[5]["wnd"], Animation.presets.guiFadeIn ( 500 ) )
	guiSetText ( gui[5]["button"], __("button:rules") )
end

addEventHandler("onClientGUIClick", gui[5]["button"], function(b,s)
		if b~='left' or s~='up' then return end
		Animation.createAndPlay(
			gui[5]["wnd"],
			Animation.presets.guiFadeOut(500)
		)
		setTimer(guiSetVisible, 620, 1, gui[5]["wnd"], false)	
		--triggerEvent('onClientPlayerLogin', localPlayer, true)
		showLoginWindow()
	end
, false)
