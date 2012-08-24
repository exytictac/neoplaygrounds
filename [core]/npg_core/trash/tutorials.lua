
--[[CLIENT TUTORIALS]]--
addEvent ( "onClientGuide", true )

local screenWidth, screenHeight = guiGetScreenSize()
local windowWidth, windowHeight = 74, 96
local left = screenWidth/22 - windowWidth/22
local top = screenHeight/45 - windowHeight/45
local down = screenHeight/0.5 - windowHeight/0.5
local center = screenHeight/2 - windowHeight/2


gui[6] = {}
gui[6]["image"] = guiCreateStaticImage ( sw/2 - 240.5, top/2 ,windowWidth, windowHeight, "images/tutorial.png", false )
gui[6]["label"] = guiCreateLabel ( 8,3,460,88,"",false, gui[6]["image"] )
guiSetFont ( gui[6]["label"], font )
guiLabelSetColor ( gui[6]["label"], 0, 0, 0 )
guiSetVisible ( gui[6]["image"], false )

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
   
    guiSetSize(image, labelWidth + 15, labelHeight + 15, false )
    guiLabelSetHorizontalAlign( label, "center", true )
	guiLabelSetVerticalAlign( label, "center" )
end




addEventHandler("onClientGuide", player,
	function ()
		if guiGetVisible ( gui[2]["wnd"] or gui[3]["wnd"] ) then
			setTimer ( guiSetVisible, 500, 1, gui[2]["wnd"], false )
			setTimer ( guiSetVisible, 500, 1, gui[3]["wnd"], false )
			Animation.createAndPlay ( gui[2]["wnd"], Animation.presets.guiFadeOut ( 500 ) )
			Animation.createAndPlay ( gui[3]["wnd"], Animation.presets.guiFadeOut ( 500 ) )
		end
		guiSetVisible ( gui[6]["image"], true )
		if (Animation.createAndPlay ( gui[6]["image"], Animation.presets.guiFadeIn ( 750  ) ) ) then
			guiSetText ( gui[6]["label"], __("general:welcome").."\n"..getPlayerName(player))
			setTimer ( guiSetVisible, 750, 1, gui[6]["image"], true )
			setImageSizeLabel(gui[6]["image"], gui[6]["label"])
			setTimer( move, 3000, 1)
			showCursor ( false )
		end 
	end
)



function move()
	Animation.createAndPlay ( gui[6]["image"], Animation.presets.guiFadeOut ( 750 ) )
	setTimer ( guiSetVisible, 750, 1, gui[6]["image"], false )
	setTimer ( move1, 2000, 1 )
end


gui[6]["image1"] = guiCreateStaticImage ( sw/2 - 240.5, top/2,404,36, "images/tutorial.png", false )
gui[6]["label1"] = guiCreateLabel ( 8,3,560,88,"",false, gui[6]["image1"] )
guiSetFont ( gui[6]["label1"], font )
guiLabelSetColor ( gui[6]["label1"], 0, 0, 0 )
guiSetVisible ( gui[6]["image1"], false )

function move1()
	if ( Animation.createAndPlay ( gui[6]["image1"], Animation.presets.guiFadeIn ( 750 ) ) ) then
			setTimer ( function ()
				setTimer ( guiSetText, 500, 1, gui[6]["label1"], __("general:intro2" ).."." )
				setTimer ( guiSetText, 750, 1, gui[6]["label1"], __("general:intro2" )..".." )
				setTimer ( guiSetText, 1000, 1, gui[6]["label1"], __("general:intro2" ).."..." )
			end, 1000, 7 )
			setImageSizeLabel(gui[6]["image1"], gui[6]["label1"])
			setTimer ( guiSetVisible, 50, 1, gui[6]["image1"], true )
			setTimer ( move2, 7000, 1 )
	end
end



function move2()
	Animation.createAndPlay ( gui[6]["image1"], Animation.presets.guiFadeOut ( 750 ) )
	setTimer ( guiSetVisible, 750, 1, gui[6]["image1"], false )
	triggerServerEvent ( "onPlayerReadRules", player )
end

