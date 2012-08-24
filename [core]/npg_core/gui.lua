-- ***********************************************
-- * NPG - Core - gui.lua                    *
-- * Written by NPG Team  (c) 2011-2012               *
-- ***********************************************

-- yay oranges c00l stuff
function __( ... )
	return exports.npg_lang:__( ... );
end
--loadstring(exports.openframe:load())()

--sphaggette code

--[[CUSTOM EVENTS]]--
addEvent ( "onClientPlayerSelectGamemode", true )
addEvent ( "onClientPlayerSelectCharacter", true )
---------------------

--[[GLOBAL GUI VARIABLES]]--
local gui = { }
player = getLocalPlayer ( )
index = nil

font = guiCreateFont( "FortuneCity.ttf", 17 )

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

------------------------
local sw, sh = guiGetScreenSize()
local windowWidth, windowHeight = 74, 96
local left = sw/22 - windowWidth/22
local top = sh/45 - windowHeight/45
local down = sh/0.5 - windowHeight/0.5
local center = sh/2 - windowHeight/2


gui[3] = {}
gui[3]["image"] = guiCreateStaticImage ( sw/2 - 240.5, top/2 ,windowWidth, windowHeight, "images/tutorial.png", false )
gui[3]["label"] = guiCreateLabel ( 8,3,460,130,"",false, gui[3]["image"] )
guiSetVisible ( gui[3]["image"], false )
guiSetFont ( gui[3]["label"], font )
guiLabelSetColor ( gui[3]["label"], 0, 0, 0 )

addEventHandler ( "onClientPlayerSelectGamemode", player,
    function ( gm )
		triggerEvent ( "onClientPlayerTextLoad", player )
		triggerServerEvent ( "onGamemodeLeave", player )
	    setTimer ( function ( )if gm == "rpg" then 
			setTimer ( triggerEvent, 1000, 1, "onClientRPGEnter", player )
		elseif gm == "freeroam" then
			exports.npg_freeroam:loadFreeroam()
			triggerServerEvent ( "onFreeroamEnter", player )
		elseif gm == "race" then
			triggerServerEvent ( "onPlayerRaceEnter", player )
		end end, 100, 1 )
	end
)



------------------
-- Center strip --
------------------
local drawingStrip = false
local function drawStrip()
	dxDrawRectangle(0, 437, sw, 148, tocolor(0, 0, 0, 127), false)
end
function showCenterStrip()
	if drawingStrip then return end
	drawingStrip = not drawingStrip
	addEventHandler('onClientRender', root, drawStrip)
end
function hideCenterStrip()
	if not drawingStrip then return end
	drawingStrip = not drawingStrip
	removeEventHandler('onClientRender', root, drawStrip)
end