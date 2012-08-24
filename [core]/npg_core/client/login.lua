-- LOGIN PANEL
local xmlrevision = '4a'
local xmlattr = {'pw','au','re','un'} -- PW=pass, AU=autologin, RE=revision, UN=username

local USERDATA = {}
USERDATA.r = xmlLoadFile('@localdata.npg')
if not USERDATA.r then
	USERDATA.r = xmlCreateFile('@localdata.npg', 'npg')
	for _,v in ipairs(xmlattr) do
		USERDATA[v] = xmlCreateChild(USERDATA.r, v)
	end
	xmlNodeSetValue(USERDATA.re, xmlrevision)
	xmlSaveFile(USERDATA.r)
else
	for _,v in ipairs(xmlattr) do
		USERDATA[v] = xmlFindChild(USERDATA.r, v, 0)
	end
	if USERDATA.re and xmlNodeGetValue(USERDATA.re)~=xmlrevision then
		xmlNodeSetValue(USERDATA.re, xmlrevision)
		for _,v in ipairs(xmlattr) do
			USERDATA[v] = USERDATA[v] or xmlCreateChild(USERDATA.r, v)
		end
		xmlSaveFile(USERDATA.r)
	end
end

addEvent ( "onClientPlayerLogin", true)
addEvent ( "onClientPlayerFailLogin", true )

gui[2] = { }
gui[2]["wnd"] = guiCreateWindow  ( sw/2 - 152.5, -170, 298, 230, "", false )
gui[2]["text1"] = guiCreateLabel ( 0.0738, 0.2087, 0.1711, 0.0826, "", true, gui[2]["wnd"] )
gui[2]["text2"] = guiCreateLabel ( 0.0738, 0.3652, 0.1812, 0.0826, "", true, gui[2]["wnd"] )
gui[2]["text3"] = guiCreateLabel ( 0.0738, 0.5174, 0.4698, 0.0696, "", true, gui[2]["wnd"] )
--gui[2]["text4"] = guiCreateLabel ( 10, 105, 180, 20, "", false, gui[2]["wnd"] )
do
	local _un = xmlNodeGetValue(USERDATA.un)
	_un = type(_un)=='string' and _un or ''
	gui[2]["edit1"] = guiCreateEdit(0.2819,0.2,0.6611,0.1043, _un=='' and getPlayerName(localPlayer) or _un,true,gui[2]["wnd"])
end
gui[2]["edit2"] = guiCreateEdit(0.2819,0.3522,0.6611,0.1043,xmlNodeGetValue(USERDATA.pw),true,gui[2]["wnd"])
gui[2]["ok"] = guiCreateButton(0.0302,0.8348,0.9396,0.0957,"",true,gui[2]["wnd"])
gui[2]['c1'] = guiCreateCheckBox(0.0705,0.6217,0.557,0.0696,"Save data",false,true,gui[2]["wnd"])
gui[2]['c2'] = guiCreateCheckBox(0.0705,0.7087,0.557,0.0696,"Log me in automatically",false,true,gui[2]["wnd"])

guiCheckBoxSetSelected ( gui[2]['c1'], tostring(xmlNodeGetValue(USERDATA.pw)) ~= "" )
guiCheckBoxSetSelected ( gui[2]['c2'], tostring(xmlNodeGetValue(USERDATA.au)) ~= "" )

guiWindowSetMovable ( gui[2]["wnd"], false )
guiWindowSetSizable ( gui[2]["wnd"], false )

guiEditSetMaxLength ( gui[2]["edit1"], 22 )
guiEditSetMaxLength ( gui[2]["edit2"], 30 )
guiEditSetMasked( gui[2]["edit2"], true)
guiLabelSetVerticalAlign ( gui[2]["text1"], "center" )
guiLabelSetVerticalAlign ( gui[2]["text2"], "center" )
	
local function iif(apply, ...)
	for _, v in pairs({...}) do
		if apply ~= v then
			return false
		end
	end
end

addEventHandler( "onClientMouseEnter", root, function()
		if (source == gui[2]["ok"]) then
			gui[2]["animok"] = Animation.createAndPlay(gui[2]['ok'], Animation.presets.guiResize(0.8396,0.0857, 300, false, 0.9396,0.0957, false ))
		elseif iif(source, gui[3]["ok"], gui[3]["no"]) then
			guiSetSize(source, 80, 30, false)
guiSetPosition(gui[2]["ok"],0.0302,0.8348, true )
		end
	end
)
	
addEventHandler( "onClientMouseLeave", root, function()
		if (source == gui[2]["ok"]) then
			if gui[2]['animok'] then
				gui[2]['animok']:remove(gui[2]['animok'])
			end
			guiSetSize(source,0.9396,0.0957, true)
guiSetPosition(gui[2]["ok"],0.0302,0.8348, true )
			guiSetPosition(source, 0.0302,0.8348, true)
		elseif iif(source, gui[3]["no"], gui[3]["ok"]) then
			guiSetSize(gui[3]["ok"], 80, 25, false)
		end
	end
)

addEventHandler("onClientPlayerFailLogin", player, function(errorMessage)
		outputError( __(errorMessage), 1500)
		if USERDATA._AUTO then
			showLoginWindow(true)
		end
	end
)

addEventHandler("onClientPlayerFailRegister", player, function(errorMessage)
		outputError( __(errorMessage), 3000)
	end
)

for i = 3, 3 do
	addEventHandler("onClientMouseEnter", gui[2]["text"..i], function()
			guiLabelSetColor ( source, 0, 255, 0 )
		end
	, false)
	
	addEventHandler("onClientMouseLeave", gui[2]["text"..i], function()
			guiLabelSetColor ( source, 255, 255, 255 )
		end
	, false )
end
	
addEventHandler ( "onClientGUIClick", gui[2]["ok"], function()
		local name = guiGetText ( gui[2]["edit1"] )
		local pass = guiGetText ( gui[2]["edit2"] )
		if name ~= "" and pass ~= "" then
			triggerServerEvent ( "onPlayerTryLogin", player, name, pass )
		else
			outputError ( __("error:no-name-pass"), 1500 )
		end
	end
, false)
	
addEventHandler("onClientGUIAccepted", root, function(edit)
		if edit ~= gui[2]["edit2"] then return end
		local name = guiGetText ( gui[2]["edit1"] )
		local pass = guiGetText ( gui[2]["edit2"] )
		if name ~= "" and pass ~= "" then
			triggerServerEvent ( "onPlayerTryLogin", player, name, pass )
		else
			outputError ( __("error:no-name-pass"), 1500 )
		end
	end
)
	
addEventHandler ( "onClientGUIClick", gui[2]["text3"], function()
		setTimer(showRegistrationWindow, 500, 1)
		setTimer ( guiSetVisible, 500, 1, gui[2]["wnd"], false )
		Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiFadeOut ( 500 ) )
	end
, false)

addEventHandler("onClientPlayerLogin", player, function (state)
	if guiGetVisible ( gui[3]['wnd'] ) then
			Animation.createAndPlay( gui[3]["wnd"], Animation.presets.guiFadeOut(500) )
			setTimer(guiSetVisible, 500, 1, gui[3]["wnd"], false)	
	end
		-- USER DETAILS SAVING
		if guiCheckBoxGetSelected ( gui[2]['c1'] ) then -- If save pass..
			local pass = guiGetText( gui[2]['edit2'] )
			local username = guiGetText( gui[2]['edit1'] )
			xmlNodeSetValue(USERDATA.pw, tostring(pass))
			xmlNodeSetValue(USERDATA.un, tostring(username))
			if guiCheckBoxGetSelected(gui[2]['c2']) then
				xmlNodeSetValue(USERDATA.au, '1')
			else
				xmlNodeSetValue(USERDATA.au, '')
			end
		end
		xmlSaveFile(USERDATA.r)
		
		showCursor ( true )
		guiSetInputEnabled ( false )
		Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiFadeOut ( 500 ) )
		Animation.createAndPlay ( gui[3]["wnd"], Animation.presets.guiFadeOut ( 500 ) )
		setTimer ( guiSetVisible, 500, 1, gui[3]["wnd"], false )
		setTimer ( guiSetVisible, 500, 1, gui[2]["wnd"], false )
		

		setTimer(eventGamemode, 1500, 1)
		

		--[[setTimer(
			function ()
				guiSetVisible ( gui[1]["text"], false )
				for i = -2, 2 do 
					setTimer ( guiSetVisible, 800, 1, gui[1]["button"..i], false )
					Animation.createAndPlay ( gui[1]["button"..i], Animation.presets.guiFadeOut ( 800 ) ) 
				end
			end
		, 1000, 1 )]]
end
)

function showLoginWindow(force)
	if xmlNodeGetValue(USERDATA.au)=='1' and not force then
		USERDATA._AUTO = true
		local name = guiGetText ( gui[2]["edit1"] )
		local pass = guiGetText ( gui[2]["edit2"] )
		if name ~= "" and pass ~= "" then
			triggerServerEvent ( "onPlayerTryLogin", player, name, pass )
		else
			outputError ( __("error:no-name-pass"), 1500 )
		end
	else
		guiSetText ( gui[2]["wnd"], "Login Window" )
		guiSetText ( gui[2]["text1"], __("Log in") )
		guiSetText ( gui[2]["text2"], __("Password" ) )
		guiSetText ( gui[2]["text3"], __("Register" ) )
		--guiSetText ( gui[2]["text4"], getTextFromID ( "text:label-miss-pass" ) )
		guiSetText ( gui[2]["ok"], __("Login") )
		guiSetVisible(gui[2]["wnd"], true)
		
		Animation.createAndPlay(gui[2]["wnd"],
			Animation.presets.guiMove(
				sw/2 - 152.5,
				sh/2 - 112.5,
				750
			)
		)
		Animation.createAndPlay(gui[2]["wnd"], Animation.presets.guiFadeIn(750) )
	end		
	showCursor(true)
end
		
						
