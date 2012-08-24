--[[
	RPG Jobs v2.0.1 [seeker.client]
	
	Made By: JR10
	
	Copyright (c) 2011
]]

local screenX , screenY = guiGetScreenSize ( )
local zoneName
local cityName

addEventHandler ( "onClientRender" , root ,
	function ( )
		local camX , camY , camZ = getCameraMatrix ( )
		if getDistanceBetweenPoints3D ( 1305.0126953125 , -1369.9697265625 , 14.868832397461 , camX , camY , camZ ) > 12 then
			return
		end
		local sX , sY = getScreenFromWorldPosition ( 1305.0126953125 , -1369.9697265625 , 14.868832397461 )
		if not sX then
			return
		end
		dxDrawFramedText ( "New Assignment" , sX , sY , sX , sY , tocolor ( 255 , 153 , 0 , 255 ) , ( screenX / 1440 ) * 2 , "default-bold" , "center" , "center" , false , false , false )
	end
)

addEventHandler ( "onClientResourceStart" , resourceRoot ,
	function ( )
		naGUI = build_naGUI ( )
	end
)

function build_naGUI()
	
	local gui = {}
	
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 422, 214
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "New Assignment", false)
	guiWindowSetSizable(gui["_root"], false)
	guiWindowSetMovable(gui["_root"], false)
	guiSetVisible(gui["_root"], false)
	
	gui["naInfoM"] = guiCreateMemo(10, 25, 401, 135, "Information:\n\nThe assignment is to find a briefcase.\n\nWhen you accept the assignment, you will see the briefcase for 5 seconds.\n\nIf you find it you get $", false, gui["_root"])
	guiMemoSetReadOnly(gui["naInfoM"], true)
	
	gui["naAcceptB"] = guiCreateButton(30, 175, 161, 31, "Accept", false, gui["_root"])
	if on_naAcceptB_clicked then
		addEventHandler("onClientGUIClick", gui["naAcceptB"], on_naAcceptB_clicked, false)
	end
	
	gui["naCancelB"] = guiCreateButton(230, 175, 161, 31, "Cancel", false, gui["_root"])
	if on_naCancelB_clicked then
		addEventHandler("onClientGUIClick", gui["naCancelB"], on_naCancelB_clicked, false)
	end
	
	return gui, windowWidth, windowHeight
end

function on_naAcceptB_clicked(button, state, absoluteX, absoluteY)
	if (button ~= "left") or (state ~= "up") then
		return
	end
	triggerServerEvent ( "server:startAssign" , localPlayer )
	guiSetVisible ( naGUI [ "_root" ] , false )
	showCursor ( false )
end

function on_naCancelB_clicked(button, state, absoluteX, absoluteY)
	if (button ~= "left") or (state ~= "up") then
		return
	end
	guiSetVisible ( naGUI [ "_root" ] , false )
	showCursor ( false )
end

addEvent ( "client:showNAGUI" , true )
addEventHandler ( "client:showNAGUI" , root ,
	function ( prize )
		guiSetText ( naGUI [ "naInfoM" ] , "Information:\n\nThe assignment is to find a briefcase.\n\nWhen you accept the assignment, you will see the briefcase for 5 seconds.\n\nIf you find it you get $" .. prize )
		guiSetVisible ( naGUI [ "_root" ] , true )
		showCursor ( true )
	end
)

addEvent ( "client:playCashSound" , true )
addEventHandler ( "client:playCashSound" , root ,
	function ( )
		playSound ( "cash.mp3" , false )
	end
)

addEvent ( "client:showLocation" , true )
addEventHandler ( "client:showLocation" , root ,
	function ( bool , zoneName2 , cityName2 )
		if bool then
			zoneName = zoneName2
			cityName = cityName2
			addEventHandler ( "onClientRender" , root , drawLocation )
		else
			removeEventHandler ( "onClientRender" , root , drawLocation )
		end
	end
)

function drawLocation ( )
	dxDrawFramedText ( zoneName .. " ( " .. cityName .. " )" , ( screenX / 1440 ) * 0 , ( screenY / 900 ) * 100 , ( screenX / 1440 ) * 1440 , ( screenY / 900 ) * 400 , tocolor ( 253 , 153 , 0 , 255 ) , ( screenX / 1440 ) * 2 , "default-bold" , "center" , "center" , false , false , false )
end