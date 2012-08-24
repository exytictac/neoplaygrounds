-- ***********************************************
-- * NPG - Core - gui.lua                    *
-- * Written by NPG Team  (c) 2011               *
-- ***********************************************
function __( ... )
	return exports.npg_lang:__( ... );
end

--[[CUSTOM EVENTS]]--
addEvent ( "onClientPlayerSelectGamemode", true )
addEvent ( "onClientPlayerSelectCharacter", true )
---------------------

--[[GLOBAL GUI VARIABLES]]--
gui = { }
windowWidth, windowHeight = 340, 126
sw, sh = guiGetScreenSize ( )
player = getLocalPlayer ( )
resRoot = getResourceRootElement ( )
myped = nil
index = nil
languages = { [true]="English", [false]="Español" }
langs = { [true]="en", [false]="es" }
languages2 = { ["English"]="en", ["Español"]="es" }
down = sh/0.5 - windowHeight/0.5
center = sh/2 - windowHeight/2
font = guiCreateFont( "FortuneCity.ttf", 17 )
------------------

--[[FUNCTIONS]]--
function getTextFromID ( id )
    local file = xmlLoadFile ( "language_texts.xml" )
	for i, v in ipairs ( xmlNodeGetChildren ( file ) ) do
	    if xmlNodeGetAttribute ( v, "id" ) == id then
		    local result = xmlNodeGetAttribute ( v, languages2[getElementData ( player, "language" )] )
			xmlUnloadFile ( file )
		    return result
	    end
	end
	xmlUnloadFile ( file )
	return id
end

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

function guiGetActiveWindow ( )
    for i, v in ipairs ( gui ) do
	    if guiGetVisible ( v["wnd"] ) then return v["wnd"] end
	end
	return nil
end

-----------------

--[[ERROR LABEL]]--
errorLabel = guiCreateLabel  ( sw/2 - 200, sh * 0.9, 400, 15, "", false )
guiLabelSetHorizontalAlign ( errorLabel, "center" )
guiSetAlpha ( errorLabel, 0 )
-------------------

--[[GUI CHARACTERS PANEL 1
    gui[1] = { }
    
	gui[1]["wnd"] = guiCreateWindow ( sw, sh/2 - 67.5, 150, 135, "", false )
	gui[1]["slot1"] = guiCreateButton ( 10, 25, 125, 25, "", false, gui[1]["wnd"] )
	gui[1]["slot2"] = guiCreateButton ( 10, 60, 125, 25, "", false, gui[1]["wnd"] )
	gui[1]["slot3"] = guiCreateButton ( 10, 95, 125, 25, "", false, gui[1]["wnd"] )
	for i = 1,3 do
	    addEventHandler ( "onClientGUIClick", gui[1]["slot"..tostring ( i )],
            function ( )
			    for i = 1, 3 do
				    local b = gui[1]["slot"..tostring ( i )]
				    if b == source then
					    guiSetEnabled ( b, false )
						index = i
				        triggerServerEvent ( "onPlayerSelectCharacter", player, index )
					else guiSetEnabled ( b, true ) end
				end
				if not guiGetVisible ( gui[2]["wnd"] ) then
				    guiSetVisible ( gui[2]["wnd"], true )
				    Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiMove ( 15, sh/2 - 72.5, 500 ) )
                    Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiFadeIn ( 500 ) )
				end
			end, false )
	end]]--
	
------------------------------






--[[GUI CHARACTERS PANEL 2
    gui[2] = { }
    
	gui[2]["wnd"] = guiCreateWindow ( center, down/2,windowWidth,windowHeight,"Choose a skin!",false )
	gui[2]["button1"] = guiCreateButton ( 0.06,0.60,0.15,0.30, "<", true, gui[2]["wnd"] )
	gui[2]["button2"] = guiCreateButton ( 0.78,0.60,0.15,0.30,">",true, gui[2]["wnd"] )
	gui[2]["ok"] = guiCreateButton ( 0.41, 0.60, 0.15, 0.30, "Pick", true, gui[2]["wnd"])
	addEventHandler ( "onClientGUIClick", gui[2]["ok"],
        function ( )
			Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiMove ( -100, sh/2 - 72.5, 500 ) )
            Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiFadeOut ( 500 ) )
			Animation.createAndPlay ( gui[1]["wnd"], Animation.presets.guiMove ( sw, sh/2 - 72.5, 500 ) )
            Animation.createAndPlay ( gui[1]["wnd"], Animation.presets.guiFadeOut ( 500 ) )
			myped = createPed ( player, 1685.7, -2333.3, 13.2 )
			addEventHandler ( "onClientGUIClick",gui[2]["button1"],switchLeft, source, false )
			addEventHandler ( "onClientGUIClick",gui[2]["button2"],switchRight, source, false ) 
			triggerServerEvent ( "onPlayerChooseCharacter", player, index )
			for i, v in ipairs ( gui ) do guiSetVisible ( v["wnd"], false ) end
			guiSetInputEnabled ( false )
			showCursor ( false )
		end, false )

	addEventHandler ( "onClientPlayerSelectCharacter", player,
	    function ( table )
		if myped then
			guiSetVisible(gui[2]["wnd"], false)
			end
		end )
		
		
function switchLeft(player)
			local leftSkin = getElementModel (player) - 1	
			while not setElementModel (player,leftSkin) do leftSkin = leftSkin - 1 end 	
end	


function switchRight(player)
			 local rightSkin = getElementModel (player) + 1
			 while not setElementModel (player,rightSkin) do rightSkin = rightSkin + 1 end
end		]]--	 
------------------------------



function setImageSizeLabel(image, label)
    if not isElement(image) or not isElement(label) then
        return false
    end
   
    local labelExtent, fontHeight = guiLabelGetTextExtent(label), guiLabelGetFontHeight(label)
    local labelWidth, labelHeight = guiGetSize(label, false)
    if labelExtent > labelWidth then
        labelWidth = labelExtent
    end
    if fontHeight > labelHeight then
        labelHeight = fontHeight
    end
   
    guiSetSize(image, labelWidth + 35, labelHeight + 65, false )
    guiLabelSetHorizontalAlign( label, "center", true )
	guiLabelSetVerticalAlign( label, "center" )
end


--[[GUI EXTRA CONFIG]]--
for i, v in ipairs ( gui ) do
    if type ( v ) ~= "table" then return end
    guiSetAlpha   ( v["wnd"], 0 )
    guiSetVisible ( v["wnd"], false )
    guiWindowSetMovable ( v["wnd"], false )
    guiWindowSetSizable ( v["wnd"], false )
end
------------------------
local screenWidth, screenHeight = guiGetScreenSize()
local windowWidth, windowHeight = 74, 96
local left = screenWidth/22 - windowWidth/22
local top = screenHeight/45 - windowHeight/45
local down = screenHeight/0.5 - windowHeight/0.5
local center = screenHeight/2 - windowHeight/2


gui[3] = {}
gui[3]["image"] = guiCreateStaticImage ( sw/2 - 240.5, top/2 ,windowWidth, windowHeight, "images/tutorial.png", false )
gui[3]["label"] = guiCreateLabel ( 8,3,460,130,"",false, gui[3]["image"] )
guiSetVisible ( gui[3]["image"], false )
guiSetFont ( gui[3]["label"], font )
guiLabelSetColor ( gui[3]["label"], 0, 0, 0 )

addEventHandler ( "onClientPlayerSelectGamemode", player,
    function ( gm )
	    if gm == "rpg" then 
			setImageSizeLabel(gui[3]["image"], gui[3]["label"])
			guiSetVisible( gui[3]["image"], true )
			guiSetText( gui[3]["label"], __("RPG") )
			showCursor( true )
			Animation.createAndPlay( gui[3]["image"], Animation.presets.guiFadeIn( 750 ) )
			setTimer( function()
					setTimer( guiSetVisible, 750, 1, gui[3]["image"], false )
					Animation.createAndPlay ( gui[3]["image"], Animation.presets.guiFadeOut( 750 ) )
					triggerServerEvent ( "onPlayerRPGRedirection", player )
				end
			, 10000, 1, source )
	end

)

addEventHandler ( "onClientPlayerSelectGamemode", player,
    function ( gm )
		if gm ~= "freeroam" then return end
				showPlayerHudComponent ( "all", true )
				call(getResourceFromName("npg_freeroam"), "tMap")
				setJetpackMaxHeight ( 9001 )
				if getElementData ( source, "general.rulesReaded" ) == false then
				call(getResourceFromName("npg_general"), "onServerGuide")
				triggerServerEvent ( "addFreeroamColumn", player )
		end
	end	
)



addEventHandler ( "onClientPlayerSelectGamemode", player,
	function ( gm )
		if gm~= "gungame" then return end
			triggerEvent ( "onGunGameStart", player )
		end
	)
gui[1] = {}
gui[1]["label"] = guiCreateLabel ( 0.1514, 0.1211, 0.6768, 0.2161, "", true )
guiSetVisible ( gui[1]["label"], false )
guiSetFont ( gui[1]["label"], guiCreateFont( "FortuneCity.ttf", 20 ) )
attrs = 0
local t1
local tmr

gui[2] = {}

gui[2]["race"] = guiCreateLabel ( sw/2 - 152.5, -170, 298, 230, "", false )
gui[2]["image2"] = guiCreateStaticImage(0.3664,0.2764,0.3508,0.0801,"images/tutorial.png",true)
gui[2]["label2"] = guiCreateLabel ( 8,3,460,85,"",false, gui[2]["image2"] )
guiSetVisible ( gui[2]["race"], false )
guiSetFont ( gui[2]["race"], guiCreateFont( "FortuneCity.ttf", 25 ) )
guiSetFont ( gui[2]["label2"], "default-normal" )
guiSetVisible ( gui[2]["image2"], false )
	
function raceTimer ( )
    index = index - 1
    guiSetText ( gui[2]["race"],index )
    if index == 0 then
		killTimer ( tmr )
    end
end
		    
	
addEventHandler ( "onClientPlayerSelectGamemode", player,
		function ( gm )
			if gm ~= "race" then return end
				guiSetVisible ( gui[1]["label"], true )
				guiSetText ( gui[1]["label"], __("Race") )
				Animation.createAndPlay ( gui[1]["label"], Animation.presets.guiFadeIn ( 1500 ) )
				triggerServerEvent ( "onPlayerRaceRedirection", player )
				addEventHandler ( "onClientKey", root, onPlayerClientKey )
			end
		)

		
		
function onPlayerClientKey( button, press )
        if press and button == "F1" and attrs == 0 then
				setImageSizeLabel(gui[2]["image2"], gui[2]["label2"])
                killTimer ( t1 )
				guiSetText ( gui[2]["label2"], __("Race") )
				guiSetVisible ( gui[2]["image2"], true )
				Animation.createAndPlay ( gui[2]["image2"], Animation.presets.guiFadeIn ( 1500 ) )
				guiSetVisible ( gui[2]["race"], true )
				Animation.createAndPlay ( gui[2]["race"], Animation.presets.guiFadeIn ( 1500 ) )
				index = 12
				tmr = setTimer ( raceTimer, 1000, index )
                attrs = 1
                guiSetText ( gui[1]["label"], __("Race-Go") )
                guiMoveToBack(gui[1]["label"])
                return
        elseif press and button == "n" and attrs == 1 then
				setTimer ( guiSetVisible, 1500, 1, gui[2]["image2"], false )
				Animation.createAndPlay ( gui[2]["image2"], Animation.presets.guiFadeOut ( 1500 ) )
                setTimer ( guiSetVisible, 1500, 1, gui[1]["label"], false )
                Animation.createAndPlay ( gui[1]["label"], Animation.presets.guiFadeOut ( 1500 ) )
				setTimer ( guiSetVisible, 1500, 1, gui[2]["race"], false )
				Animation.createAndPlay ( gui[2]["label"], Animation.presets.guiFadeOut ( 1500 ) )
                call ( getResourceFromName ( "npg_general" ), "onClientPlayerRedirectFromRace" )
                attrs = 0
                return
        end
        if  press and attrs == 1  then
				setTimer ( guiSetVisible, 1500, 1, gui[2]["race"], false )
				Animation.createAndPlay ( gui[2]["race"], Animation.presets.guiFadeOut ( 1500 ) )
                setTimer ( guiSetVisible, 1500, 1, gui[1]["label"], false )
                Animation.createAndPlay ( gui[1]["label"], Animation.presets.guiFadeOut ( 1500 ) )
                triggerServerEvent ( "onPlayerRaceEnter", player )
        end
end


addEventHandler ( "onClientPlayerSpawn", player,
    function ( )
		if getElementData(player, "gamemode") then 
			guiSetVisible ( errorLabel, false )
		end
	end
	)

