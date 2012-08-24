--[[REGISTER PANEL]]--

addEvent ( "onClientPlayerFailRegister", true )

gui[3] = {}

gui[3]["wnd"] = guiCreateWindow ( sw/2 - 152.5, sh/2 - 170, 298, 260, "", false )
gui[3]["text1"] = guiCreateLabel ( 20, 45, 65, 20, "", false, gui[3]["wnd"] )
gui[3]["text2"] = guiCreateLabel ( 20, 85, 65, 20, "", false, gui[3]["wnd"] )
gui[3]["text3"] = guiCreateLabel ( 20, 125, 65, 20, "", false, gui[3]["wnd"] )
gui[3]["text4"] = guiCreateLabel ( 20, 165, 65, 20, "", false, gui[3]["wnd"] )
gui[3]["edit1"] = guiCreateEdit ( 100, 45, 130, 20, "", false, gui[3]["wnd"] )
gui[3]["edit2"] = guiCreateEdit ( 100, 85, 130, 20, "", false, gui[3]["wnd"] )
gui[3]["edit3"] = guiCreateEdit ( 100, 125, 130, 20, "", false, gui[3]["wnd"] )
gui[3]["edit4"] = guiCreateEdit ( 100, 165, 130, 20, "", false, gui[3]["wnd"] )
gui[3]["no"] = guiCreateButton ( 170, 213, 80, 25, "", false, gui[3]["wnd"] )
gui[3]["ok"] = guiCreateButton ( 40,  213, 80, 25, "", false, gui[3]["wnd"] )

guiWindowSetMovable ( gui[3]["wnd"], false )
guiWindowSetSizable ( gui[3]["wnd"], false )
guiEditSetMasked( gui[3]["edit2"], true )
guiEditSetMasked( gui[3]["edit3"], true )

for i = 1, 3 do
	guiLabelSetVerticalAlign ( gui[3]["text" .. tostring ( i )], "center" )
	if i ~= 1 then
		guiEditSetMaxLength(gui[3]["edit" .. tostring ( i )], 30)
	end
end
guiEditSetMaxLength ( gui[3]["edit1"], 22 )

function showRegistrationWindow()
	guiSetText ( gui[3]["wnd"], "Register Account" )
	guiSetText ( gui[3]["text1"], __("Account") )
	guiSetText ( gui[3]["text2"], __("Password") )
	guiSetText ( gui[3]["text3"], __("Confirm") )
	guiSetText ( gui[3]["text4"], __("E-mail") )
	guiSetText ( gui[3]["no"], __("Cancel") )
	guiSetText ( gui[3]["ok"], __("Continue") )
	guiSetVisible(gui[3]["wnd"], true )
	Animation.createAndPlay ( gui[3]["wnd"], Animation.presets.guiFadeIn ( 500 ) )
end

addEventHandler ( "onClientGUIClick", gui[3]["no"],	function()
		Animation.createAndPlay( gui[3]["wnd"], Animation.presets.guiFadeOut(500) )
		setTimer( guiSetVisible, 750, 1, gui[3]["wnd"], false)
		setTimer(
			function()
				guiSetText( gui[2]["edit1"], getPlayerName(player) )
				guiSetVisible ( gui[2]["wnd"], true )
				Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiFadeIn ( 750 ) )
			end
		, 1750, 1)
	end
, false)

addEventHandler("onClientGUIClick", gui[3]["ok"], 
function()
		local name  = guiGetText ( gui[3]["edit1"] )
		local pass1 = guiGetText ( gui[3]["edit2"] )
		local pass2 = guiGetText ( gui[3]["edit3"] )
		local email = guiGetText ( gui[3]["edit4"] )
		if name ~= "" and pass1 ~= "" and pass2 ~= "" then
			if pass1 == pass2 then
				if email ~="" then
					triggerServerEvent ( "onPlayerTryRegister", player, name, pass1, email)
				else
					outputError ( __("no-mail"), 3000 )
				end
			else
				outputError ( __("Passwords mismatch"), 3000 )
			end
		else
			outputError ( __("error:no-name-pass"), 3000 )
		end
end, false )

addEventHandler ( "onClientPlayerFailRegister", player, function(m)
		outputError ( __(m), 3000 ) 
	end
)