local calls = {}
local vehicleIDS = { 602, 545, 496, 517, 401, 410, 518, 600, 527, 436,
589, 580, 419, 439, 533, 549, 526, 491, 474, 445, 467, 604, 426, 507, 547, 585,
405, 587, 409, 466, 550, 492, 566, 546, 540, 551, 421, 516, 529,
488, 581, 510, 509, 522, 481, 461, 
462, 521, 468, 463, 586, 472, 473, 493, 595, 484, 430, 453, 452, 446, 
454, 485, 552, 431, 438, 437, 574, 420, 525, 408, 416, 596, 433, 597, 427,
599, 490, 432, 528, 601, 407, 428, 544, 523, 470, 598, 499, 588, 609, 403, 498, 514, 524, 
423, 532, 414, 578, 443, 486, 515, 406, 531, 573, 456, 455, 459, 543, 422, 583, 482, 
478, 605, 554, 530, 418, 572, 582, 413, 440, 536, 575, 534, 567, 535, 576, 412, 402, 542, 
603, 475, 449, 537, 538, 568, 557, 424, 471, 504, 495, 457, 539, 483, 508, 571, 500, 
444, 556, 429, 411, 541, 559, 415, 561, 480, 560, 562, 506, 565, 451, 434, 
558, 494, 555, 502, 477, 503, 579, 400, 404, 489, 505, 479, 442, 458, 
606, 607, 590, 569, 611, 594 }

local gui = {}

local function CloseWindow()
	guiSetVisible(gui['_root'], false)
	showCursor(false)
	guiSetInputEnabled(false)
end

local function SearchQuery(text)
	if type(text)=='string' then
		text = text:lower()
	elseif type(text)=='userdata' then
		text = guiGetText(text):lower()
	else
		text = ''
	end
	local g = gui['Grid']
	for i,v in ipairs(vehicleIDS) do
		local n = tostring(getVehicleNameFromModel(v))
		if n=='' then n='Special' end
		if text=='' or string.find(n:lower(),text:lower()) then
			local row = guiGridListAddRow(g)
			guiGridListSetItemText(g, row, 1, n, false, false )
			guiGridListSetItemText(g, row, 2, tostring(v), false, false )
		end
	end
	guiGridListAutoSizeColumn ( g, 1)
	guiGridListAutoSizeColumn ( g, 2)
end

local function SearchSubmit(element)
	text = guiGetText(element):lower()
	if text then
		text = tostring(text)
		if tonumber(text) then
			text = tonumber(text)
			if getVehicleNameFromModel(text) and vehicleIDS[text] then
				startGame(text)
				return
			end
		end
		text = getVehicleModelFromName(text)
		if text and vehicleIDS[text] then
			startGame(text)
		end
	else startGame(vehicleIDS[math.random(#vehicleIDS)]) end
end

local function GridDouble(button, state)
	if button ~= 'left' or state ~= 'up' then return end
	local g = gui['Grid']
    local selectedRow = guiGridListGetSelectedItem( g )
    local model = guiGridListGetItemText( g, selectedRow, 2);
    startGame(tonumber(model))
end

local function build_SpawnVeh()
	local gui = {}
	
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 267, 315
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Vehicle Selector", false)
	guiWindowSetSizable(gui["_root"], false)
	
	gui["Search"] = guiCreateEdit(0, 15, 261, 31, "", false, gui["_root"])
	addEventHandler("onClientGUIChanged", gui['Search'], SearchQuery)
	addEventHandler( "onClientGUIAccepted", gui['Search'], SearchSubmit)
	
	gui["Close"] = guiCreateButton(0, 285, 262, 23, "Close", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["Close"], CloseWindow)
	
	gui['Grid'] = guiCreateGridList ( 0, 45, 261, 231, false, gui['_root'] )
	guiGridListAddColumn ( gui['Grid'], 'Name', 0.5 )
	guiGridListAddColumn ( gui['Grid'], 'ID', 0.5 )
	guiGridListSetSortingEnabled ( gui['Grid'], true )
	addEventHandler( "onClientGUIDoubleClick", gui['Grid'], GridDouble)
	
	addCommandHandler('dsv', function()
		if guiGetVisible(gui['_root']) or getElementData(localPlayer, "gamemode")~='manhunt' then return end
		guiSetVisible(gui['_root'], true)
		showCursor(true)
		guiSetInputEnabled(true)
		SearchQuery('')
	end)
	
	guiSetVisible(gui['_root'], false)
	return gui, 'SpawnVeh'
end
-- --
function build_gui()
	gui = build_SpawnVeh()
end
_addGui(build_gui)