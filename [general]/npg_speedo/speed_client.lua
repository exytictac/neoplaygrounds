

sw, sh = guiGetScreenSize()
csw, csh = sw - 130, sh - 130
xAngle, frame, scale = 1, 30, sw / 1280

local crack = {
	on = false,
	w = 300,
	h = 300,
	s = 1,
	r = 1, 
	x = 500,
	y = 500
}

local settings = {
	r = 255,
	g = 255,
	b = 0,
	br = 255,
	spin = false,
	mph = false,
	crack = true,
	info = 1,
	a = 255
}

imgBG = "img/speed_bg.png"
imgL = "img/speed_labels.png"
imgHP = "img/speed_hp.png"
imgBGG = "img/speed_bg_glow.png"
imgIR = "img/speed_innerring.png"
imgOR = "img/speed_outerring.png"
imgN = "img/speed_needle.png"
imgNS = "img/speed_needle_s.png"
imgCV = "img/speed_cover.png"
imgCR = "img/speed_crack.png"

labelColor =tocolor(255, 222, 0, 255)
brightness = tocolor(255, 255, 255, 255)
white = tocolor(255, 255, 255, 198)
black = tocolor(0, 0, 0, 222)

speedo_SW = false
drag = false
spinner = true
xml = false

function renderSpeed()
	local vSpeed = getSpeed()
	local vHp = getHealth()
	if vHp < 0 then
		vHp = 0
	end
	if frame > 0 then
		frame = frame - 1
	end
	local glowR = 490 - vHp * 7
	local glowG = vHp * 7
	vHp = vHp * scale
	local speedText = math.floor(vSpeed)
	if speedText < 10 then
		speedText = "00" .. speedText
	elseif speedText < 100 then
		speedText = "0" .. speedText
	elseif speedText > 300 then
		speedText = "OMG"
	else
		speedText = tostring(speedText)
	end
	if xAngle > 360 then
		xAngle = xAngle - 360
	end
	xAngle = xAngle + vSpeed / 10
	if vSpeed > 260 then
		vSpeed = 260
	end
	if settings.spin then
		if vSpeed >= 255 or not vSpeed + frame * 8 then
			dxDrawImage(csw - 128 * scale, csh - 128 * scale, 256 * scale, 256 * scale, imgBGG, 0, 0, 0, tocolor(settings.r, settings.g, settings.b, 255 + frame * 8))
		end
	else
		if vSpeed >= 255 or not (vSpeed + frame * 8) then
			dxDrawImage(csw - 128 * scale, csh - 128 * scale, 256 * scale, 256 * scale, imgBGG, 0, 0, 0, tocolor(glowR > 255 and 255 or glowR, glowG > 255 and 255 or glowG, 0, 255 + frame * 8))
		end
	end
	if spinner then
		if frame > 0 then
			dxDrawImage(csw - frame - 128 * scale, csh - frame - 128 * scale, (256 + frame * 2) * scale, (256 + frame * 2) * scale, imgOR, xAngle + frame, 0, 0, brightness)
		else
			dxDrawImage(csw - 128 * scale, csh - 128 * scale, 256 * scale, 256 * scale, imgOR, xAngle, 0, 0, brightness)
		end
	end
	dxDrawImage(csw - 128 * scale, csh - 128 * scale, 256 * scale, 256 * scale, imgBG, 0, 0, 0, brightness)
	dxDrawImage(csw - 128 * scale, csh - 128 * scale, 256 * scale, 256 * scale, imgL, 0, 0, 0, labelColor)
	dxDrawImage(csw - 35 * scale, csh - 37 * scale, vHp - frame, 13 * scale, imgHP, 0, 0, 0, tocolor(((vHp - frame >= 0 or not 0) and glowR <= 255 or 255) or glowR, glowG > 255 and 255 or glowG, 0, 255))
	dxDrawImage(csw - 127 * scale, csh - 124 * scale, 256 * scale, 256 * scale, imgNS, vSpeed, 0, 0)
	dxDrawImage(csw - 127 * scale, csh - 128 * scale, 256 * scale, 256 * scale, imgN, vSpeed, 0, 0, labelColor)
	dxDrawImage(csw - 128 * scale, frame / 3 + csh - 128 * scale, 256 * scale, 256 * scale, imgCV, 0, 0, 0, brightness)
	dxDrawText(speedText, csw - 20 * scale, csh + 60 * scale, csw + 20 * scale, csh + 70 * scale, black, 0.5 * scale, "bankgothic", "center")
	dxDrawText(speedText, csw - 20 * scale, csh + 59 * scale, csw + 20 * scale, csh + 70 * scale, labelColor, 0.5 * scale, "bankgothic", "center")
	dxDrawImage(csw - 64 * scale, csh + 2 * scale, 128 * scale, 128 * scale, imgIR, 720 - xAngle * 2, 0, 0, tocolor(settings.r, settings.g, settings.b, vSpeed))
	if vHp < 13 * scale and vHp > 0 and not crack.on then
		crack.on = true
		crack.r = math.random(360)
		crack.s = math.random(500)
		crack.w = 400 + crack.s
		crack.h = 400 + crack.s
		crack.x = math.random(csw) - crack.w / 2
		crack.y = math.random(csh) - crack.h / 2
	else
		if 13 * scale <= vHp then
			crack.on = false
		end
	end
	if crack.on then
		dxDrawImage(crack.x, crack.y, crack.w, crack.w, imgCR, crack.r, 0, 0, white, false)
	end
end

function getSpeed(button)
	if isPedInVehicle(localPlayer) then
		local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(localPlayer))
		if button then
			return ( math.sqrt(vx ^ 2 + vy ^ 2 + vz ^ 2) * 100) or 0
		else
			return (math.sqrt(vx ^ 2 + vy ^ 2 + vz ^ 2) * 160.9) or 0
		end
	end
	return 0
end


function getHealth()
	local car = getPedOccupiedVehicle(localPlayer)
	if car then
		car = getElementHealth(car)
	end
	return math.ceil(((car or 0) - 250) / 750 * 70)
end

addEventHandler("onClientVehicleEnter", root, function(player)
		if player == localPlayer then
			npgSpeed(true)
		end
	end
)

addEventHandler("onClientVehicleExit", root, function(l_5_0)
		if l_5_0 == localPlayer then
			npgSpeed(false)
		end
	end
)

addEventHandler("onClientPlayerWasted", root, function()
		if source == localPlayer then
			npgSpeed(false)
		end
	end
)

--[[addEventHandler("onClientResourceStart", resourceRoot, function()
	if scale > 1 then
		scale = 1
	end
	loadSettings()
	if sw < csw or csw < 0 then
		csw = sw - 130
	end
	if sh < csh or csh < 0 then
		csh = sh - 130
	end
	if isPedInVehicle(localPlayer) then
		npgSpeed(true)
	end
	speedo_SW = guiCreateWindow(csw - 128 * scale, csh - 128 * scale, 256 * scale, 256 * scale, "Speedometer", false)
	guiWindowSetSizable(speedo_SW, false)
	guiWindowSetMovable(speedo_SW, false)
	speedo_SO = guiCreateWindow(sw - 220, sh - 270, 200, 250, "Speedometer: Options", false)
	guiWindowSetSizable(speedo_SO, false)
	guiSetFont(guiCreateLabel(0.05, 0.12, 0.9, 0.06, "Speedometer labels RGB color:", true, speedo_SO), "default-small")
	speedo_SOR = guiCreateScrollBar(0.05, 0.18, 0.9, 0.08, true, true, speedo_SO)
	speedo_SOG = guiCreateScrollBar(0.05, 0.26, 0.9, 0.08, true, true, speedo_SO)
	speedo_SOB = guiCreateScrollBar(0.05, 0.34, 0.9, 0.08, true, true, speedo_SO)
	guiSetFont(guiCreateLabel(0.05, 0.43, 0.9, 0.06, "Speedometer brightness/opacity:", true, speedo_SO), "default-small")
	speedo_SOBR = guiCreateScrollBar(0.05, 0.49, 0.9, 0.08, true, true, speedo_SO)
	speedo_SOA = guiCreateScrollBar(0.05, 0.57, 0.9, 0.08, true, true, speedo_SO)
	speedo_SOID = guiCreateCheckBox(0.05, 0.67, 0.9, 0.06, "Display 'Press ~ or F8 and...' text", false, true, speedo_SO)
	speedo_SOCS = guiCreateCheckBox(0.05, 0.73, 0.9, 0.06, "Use labels color for outer glow", false, true, speedo_SO)
	speedo_SOSE = guiCreateCheckBox(0.05, 0.79, 0.9, 0.06, "Display outer spinning part", false, true, speedo_SO)
	guiSetFont(speedo_SOCS, "default-small")
	guiSetFont(speedo_SOSE, "default-small")
	guiSetFont(speedo_SOID, "default-small")
	speedo_SOX = guiCreateButton(0.81, 0.85, 0.14, 0.15, "X", true, speedo_SO)
	speedo_SORP = guiCreateButton(0.05, 0.87, 0.38, 0.1, "Reset Position", true, speedo_SO)
	speedo_SORS = guiCreateButton(0.43, 0.87, 0.38, 0.1, "Reset Scale", true, speedo_SO)
	guiSetFont(speedo_SORP, "default-small")
	guiSetFont(speedo_SORS, "default-small")
	guiSetAlpha(speedo_SW, 0)
	guiSetVisible(speedo_SO, false)
	
	addEventHandler("onClientGUIDoubleClick", source, function()
			if source == speedo_SW and not guiGetVisible(speedo_SO) then
				openSettings(true)
			elseif source == speedo_SW then
				openSettings()
			end
		end
	)
	
	addEventHandler("onClientGUIClick", source, function(button, state)
			if source == speedo_SW then
				drag = button=='left' and false or (not drag)
			elseif source == speedo_SORS then
				scale = 1
				guiSetPosition(speedo_SW, csw - 128 * scale, csh - 128 * scale, false)
				guiSetSize(speedo_SW, 256 * scale, 256 * scale, false)
			elseif source == speedo_SORP then
				csw, csh = sw - 130, sh - 130
				guiSetPosition(speedo_SW, csw - 128 * scale, csh - 128 * scale, false)
			elseif source == speedo_SOSE then
				spinner = guiCheckBoxGetSelected(speedo_SOSE) and true or false
			elseif source == speedo_SOCS then
				settings.spin = guiCheckBoxGetSelected(speedo_SOCS) and true or false
			elseif source == speedo_SOID then
				settings.info = guiCheckBoxGetSelected(speedo_SOID) and 1 or 0
			elseif source == speedo_SOX then
				guiSetVisible(speedo_SO, false)
			end
		end
	)
   
	addEventHandler("onClientGUIScroll", source, function(l_3_0)
			if l_3_0 == speedo_SOR then
				settings.r = math.ceil(guiScrollBarGetScrollPosition(speedo_SOR) * 2.55)
				labelColor = tocolor(settings.r, settings.g, settings.b, 255)
			elseif l_3_0 == speedo_SOG then
				settings.g = math.ceil(guiScrollBarGetScrollPosition(speedo_SOG) * 2.55)
				labelColor = tocolor(settings.r, settings.g, settings.b, 255)
			elseif l_3_0 == speedo_SOB then
				settings.b = math.ceil(guiScrollBarGetScrollPosition(speedo_SOB) * 2.55)
				labelColor = tocolor(settings.r, settings.g, settings.b, 255)
			elseif l_3_0 == speedo_SOBR then
				settings.br = math.ceil(guiScrollBarGetScrollPosition(speedo_SOBR) * 2.55)
				brightness = tocolor(settings.br, settings.br, settings.br, settings.a)
			elseif l_3_0 == speedo_SOA then
				settings.a = math.ceil(guiScrollBarGetScrollPosition(speedo_SOA) * 2.55)
				brightness = tocolor(settings.br, settings.br, settings.br, settings.a)
			end
		end
	)
	
	addEventHandler("onClientMouseWheel", source, function(l_4_0)
			scale = scale + l_4_0 / 50
			if scale > 2 then
				scale = 2
			end
			guiSetPosition(speedo_SW, csw - 128 * scale, csh - 128 * scale, false)
			guiSetSize(speedo_SW, 256 * scale, 256 * scale, false)
		end
	)
	
	addEventHandler("onClientMouseMove", root, function(x, y)
			if drag then
				csw = x
				csh = y
				guiSetPosition(speedo_SW, csw - 128 * scale, csh - 128 * scale, false)
				guiSetSize(speedo_SW, 256 * scale, 256 * scale, false)
			end
		end
	)
	outputChatBox("Speedometer: Type /spds to open settings!", 255, 155, 0, true)
end
)]]

function loadSettings()
	xml = xmlLoadFile("speed.xml")
	if xml then
		scale = tonumber(xmlNodeGetValue(xmlFindChild(xml, "scale", 0)))
		csw = tonumber(xmlNodeGetValue(xmlFindChild(xml, "posX", 0)))
		csh = tonumber(xmlNodeGetValue(xmlFindChild(xml, "posY", 0)))
		settings.r = tonumber(xmlNodeGetValue(xmlFindChild(xml, "red", 0)))
		settings.g = tonumber(xmlNodeGetValue(xmlFindChild(xml, "green", 0)))
		settings.b = tonumber(xmlNodeGetValue(xmlFindChild(xml, "blue", 0)))
		if xmlFindChild(xml, "brightness", 0) then
			settings.br = tonumber(xmlNodeGetValue(xmlFindChild(xml, "brightness", 0)))
		else
			xmlNodeSetValue(xmlCreateChild(xml, "brightness"), tostring(settings.br))
		end
		if xmlFindChild(xml, "info", 0) then
			settings.info = tonumber(xmlNodeGetValue(xmlFindChild(xml, "info", 0)))
		else
			xmlNodeSetValue(xmlCreateChild(xml, "info"), tostring(settings.info))
		end
		if xmlFindChild(xml, "alpha", 0) then
			settings.a = tonumber(xmlNodeGetValue(xmlFindChild(xml, "alpha", 0)))
		else
			xmlNodeSetValue(xmlCreateChild(xml, "alpha"), tostring(settings.a))
		end
		if tostring(xmlNodeGetValue(xmlFindChild(xml, "spincolor", 0))) == "true" then
			settings.spin = true
		else
			settings.spin = false
		end
		if tostring(xmlNodeGetValue(xmlFindChild(xml, "spinner", 0))) == "true" then
			spinner = true
		else
			spinner = false
		end
		labelColor = tocolor(settings.r, settings.g, settings.b, 255)
		brightness = tocolor(settings.br, settings.br, settings.br, settings.a)
	else
		xml = xmlCreateFile("speed.xml", "settings")
		xmlNodeSetValue(xmlCreateChild(xml, "scale"), tostring(scale))
		xmlNodeSetValue(xmlCreateChild(xml, "posX"), tostring(csw))
		xmlNodeSetValue(xmlCreateChild(xml, "posY"), tostring(csh))
		xmlNodeSetValue(xmlCreateChild(xml, "red"), tostring(settings.r))
		xmlNodeSetValue(xmlCreateChild(xml, "green"), tostring(settings.g))
		xmlNodeSetValue(xmlCreateChild(xml, "blue"), tostring(settings.b))
		xmlNodeSetValue(xmlCreateChild(xml, "spincolor"), tostring(settings.spin))
		xmlNodeSetValue(xmlCreateChild(xml, "spinner"), tostring(spinner))
		xmlNodeSetValue(xmlCreateChild(xml, "brightness"), tostring(settings.br))
		xmlNodeSetValue(xmlCreateChild(xml, "info"), tostring(settings.info))
		xmlNodeSetValue(xmlCreateChild(xml, "alpha"), tostring(settings.a))
	end
end

function saveSettings()
	xmlNodeSetValue(xmlFindChild(xml, "scale", 0), tostring(scale))
	xmlNodeSetValue(xmlFindChild(xml, "posX", 0), tostring(csw))
	xmlNodeSetValue(xmlFindChild(xml, "posY", 0), tostring(csh))
	xmlNodeSetValue(xmlFindChild(xml, "red", 0), tostring(settings.r))
	xmlNodeSetValue(xmlFindChild(xml, "green", 0), tostring(settings.g))
	xmlNodeSetValue(xmlFindChild(xml, "green", 0), tostring(settings.g))
	xmlNodeSetValue(xmlFindChild(xml, "blue", 0), tostring(settings.b))
	xmlNodeSetValue(xmlFindChild(xml, "spincolor", 0), tostring(settings.spin))
	xmlNodeSetValue(xmlFindChild(xml, "spinner", 0), tostring(spinner))
	xmlNodeSetValue(xmlFindChild(xml, "brightness", 0), tostring(settings.br))
	xmlNodeSetValue(xmlFindChild(xml, "info", 0), tostring(settings.info))
	xmlNodeSetValue(xmlFindChild(xml, "alpha", 0), tostring(settings.a))
end

addEventHandler("onClientResourceStop", resourceRoot, function()
		saveSettings()
		xmlSaveFile(xml)
		xmlUnloadFile(xml)
	end
)

function openSettings(show)
	if show then
		guiSetVisible(speedo_SO, true)
		guiScrollBarSetScrollPosition(speedo_SOR, math.ceil(settings.r / 2.55))
		guiScrollBarSetScrollPosition(speedo_SOG, math.ceil(settings.g / 2.55))
		guiScrollBarSetScrollPosition(speedo_SOB, math.ceil(settings.b / 2.55))
		guiScrollBarSetScrollPosition(speedo_SOBR, math.ceil(settings.br / 2.55))
		guiScrollBarSetScrollPosition(speedo_SOA, math.ceil(settings.a / 2.55))
		if spinner then
			guiCheckBoxSetSelected(speedo_SOSE, true)
		else
			guiCheckBoxSetSelected(speedo_SOSE, false)
		end
		if settings.spin then
			guiCheckBoxSetSelected(speedo_SOCS, true)
		else
			guiCheckBoxSetSelected(speedo_SOCS, false)
		end
		if settings.info == 1 then
			guiCheckBoxSetSelected(speedo_SOID, true)
		else
			guiCheckBoxSetSelected(speedo_SOID, false)
		end
		guiBringToFront(speedo_SO)
	else
		guiSetVisible(speedo_SO, false)
	end
end

function npgSpeed(on)
	if on then
		addEventHandler("onClientRender", root, renderSpeed)
		frame = 30
	else
		removeEventHandler("onClientRender", root, renderSpeed)
		frame = 0
	end
end

addCommandHandler("spds", function()
		openSettings(not guiGetVisible(speedo_SO))
	end
)
