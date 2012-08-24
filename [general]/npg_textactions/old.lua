local shown = true
local data = {}
local rootElement = getRootElement()
local messages = {}
local fontsTable = {{15,"arial",1.2},{16,"arial",0.5}}
local sx, sy = guiGetScreenSize()
local fontNumber = sx > 1280 and 1 or 1
local client = getLocalPlayer()
local _offset_= getChatboxLayout()["chat_lines"]*18-- originally it was 200

addEventHandler("onClientResourceStart", resourceRoot, function()
		local x,y,w,h = sx/4+10,0,(sy/2)-20,0
		data = {x,y,w,h}
		addEventHandler("onClientPreRender", root, drawBoard)
	end
)

-- Show or hide the notice board
addCommandHandler("notice", function()
		if shown then
			removeEventHandler("onClientPreRender", root, drawContainer)
		else
			addEventHandler("onClientPreRender", root, drawContainer)
		end
		shown = not shown
	end
)

function drawBoard()
	if messages[1] then
		local y = messages[1][5]
		local removeMessage
		if messages[1][3] then
			y = y - 1
			messages[1][5] = y
			data[4] = data[4] - 0.1
			if messages[1][5] == (-1 * messages[1][7]) then
				removeMessage = true
				if #messages == 1 then
					killTimer(messagesTimer)
					messagesTimer = false
				end
			end
		end
		local x = data[1]
		local w = data[1] + data[3]
		for k, message in ipairs(messages) do
			local h = message[7] - 2
			local msg = message[1]
			if message[8] then
				local messageTable = {}
				for k, func in ipairs(message[8]) do
					table.insert(messageTable,func())
				end
				msg = msg:format(unpack(messageTable))
			end
			--dxDrawRectangle(8, y/0.65+198, sx/5*2, h+8, tocolor(0,0,0,125))
			dxDrawBorderedText(msg,11,y/0.65+_offset_,sx/5*2,sy,message[2],fontsTable[fontNumber][3],fontsTable[fontNumber][2],"left","top",true,true,false)
			y = y + h
		end
		if removeMessage then
			table.remove(messages,1)
			removeMessage = false
		end
	end
end

function dxDrawBorderedText( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false ) -- black
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x - 1, y, w - 1, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x + 1, y, w + 1, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x, y - 1, w, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x, y + 1, w, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
end

function moveMessage (i)
	messages[i][3] = true
end

function sendMessage(text,r,g,b,formattable)
	if not messagesTimer then
		messagesTimer = setTimer(messagesTimer,1000,0)
	end
	if #messages > 5 then
	    table.remove(messages,1)
		local i = 1
		while messages[i + 1][3] do
			i = i + 1
		end
		if messages[i] then
			messages[i][3] = true
		end
	end
	local h = fontsTable[fontNumber][1]
	local msg = text
	local textWidth = dxGetTextWidth(msg,fontsTable[fontNumber][3],fontsTable[fontNumber][2])
	if textWidth > data[3] then
		h = 2 * h
	end
	data[4] = data[4] + h
	local color = tocolor(r or 255,g or 255,b or 255,255)
	table.insert(messages,{text,color,false,0,0,10,h,formattable})
	return messages[#messages]
end

function messagesTimer()
	for k,message in ipairs(messages) do
		message[6] = message[6] - 1
		if message[6] <= 0 then
			moveMessage(1)
		end
	end
end

function removeMessageOnTimer()
	if #messages > 0 then
		table.remove(messages,1)
	end
end
setTimer(removeMessageOnTimer,60*1000,0)

addEvent("noticeBoard:send",true)
addEventHandler("noticeBoard:send", root, function (text, r, g, b, formattable)
		sendMessage(tostring(text),tonumber(r),tonumber(g),tonumber(b),formattable)
	end
)

function locatePlayer(player)
	if (getPlayerFromName(player)) then
		local thePlayer = getPlayerFromName(player)
		local formattable = {function() return playerLocator(thePlayer) end}
		sendMessage("*LOC* %s",255,200,0,formattable)
	else
		sendMessage("*LOC* Player does not exist.",255,0,0)
	end
end


function playerLocator(thePlayer)
	if not thePlayer or not isElement(thePlayer) then return "The player does not exist." end
	local x,y,z = getElementPosition(client)
	local x2,y2,z2 = getElementPosition(thePlayer)
	local dis = math.floor(getDistanceBetweenPoints3D(x,y,z,x2,y2,z2))
	local dir = getLocationBetween(x2,y2,x,y)
	return getPlayerName(thePlayer).." is "..dis.." meters "..dir.." of you."
end

function getLocationBetween(xS,yS,xC,yC)
	local location = "unknown"
	local xCn =  xS - xC
	local yCn =  yS - yC
	if xCn > 0 and yCn > 0 then
		angle = math.deg(math.atan(yCn/xCn))
	elseif xCn > 0 and yCn < 0 then
		angle = (360+(math.deg(math.atan(yCn/xCn)))) 
	elseif xCn < 0 and yCn > 0 then
	angle =   180+(math.deg(math.atan(yCn/xCn)))
	elseif xCn < 0 and yCn < 0 then
		angle = 180+(math.deg(math.atan(yCn/xCn)))
	else
		angle = 0
	end
	if angle <22.5 or angle > 337.5 then
		location = "east"
	elseif angle > 22.5 and angle < 67.5 then
		location = "north east"
	elseif angle > 67.5 and angle < 112.5 then
		location = "north"
	elseif angle > 112.5 and angle < 157.5 then
		location = "north west"
	elseif angle > 157.5 and angle < 202.5 then 
		location = "west"
	elseif angle > 202.5 and angle < 247.5 then
		location = "south west"
	elseif angle > 247.5 and angle < 292.5 then 
		location = "south"
	elseif angle > 292.5 and angle < 337.5 then
		location = "south east"
	else
		location = "unknown"
	end
	return location
end