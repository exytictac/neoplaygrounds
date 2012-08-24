local me = getLocalPlayer()
local arrowFunctions = true

function isIs(namename, class)
	if type(namename) == "string" and type(class) == "number" then
		classe = exports.exports:getPlayerClass(me)
		if classe >= class then
			return namename
		else
			return nil
		end
	end
end

alpha = 128
channels = {}
currentChannel = nil
selectedChannelIndex = 0
selectedChannels = {}
local CHAT_SERVER_DATA = "server_data.xml"
local CHAT_CLIENT_DATA = "client_data.xml"
local w, h = guiGetScreenSize()
local specialChatChannels = {"Gamemode", "Nearby", "Team", "In Vehicle","Member","Staff"}
local currentSpecialChannel = 1
local combokey = "lctrl" --key to be used with the arrows for channel changing
local inTeamLast = false
local allOff = false
local showSticker = true


addCommandHandler("specialChat",
	function()
		executeCommandHandler("chatbox","Special Channel Chat")  --This bind uses non breakable spaces. "    " Empty character, but not a space.
	end
)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		--on resource start on the client side read from a local copy of the server xml file
		local xmlRoot = xmlLoadFile(CHAT_SERVER_DATA)
		local channelnames = xmlNodeGetChildren(xmlRoot)
		local defaultChannel = {name = "", description = "", longdescription ="", selected = true}
		channels[1] = defaultChannel
		currentChannel = defaultChannel
		selectedChannelIndex = 1
		if xmlRoot and channelnames then
			for id, node in ipairs(channelnames) do
				local channel = {}
				channel.name = xmlNodeGetAttribute(node, "name")
				channel.description = xmlNodeGetAttribute(node, "description")
				channel.longdescription = xmlNodeGetAttribute(node, "longdescription")
				channel.restrictedTo = xmlNodeGetAttribute(node, "restrictedTo")
				channel.broadcastOnly = xmlNodeGetAttribute(node, "broadcastOnly")
				
				local state = xmlNodeGetAttribute(node, "defaultState")
				if not state or string.lower(state) == "on" then
					channel.selected = true
				end
				channels[#channels + 1] = channel
			end
			xmlUnloadFile(xmlRoot)
		end
		--note: by default all but the 'all' channel are unselected on the client side

		--the client side xml file is read through to see which channels are selected
		xmlRoot = xmlLoadFile(CHAT_CLIENT_DATA)
		channelnames = xmlNodeGetChildren(xmlRoot)
		if xmlRoot and channelnames then
			local selectedCount = 1
			for id, node in ipairs(channelnames) do				
					local name = xmlNodeGetAttribute(node, "name")
					if name then
						local channel, index = getChannelFromName(name)
						if channel then
							if tonumber(xmlNodeGetAttribute(node, "current")) == 1 then
								currentChannel = channel
							end
							channel.selected = (tonumber(xmlNodeGetAttribute(node, "selected")) == 1)
						end
					end
			end
			xmlUnloadFile(xmlRoot)
		end
		
		--set the selected ch index
		updateSelectedChannels()
		for i, channel in ipairs(selectedChannels) do
			if channel == currentChannel then
				selectedChannelIndex = i
				break
			end
		end
		
		--apply channel data to player
		applyElementData()
		setTimer(updateSpecialChannel, 2000, 1)
		
		--special chat auto-switch
		setTimer(checkSpecialChannel, 1000, 0)
		
		unbindKey("y", "down")
		bindKey("y", "down", "chatbox", "Special Chat Channel")
		setElementData(me, "specialChannel", specialChatChannels[1], true)
		updateToChannel()
	end
)

function updateChannelXML()
	--wipes the client's xml file (this helps erase channels which are no longer listed on the server)
	--also creates the xml file if it doesn't already exist
	local xmlRoot = xmlCreateFile(CHAT_CLIENT_DATA, "root")

	--saves the channels and their selected states to the client's xml file
	for i, channel in ipairs(channels) do
		local tpnode = xmlCreateChild(xmlRoot, "channel")
		xmlNodeSetAttribute(tpnode, "name", channel.name)
		if channel.selected then
			xmlNodeSetAttribute(tpnode, "selected", 1)
		else
			xmlNodeSetAttribute(tpnode, "selected", 0)
		end

		--store the selected current channel
		if (currentChannel.name == channel.name) then
			xmlNodeSetAttribute(tpnode, "current", 1)
		else
			xmlNodeSetAttribute(tpnode, "current", 0)
		end
	end

	xmlSaveFile(xmlRoot)
	xmlUnloadFile(xmlRoot)

	applyElementData()
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), updateChannelXML)

function applyElementData()
	--each channel is stored as element data for the player
	for i, channel in ipairs(channels) do
		if channel.ref then
			setElementData(me, "chat:" .. channel.ref, channel.selected)
		else
			setElementData(me, "chat:" .. channel.name, channel.selected)
		end
	end

	--update selected current channel
	updateToChannel()
end

--update the channel a player is typing into
function updateToChannel()
	--if there are no selected channel then the player cannot talk into any of them
	if not allOff then
		alpha = 128
		--ensure currentChannel is a valid value
		if selectedChannelIndex > #selectedChannels then
			selectedChannelIndex = 1
		elseif selectedChannelIndex < 1 then
			selectedChannelIndex = #selectedChannels
		end
		currentChannel = selectedChannels[selectedChannelIndex]

		if currentChannel.longdescription then
			channelName = currentChannel.longdescription
		else
			channelName = currentChannel.description
		end
		--show memo and update text to show the selected channel
		currentChannelMemo = ""

		if not currentChannel.ref then
			setElementData(me, "currentchat", currentChannel.name)
		else
			setElementData(me, "currentchat", currentChannel.ref)
		end
	end
end


function upSpecialChannel()
	--check that a lalt key is being pressed 
	if getKeyState(combokey) then
		alpha = 128
		--check that the player has multiple special channels
		if not (table.getn(specialChatChannels) == 1) then
			--increment special channel
			repeat
				currentSpecialChannel = currentSpecialChannel + 1
				if currentSpecialChannel > #specialChatChannels then
					currentSpecialChannel = 1
				end
			until canSwitchToSpecialChannel(currentSpecialChannel)
		end
		--change binds and inform player of change
		updateSpecialChannel()
	end
end
--bind to up arrow key
addCommandHandler("Up Special Channel (hold combokey)",upSpecialChannel)
bindKey("arrow_r","down","Up Special Channel (hold combokey)")
bindKey("arrow_u","down","Up Special Channel (hold combokey)")

function downSpecialChannel()
	--check that a lalt key is being pressed 
	if getKeyState(combokey) then
		alpha = 128
		--check that the player has multiple special channels
		if not (table.getn(specialChatChannels) == 1) then
			--decrement special channel
			repeat
				currentSpecialChannel = currentSpecialChannel - 1
				if currentSpecialChannel < 1 then
					currentSpecialChannel = #specialChatChannels
				end
			until canSwitchToSpecialChannel(currentSpecialChannel)
		end
		--change binds and inform player of change
		updateSpecialChannel()
	end
end
--bind to up arrow key
addCommandHandler("Down Special Channel (hold combokey)",downSpecialChannel)
bindKey("arrow_l","down","Down Special Channel (hold combokey)")
bindKey("arrow_d","down","Down Special Channel (hold combokey)")

function updateSpecialChannel()
	--if there is only one special channel then do nothing
	if (table.getn(specialChatChannels) > 1) then	
		--ensure currentChannel is a valid value
		if (currentSpecialChannel > table.getn(specialChatChannels)) then
			currentSpecialChannel = 1
		end
		if (currentSpecialChannel < 1) then
			currentSpecialChannel = table.getn(specialChatChannels)
		end		

		--show memo and update text to reflect lack of channel
		currentChannelMemo ="Special Chat Channel: "..specialChatChannels[currentSpecialChannel]
		
		setElementData(me, "specialChannel", specialChatChannels[currentSpecialChannel])
	end
end

function checkSpecialChannel()

	local inTeam = getPlayerTeam(me)

	--If player joins a team automatically set their special chat to team
	if ((not inTeamLast) and inTeam) then
		currentSpecialChannel = 1
		inTeamLast = true
		updateSpecialChannel()
		return
	end
	inTeamLast = inTeam

	if currentSpecialChannel == 3 and not inTeam then
		currentSpecialChannel = 1
		updateSpecialChannel()
	elseif currentSpecialChannel == 4 and not getPedOccupiedVehicle(me) then
		--for now, do the same as with the team case
		currentSpecialChannel = 1
		updateSpecialChannel()
	elseif currentSpecialChannel == 5 and exports.exports:getPlayerClass(me) < 2 then
		currentSpecialChannel = 1
		updateSpecialChannel()
	elseif currentSpecialChannel == 6 and exports.exports:getPlayerClass(me) < 3 then
		currentSpecialChannel = 1
		updateSpecialChannel()
	end
end

function canSwitchToSpecialChannel(spChannelIndex)
	if currentSpecialChannel == 3 and not getPlayerTeam(me) then
		return false
	elseif currentSpecialChannel == 4 and not getPedOccupiedVehicle(me) then
		return false
	else
		return true
	end
end

--disable key functions for channel changes
function disableArrowFunctions(stat)
	if stat == "false" then
		arrowFunctions = false
		toggleControl ( "forwards", false )
		toggleControl ( "backwards", false )

		toggleControl ( "steer_forward", false )
		toggleControl ( "steer_back", false )

		toggleControl ( "next_weapon", false )
		toggleControl ( "previous_weapon", false )

		if (table.getn(specialChatChannels) > 1) then		

			toggleControl ( "left", false )
			toggleControl ( "right", false )

			toggleControl ( "vehicle_left", false )
			toggleControl ( "vehicle_right", false )

		end
	else
		arrowFunctions = true
		toggleControl ( "forwards", true )
		toggleControl ( "backwards", true )

		toggleControl ( "steer_forward", true )
		toggleControl ( "steer_back", true )

		toggleControl ( "next_weapon", true )
		toggleControl ( "previous_weapon", true )

		if (table.getn(specialChatChannels) > 1) then		

			toggleControl ( "left", true )
			toggleControl ( "right", true )

			toggleControl ( "vehicle_left", true )
			toggleControl ( "vehicle_right", true )

		end
	end
end
addCommandHandler("toggleArrowFunctions",disableArrowFunctions)
bindKey(combokey,"down","toggleArrowFunctions", "false")
bindKey(combokey,"up","toggleArrowFunctions", "true")

function refreshChannelGuiList()
	if ( grdlst_column_state ) then
		guiGridListClear(channelGridList)
		--first add all chat channels
		local row = guiGridListAddRow ( channelGridList )
		guiGridListSetItemText(channelGridList, row, grdlst_column_state, "Chat channels", true, false)
		local containsBroadcast, containsGroup = false, false
		allOff = true
		for i, channel in ipairs(channels) do
			if channel.broadcastOnly then
				containsBroadcast = true
			elseif isGroupChannel(channel) then
				containsGroup = true
			elseif not channel.restrictedTo or (channel.restrictedTo and playerIsInClass(me, channel.restrictedTo)) then
				local row = guiGridListAddRow ( channelGridList )
				guiGridListSetItemText ( channelGridList, row, grdlst_column_state, channel.description .. ":  ", false, false )
				guiGridListSetItemData(channelGridList, row, grdlst_column_state, channel.name)
				local state = "on"
				if not channel.selected then
					state = "off"
				else
					allOff = false
				end
				guiGridListSetItemText ( channelGridList, row, grdlst_column_channel, " " .. state, false, false )
			end
		end
		--broadcast channels
		if containsBroadcast then
			local row = guiGridListAddRow ( channelGridList )
			guiGridListSetItemText(channelGridList, row, grdlst_column_state, "Broadcast channels", true, false)
			for i, channel in ipairs(channels) do
				if channel.broadcastOnly then
					local row = guiGridListAddRow ( channelGridList )
					guiGridListSetItemText ( channelGridList, row, grdlst_column_state, channel.description .. ":  ", false, false )
					guiGridListSetItemData(channelGridList, row, grdlst_column_state, channel.name)
					local state = "on"
					if not channel.selected then
						state = "off"
					end
					guiGridListSetItemText ( channelGridList, row, grdlst_column_channel, " " .. state, false, false )
				end
			end
		end
		--groupchat channels
		if containsGroup then
			local row = guiGridListAddRow ( channelGridList )
			guiGridListSetItemText(channelGridList, row, grdlst_column_state, "Group-chat channels", true, false)
			for i, channel in ipairs(channels) do
				if isGroupChannel(channel) then
					local row = guiGridListAddRow ( channelGridList )
					guiGridListSetItemText ( channelGridList, row, grdlst_column_state, channel.description .. ":  ", false, false )
					guiGridListSetItemData(channelGridList, row, grdlst_column_state, channel.name)
					local state = "on"
					if not channel.selected then
						state = "off"
					else
						allOff = false
					end
					guiGridListSetItemText ( channelGridList, row, grdlst_column_channel, " " .. state, false, false )
				end
			end
		end
	end
end

addEvent("onLogin", true)
addEventHandler("onLogin", me, refreshChannelGuiList)

addEvent("chat:onCreateChannel", true)
addEventHandler("chat:onCreateChannel", getRootElement(),
	function (ref, name, description, selected, autojoin)
		local channel = {ref = ref, name = name, description = description, selected = selected}
		local targetIndex = #channels + 1
		for i, channel in ipairs(channels) do
			if channel.ref == ref then
				targetIndex = i
				break
			end
		end
		channels[targetIndex] = channel
		updateSelectedChannels()
		if autojoin and selected then
			currentChannel = channel
			for i, ch in ipairs(selectedChannels) do
				if ch == channel then
					selectedChannelIndex = i
					break
				end
			end
		end
		applyElementData()
		refreshChannelGuiList()
		updateToChannel()
	end
)

addEvent("chat:onCloseChannel", true)
addEventHandler("chat:onCloseChannel", getRootElement(),
	function (ref)
		if ref then
			for i, channel in ipairs(channels) do
				if channel.ref == ref then
					table.remove(channels, i)
					break
				end
			end
			updateSelectedChannels()
			applyElementData()
			refreshChannelGuiList()
			updateToChannel()
		else
			return
		end
	end
)
function chatSticker()
	local screenWidth, screenHeight = guiGetScreenSize()
	-- Draw the panel
	dxDrawRectangle((screenWidth / 2) - 200, screenHeight/30, 400, 20, tocolor(0, 0, 0, alpha), true)
		
	-- Draw all strings.
	dxDrawText(currentChannelMemo, (screenWidth / 2) - 198, 22, (screenWidth / 2) + 198, 16, tocolor(0, 255, 0, 255), 1, "default-bold-small", "center", "top", false, false, true)
end
addEventHandler("onClientPreRender", getRootElement(), chatSticker)
addCommandHandler("chatsticker",
	function(thepl)
		if showSticker then
			removeEventHandler("onClientPreRender", getRootElement(),chatSticker)
		else
			addEventHandler("onClientPreRender", getRootElement(), chatSticker)
		end
		showSticker = not showSticker
	end
)