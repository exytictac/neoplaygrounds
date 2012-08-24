-- Help panel by The NPG Team

local screenWidth, screenHeight = guiGetScreenSize()
local itemList = {"Rules", "FAQ", "Freeroam", "RPG", "Race", "Heligrab"}
addEventHandler("onClientResourceStart", getResourceRootElement(), function()
		-- Create the window.
		helpWindow = guiCreateWindow((screenWidth / 2) - 310, (screenHeight / 2) - 210, 620, 420, "Help", false)
		guiSetAlpha(helpWindow, 0)

		-- Create the "Close" button.
		closeButton = guiCreateButton(0.78, 0.92, 0.20, 0.8, "Close", true, helpWindow)

		-- Create the help topics list.		
		topicList = guiCreateGridList(0.02, 0.09, 0.30, 0.80, true, helpWindow)
		guiGridListSetSortingEnabled(topicList, false)

		-- Create the memo.
		helpMemo = guiCreateMemo(0.33, 0.09, 0.65, 0.80, "", true, helpWindow)
		guiMemoSetReadOnly(helpMemo, true)

		topicColumn = guiGridListAddColumn(topicList, "Topics", 0.85)
		
		-- Add topics.
		for i,v in pairs(itemList) do
			guiGridListSetItemText(topicList, guiGridListAddRow(topicList), topicColumn, v, false, false)
		end
		
		guiSetText(helpMemo, "<-- Click on a item to display topics.")
		guiSetVisible(helpWindow, false)
		guiWindowSetSizable(helpWindow, false)
		
		addEventHandler( "onClientMouseEnter", closeButton, function()
				if source ~= closeButton then return end
				anim = Animation.createAndPlay(closeButton, Animation.presets.guiPulse(600, 2))
			end
		)
		
		addEventHandler( "onClientMouseLeave", root, 
			function ()
				if (source == helpWindow or source == closeButton) then
					if anim then
						anim:remove(anim)
					end
					guiSetSize(closeButton, 124, 25, false)
					guiSetPosition(closeButton, 484, 386, false)
				end
			end
		)

	end
)

function helpInit()
	if guiGetVisible(helpWindow) then
		Animation.createAndPlay(helpWindow, Animation.presets.guiFadeOut(300))
		setTimer(guiSetVisible,350,1,helpWindow, false)
		showCursor(false)
	else
		setTimer( function()Animation.createAndPlay(helpWindow, Animation.presets.guiFadeIn(450)) end, 50, 1)
		guiSetVisible(helpWindow, true)
		guiSetAlpha(helpWindow, 0)
		showCursor(true)
	end
end


addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()),
	function()
		if source == closeButton then
			setTimer(guiSetVisible,350,1,helpWindow, false)
			Animation.createAndPlay(helpWindow, Animation.presets.guiFadeOut(300))
			showCursor(false)
		elseif source == topicList then
			selectedTopic = guiGridListGetItemText(topicList, guiGridListGetSelectedItem(topicList), 1)
			guiSetText(helpMemo, helpTopicText[selectedTopic])
		end
	end
)

-- ****************************
-- * Add all command handlers *
-- ****************************
addCommandHandler("gamehelp", helpInit)
bindKey('F9', 'down', 'gamehelp')

function hideWindow()
	Animation.createAndPlay(helpWindow, Animation.presets.guiFadeOut(300))
	setTimer(guiSetVisible,350,1,helpWindow, false)
	showCursor(false)
	--if anim2 then anim2:remove(anim2) end
end

function showWindow()
	setTimer( function()Animation.createAndPlay(helpWindow, Animation.presets.guiFadeIn(450)) end, 50, 1)
	guiSetVisible(helpWindow, true)
	showCursor(true)
end

--[[
	BUTTON ANIMATIONS

local btnanim = {}
addEventHandler( "onClientMouseEnter", root, function()
		if getElementType(source) ~= "gui-button" and getElementData(source,"button-pulse-disabled") then return end
		btnanim[source] = Animation.createAndPlay(closeButton, Animation.presets.guiPulse(600, 2))
	end
)
	
addEventHandler( "onClientMouseLeave", root, 
	function ()
		if getElementType(source) ~= "gui-button" and getElementData(source,"button-pulse-disabled") then return end
		if btnanim[source] then
			btnanim[source]:remove(btnanim[source])
		end
	end
)
 BUTTON ANIMATIONS END ]]-- Doesn't work.