
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
			guiSetVisible ( gui[6]["image"], true )
			
			if (Animation.createAndPlay ( gui[6]["image"], Animation.presets.guiFadeIn ( 750  ) ) ) then
				guiSetText ( gui[6]["label"], __("general:welcome").."\n"..getPlayerName(player))
				setTimer ( guiSetVisible, 750, 1, gui[6]["image"], true )
				setImageSizeLabel(gui[6]["image"], gui[6]["label"])
				setTimer( move, 5000, 1)
				showCursor ( false )
		end 
	end
)



function move()
Animation.createAndPlay ( gui[6]["image"], Animation.presets.guiFadeOut ( 750 ) )
setTimer ( guiSetVisible, 750, 1, gui[6]["image"], false )
setTimer ( move1, 2000, 1 )
end


gui[6]["image1"] = guiCreateStaticImage ( sw/2 - 220, sh/2 - 59,404,36, "images/tutorial.png", false )
gui[6]["label1"] = guiCreateLabel ( 8,3,560,88,"",false, gui[6]["image1"] )
guiSetFont ( gui[6]["label1"], font )
guiLabelSetColor ( gui[6]["label1"], 0, 0, 0 )
guiSetVisible ( gui[6]["image1"], false )

function move1()
	if (Animation.createAndPlay ( gui[6]["image1"], Animation.presets.guiFadeIn ( 750 ) ) ) then
		guiSetText ( gui[6]["label1"], __("general:intro" ) )
			setImageSizeLabel(gui[6]["image1"], gui[6]["label1"])
			setTimer ( guiSetVisible, 50, 1, gui[6]["image1"], true )
			setTimer ( move2, 4000, 1 )
		end
	end



function move2()
		Animation.createAndPlay ( gui[6]["image1"], Animation.presets.guiFadeOut ( 750 ) )
		setTimer ( guiSetVisible, 750, 1, gui[6]["image1"], false )
		setTimer ( move3, 3000, 1 )
end



gui[6]["image2"] = guiCreateStaticImage ( left/2 , sh/2 - 59,404,196, "images/tutorial.png", false )
gui[6]["label2"] = guiCreateLabel ( 8,3,460,88,"",false, gui[6]["image2"] )
guiSetFont ( gui[6]["label2"], font )
guiLabelSetColor ( gui[6]["label2"], 0, 0, 0 )
guiSetVisible ( gui[6]["image2"], false )





function move3()
	if (Animation.createAndPlay ( gui[6]["image2"], Animation.presets.guiFadeIn ( 750 ) ) ) then
		guiSetText ( gui[6]["label2"], __("general:intro1") )
		setImageSizeLabel(gui[6]["image2"], gui[6]["label2"])
		setTimer ( guiSetVisible, 50, 1, gui[6]["image2"], true )
		setTimer ( move4, 4000, 1 )
		end
	end


function move4()
		Animation.createAndPlay ( gui[6]["image2"], Animation.presets.guiFadeOut ( 750 ) )
		setTimer ( guiSetVisible, 750, 1, gui[6]["image2"], false )
		setTimer ( move5, 5000, 1 )
end



gui[6]["image3"] = guiCreateStaticImage ( sw/2 - 240.5, sh/2 - 59,504,36, "images/tutorial.png", false )
gui[6]["label3"] = guiCreateLabel ( 8,3,490,88,"",false, gui[6]["image3"] )
guiSetFont ( gui[6]["label3"], font )
guiLabelSetColor ( gui[6]["label3"], 0, 0, 0 )
guiSetVisible ( gui[6]["image3"], false )



function move5()
	if (Animation.createAndPlay ( gui[6]["image3"], Animation.presets.guiFadeIn ( 750 ) ) ) then
		guiSetText ( gui[6]["label3"], __("general:intro2") )
		setImageSizeLabel(gui[6]["image3"], gui[6]["label3"])
		setTimer ( guiSetVisible, 50, 1, gui[6]["image3"], true )
		setTimer ( move6, 5000, 1 )
		end
	end


function move6()
		Animation.createAndPlay ( gui[6]["image3"], Animation.presets.guiFadeOut ( 750 ) )
		setTimer ( guiSetVisible, 750, 1, gui[6]["image3"], false )
		setTimer ( move7, 5000, 1 )
end




gui[6]["image4"] = guiCreateStaticImage ( sw/2 - 285.5, down/2 ,574,96, "images/tutorial.png", false )
gui[6]["label4"] = guiCreateLabel ( 8,3,560,88,"",false, gui[6]["image4"] )
guiSetFont ( gui[6]["label4"], font )
guiLabelSetColor ( gui[6]["label4"], 0, 0, 0 )
guiSetVisible ( gui[6]["image4"], false )





function move7()
	if (Animation.createAndPlay ( gui[6]["image4"], Animation.presets.guiFadeIn ( 750 ) ) ) then
		guiSetText ( gui[6]["label4"], __("general:intro3") )
		setImageSizeLabel(gui[6]["image4"], gui[6]["label4"])
		setTimer ( guiSetVisible, 50, 1, gui[6]["image4"], true )
		setTimer ( move8, 5000, 1 )
	end
end



function move8()
		Animation.createAndPlay ( gui[6]["image4"], Animation.presets.guiFadeOut ( 750 ) )
		setTimer ( guiSetVisible, 750, 1, gui[6]["image4"], false )
		setTimer(move9, 5000, 1 )
end



gui[6]["image5"] = guiCreateStaticImage ( sw/2 - 285.5, center/2 , 504, 36, "images/tutorial.png", false )
gui[6]["label5"] = guiCreateLabel ( 8,3,560,88,"",false, gui[6]["image5"] )
guiSetFont ( gui[6]["label5"], font )
guiLabelSetColor ( gui[6]["label5"], 0, 0, 0 )
guiSetVisible ( gui[6]["image5"], false )



function move9()
	if (Animation.createAndPlay ( gui[6]["image5"], Animation.presets.guiFadeIn ( 750 ) ) ) then
		guiSetText ( gui[6]["label5"], __("general:intro4") )
		setImageSizeLabel(gui[6]["image5"], gui[6]["label5"])
		guiSetVisible ( gui[6]["image5"], true )
		setTimer ( move10, 5000, 1 )
		call( getResourceFromName("npg_manager"), "showWindow")
	end
end


function move10()
		Animation.createAndPlay ( gui[6]["image5"], Animation.presets.guiFadeOut ( 750 ) )
		setTimer ( guiSetVisible, 750, 1, gui[6]["image5"], false )
		call( getResourceFromName("npg_manager"), "hideWindow")
		setTimer ( move11, 3500, 1 )
end



gui[6]["image6"] = guiCreateStaticImage ( sw/2 - 355.5, center/2 , 704, 60, "images/tutorial.png", false )
gui[6]["label6"] = guiCreateLabel ( 8,3,760,88,"",false, gui[6]["image6"] )
guiSetFont ( gui[6]["label6"], guiCreateFont( "FortuneCity.ttf", 30 ) )
guiLabelSetColor ( gui[6]["label6"], 0, 0, 0 )
guiSetVisible ( gui[6]["image6"], false )



function move11()
	if (Animation.createAndPlay ( gui[6]["image6"], Animation.presets.guiFadeIn ( 750 ) ) ) then
		setImageSizeLabel(gui[6]["image6"], gui[6]["label6"])
		guiSetVisible ( gui[6]["image6"], true )
		guiSetText ( gui[6]["label6"], __("general:intro5") )
		setTimer ( move12, 5000, 1 )
	end
end


function move12()
	Animation.createAndPlay ( gui[6]["image6"], Animation.presets.guiFadeOut ( 750 ) )
	setTimer ( guiSetVisible, 750, 1, gui[6]["image6"], false )
	triggerServerEvent ( "onPlayerReadRules", player )
end



