
-- ******************************************
-- * AFS Staff / Staff panel                *
-- * Written by Tommy                       *
-- ******************************************

local screenWidth, screenHeight = guiGetScreenSize()

-- ******************************
-- *  Mod panel initialization  *
-- ******************************
function modPanelInit(source)
	local theWindow = guiGetVisible(modPanelWindow)
	if (theWindow == true) then
		showCursor(false)
		guiSetVisible(modPanelWindow, false)
		guiSetInputEnabled(false)
	else
		-- Create the window.
		modPanelWindow = guiCreateWindow((screenWidth / 2 - 250), (screenHeight / 2 - 150), 500, 300, "Staff panel", false)
	
		-- Create the "Close" button.
		closeButton = guiCreateButton(0.88, 0.88, 0.15, 0.15, "Close", true, modPanelWindow)

		-- Create the players list.
		client = getLocalPlayer()		
		playerList = guiCreateGridList(0.02, 0.09, 0.34, 0.88, true, modPanelWindow)
		local column = guiGridListAddColumn(playerList, "Players", 0.85)
		if (column) then
			for id, playeritem in ipairs(getElementsByType("player")) do
				if getElementData(playeritem, "playerClass") ~= false then
					local row = guiGridListAddRow(playerList)
					guiGridListSetItemText(playerList, row, column, getPlayerName(playeritem), false, false)
					if (getElementData(playeritem, "playerClass") == 1) then
						guiGridListSetItemColor(playerList, row, column, 255, 255, 0)
					elseif (getElementData(playeritem, "playerClass") == 2) then
						guiGridListSetItemColor(playerList, row, column, 0, 255, 0)
					elseif (getElementData(playeritem, "playerClass") == 3) then
						guiGridListSetItemColor(playerList, row, column, 255, 128, 0)
					elseif (getElementData(playeritem, "playerClass") == 4) then
						guiGridListSetItemColor(playerList, row, column, 255, 0, 0)
					end
				end
			end
		end
		
		guiSetVisible(playerList, true)

		-- Create a tab panel.
		local tabPanel = guiCreateTabPanel(0.38, 0.09, 0.62, 0.77, true, modPanelWindow)

		-- Add a tab for user information.
		local tabUserInfo = guiCreateTab("User info", tabPanel)

		-- Add an edit box with the name of the selected player.
		userNameLabel = guiCreateLabel(0.04, 0.04, 0.96, 0.07, "Name:", true, tabUserInfo)
		userNameEdit = guiCreateEdit(0.04, 0.12, 0.65, 0.12, "(no user selected)", true, tabUserInfo)
		
		-- Create "Change nick" button (useful for impersonators).
		renameButton = guiCreateButton(0.72, 0.12, 0.25, 0.12, "Change nick", true, tabUserInfo)
		guiSetFont(renameButton, "default-bold-small")

		-- Add some informations about the player (IP, serial, class, cheats...).
		userIPLabel = guiCreateLabel(0.04, 0.26, 0.6, 0.07, "IP:", true, tabUserInfo)
		userSerialLabel = guiCreateLabel(0.04, 0.34, 0.12, 0.07, "Serial:", true, tabUserInfo)
		userClassLabel = guiCreateLabel(0.04, 0.42, 0.12, 0.07, "Class:", true, tabUserInfo)
		userCheatsLabel = guiCreateLabel(0.04, 0.50, 0.13, 0.07, "Cheats:", true, tabUserInfo)
		
		userIPLabel2 = guiCreateLabel(0.10, 0.26, 0.80, 0.07, "...", true, tabUserInfo)
		userSerialLabel2 = guiCreateLabel(0.17, 0.34, 0.78, 0.07, "...", true, tabUserInfo)
		userClassLabel2 = guiCreateLabel(0.16, 0.42, 0.78, 0.07, "...", true, tabUserInfo)
		userCheatsLabel2 = guiCreateLabel(0.19, 0.50, 0.78, 0.07, "...", true, tabUserInfo)

		-- Add a tab for general moderation stuff.
		local tabGeneral = guiCreateTab("General", tabPanel)

		-- Create buttons.
		muteButton = guiCreateButton(0.02, 0.04, 0.22, 0.10, "Mute", true, tabGeneral)
		guiSetFont(muteButton, "default-bold-small")
		freezeButton = guiCreateButton(0.26, 0.04, 0.22, 0.10, "Freeze", true, tabGeneral)
		guiSetFont(freezeButton, "default-bold-small")
		ejectButton = guiCreateButton(0.50, 0.04, 0.22, 0.10, "Eject", true, tabGeneral)
		guiSetFont(ejectButton, "default-bold-small")
		burnButton = guiCreateButton(0.74, 0.04, 0.22, 0.10, "Burn", true, tabGeneral)
		guiSetFont(burnButton, "default-bold-small")
		arrestButton = guiCreateButton(0.02, 0.16, 0.22, 0.10, "Arrest", true, tabGeneral)
		guiSetFont(arrestButton, "default-bold-small")
		unarmButton = guiCreateButton(0.26, 0.16, 0.22, 0.10, "Unarm", true, tabGeneral)
		guiSetFont(unarmButton, "default-bold-small")
		killButton = guiCreateButton(0.50, 0.16, 0.22, 0.10, "Kill", true, tabGeneral)
		guiSetFont(killButton, "default-bold-small")
		bombButton = guiCreateButton(0.74, 0.16, 0.22, 0.10, "Bomb", true, tabGeneral)
		guiSetFont(bombButton, "default-bold-small")
		spectateButton = guiCreateButton(0.02, 0.28, 0.22, 0.10, "Spectate", true, tabGeneral)
		guiSetFont(spectateButton, "default-bold-small")
		slapButton = guiCreateButton(0.26, 0.28, 0.22, 0.10, "Slap", true, tabGeneral)
		guiSetFont(slapButton, "default-bold-small")

		-- Add a tab for kicks.
		local tabKick = guiCreateTab("Kick", tabPanel)

		-- Create an edit box for the reason of the kick.
		kickReasonLabel = guiCreateLabel(0.02, 0.02, 0.96, 0.07, "Reason:", true, tabKick)
		kickReasonEdit = guiCreateEdit(0.02, 0.10, 0.96, 0.1, "Enter the reason here.", true, tabKick)
		
		-- Create "Kick" button.
		kickButton = guiCreateButton(0.02, 0.22, 0.22, 0.10, "Kick", true, tabKick)
		guiSetFont(kickButton, "default-bold-small")
		kickInactiveButton = guiCreateButton(0.25, 0.22, 0.42, 0.10, "Kick for inactivity", true, tabKick)
		guiSetFont(kickInactiveButton, "default-bold-small")

		-- Add a tab for bans.
		local tabBan = guiCreateTab("Ban", tabPanel)

		-- Create an edit box for the reason of the ban.
		banReasonLabel = guiCreateLabel(0.02, 0.02, 0.96, 0.07, "Reason:", true, tabBan)
		banReasonEdit = guiCreateEdit(0.02, 0.10, 0.96, 0.1, "Enter the reason here.", true, tabBan)

		-- Create an edit box for the duration of the ban.
		banTimeLabel = guiCreateLabel(0.02, 0.23, 0.96, 0.07, "Duration of the ban (0 = unlimited):", true, tabBan)
		banTimeEdit = guiCreateEdit(0.02, 0.31, 0.96, 0.1, "0", true, tabBan)

		-- Create some checkboxes.
		banIPCheck = guiCreateCheckBox(0.02, 0.45, 0.96, 0.10, "Ban this player by IP", true, true, tabBan)
		banUserNameCheck = guiCreateCheckBox(0.02, 0.55, 0.96, 0.10, "Ban this player by username", false, true, tabBan)
		banSerialCheck = guiCreateCheckBox(0.02, 0.65, 0.96, 0.10, "Ban this player by serial", false, true, tabBan)

		-- Create "Ban" button.
		banButton = guiCreateButton(0.02, 0.77, 0.22, 0.10, "Ban", true, tabBan)
		guiSetFont(banButton, "default-bold-small")
		
		-- Add a tab for warning stuff.
		local tabWarn = guiCreateTab("Warn", tabPanel)
		
		-- Create an edit box for the message to shout.
		warnLabel = guiCreateLabel(0.02, 0.02, 0.96, 0.07, "Message to display on the screen of the player:", true, tabWarn)
		warnEdit = guiCreateMemo(0.02, 0.10, 0.96, 0.35, "", true, tabWarn)
		
		-- Create "Warn" buttons.
		warnButton = guiCreateButton(0.02, 0.47, 0.28, 0.10, "Warn player", true, tabWarn)
		guiSetFont(warnButton, "default-bold-small")
		warnAllButton = guiCreateButton(0.32, 0.47, 0.34, 0.10, "Warn all players", true, tabWarn)
		guiSetFont(warnAllButton, "default-bold-small")

		-- Create labels which contains the version number.
		version1Label = guiCreateLabel(0.38, 0.89, 0.30, 0.05, "Staff Panel - Version 1.2", true, modPanelWindow)
		version2Label = guiCreateLabel(0.38, 0.93, 0.30, 0.05, "Written by Tommy", true, modPanelWindow)
		guiSetFont(version1Label, "default-small")
		guiSetFont(version2Label, "default-small")

		showCursor(true)
		guiWindowSetSizable(modPanelWindow, false)
		guiSetVisible(modPanelWindow, true)
		guiSetInputEnabled(true)
	end
end

-- ********************
-- *  Event handlers  *
-- ********************
function updateMuteButton(thePlayer, isMuted)
	if (isMuted == true) then
		guiSetText(muteButton, "Unmute")
	else
		guiSetText(muteButton, "Mute")
	end
end

function updateFreezeButton(thePlayer, isFrozen)
	if (isFrozen == true) then
		guiSetText(freezeButton, "Unfreeze")
	else
		guiSetText(freezeButton, "Freeze")
	end
end

function updateEjectButton(thePlayer, isInVehicle)
	if (isInVehicle == true) then
		guiSetProperty(ejectButton, "Disabled", "True")
	else
		guiSetProperty(ejectButton, "Disabled", "False")
	end
end

function updateArrestButton(thePlayer, isInJail)
	if (isInJail == true) then
		guiSetText(arrestButton, "Release")
	else
		guiSetText(arrestButton, "Arrest")
	end
end

function updateUserInfo(thePlayer, playerIP, playerSerial, playerClass, cheatsCount)
	guiSetText(userIPLabel2, playerIP)
	guiSetText(userSerialLabel2, playerSerial)
	guiSetText(userCheatsLabel2, cheatsCount)
	
	if (playerClass == 2) then
		guiSetText(userClassLabel2, "Member")
		guiLabelSetColor(userClassLabel2, 0, 255, 0)
	elseif (playerClass == 3) then
		guiSetText(userClassLabel2, "Moderator")
		guiLabelSetColor(userClassLabel2, 255, 128, 0)
	elseif (playerClass == 4) then
		guiSetText(userClassLabel2, "Administrator")
		guiLabelSetColor(userClassLabel2, 255, 0, 0)
	else
		guiSetText(userClassLabel2, "Guest")
		guiLabelSetColor(userClassLabel2, 255, 255, 0)
	end
end

function updateSpectateButton(thePlayer, isSpectated)
	if (isSpectated == true) then
		guiSetText(spectateButton, "Unspectate")
	else
		guiSetText(spectateButton, "Spectate")
	end
end

function updateSpectateButton2(thePlayer, disableButton)
	if (disableButton == true) then
		guiSetProperty(spectateButton, "Disabled", "True")
	else
		guiSetProperty(spectateButton, "Disabled", "False")
	end
end

function onClickPlayerList()
	if (source == playerList) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			guiSetText(userNameEdit, selectedPlayer)
			triggerServerEvent("updateGui", getRootElement(), selectedPlayer, client)
		end
	end
end

function onClose()
	if (source == closeButton) then
		guiSetVisible(modPanelWindow, false)
		guiSetInputEnabled(false)
		showCursor(false)
	end
end

function onMutePlayer()
	if (source == muteButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffMutePlayer", getRootElement(), selectedPlayer, client)
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onKickPlayer()
	if (source == kickButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffKickPlayer", getRootElement(), selectedPlayer, client, guiGetText(kickReasonEdit))
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	elseif (source == kickInactiveButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffKickInactivePlayer", getRootElement(), selectedPlayer, client, "You have been kicked for inactivity.")
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onBanPlayer()
	if (source == banButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffBanPlayer", getRootElement(), selectedPlayer, client, guiGetText(banReasonEdit), guiGetText(banTimeEdit), guiCheckBoxGetSelected(banIPCheck), guiCheckBoxGetSelected(banUserNameCheck), guiCheckBoxGetSelected(banSerialCheck))
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onFreezePlayer()
	if (source == freezeButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffFreezePlayer", getRootElement(), selectedPlayer, client)
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onEjectPlayer()
	if (source == ejectButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffEjectPlayer", getRootElement(), selectedPlayer, client)
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onBurnPlayer()
	if (source == burnButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffBurnPlayer", getRootElement(), selectedPlayer, client)
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onUnarmPlayer()
	if (source == unarmButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffUnarmPlayer", getRootElement(), selectedPlayer, client)
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onArrestPlayer()
	if (source == arrestButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffArrestPlayer", getRootElement(), selectedPlayer, client)
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onKillPlayer()
	if (source == killButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffKillPlayer", getRootElement(), selectedPlayer, client)
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onBombPlayer()
	if (source == bombButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffBombPlayer", getRootElement(), selectedPlayer, client)
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onRenamePlayer()
	if (source == renameButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffRenamePlayer", getRootElement(), selectedPlayer, client, guiGetText(userNameEdit))
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onSpectatePlayer()
	if (source == spectateButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffSpectatePlayer", getRootElement(), selectedPlayer, client)
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onWarnPlayer()
	if (source == warnButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)  
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffWarnPlayer", getRootElement(), selectedPlayer, client, guiGetText(warnEdit))
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

function onWarnAllPlayers()
	if (source == warnAllButton) then
		triggerServerEvent("StaffWarnAllPlayers", getRootElement(), client, guiGetText(warnEdit))
	end
end

function onSlapPlayer()
	if (source == slapButton) then
		selectedPlayer = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 1)   
		if (guiGridListGetSelectedItem(playerList) ~= -1) then
			triggerServerEvent("StaffSlapPlayer", getRootElement(), selectedPlayer, client)
		else
			outputChatBox("No player selected.", 255, 0, 0, true)
		end
	end
end

-- *********************************
-- *  Event handlers registration  *
-- *********************************
addEvent("openModPanel", true)
addEventHandler("openModPanel", getResourceRootElement(getThisResource()), modPanelInit)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onClose)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onClickPlayerList)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onMutePlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onKickPlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onBanPlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onFreezePlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onEjectPlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onBurnPlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onUnarmPlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onArrestPlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onKillPlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onBombPlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onRenamePlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onSpectatePlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onWarnPlayer)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onWarnAllPlayers)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onSlapPlayer)

addEvent("updateMuteButton", true)
addEventHandler("updateMuteButton", getRootElement(), updateMuteButton)
addEvent("updateFreezeButton", true)
addEventHandler("updateFreezeButton", getRootElement(), updateFreezeButton)
addEvent("updateEjectButton", true)
addEventHandler("updateEjectButton", getRootElement(), updateEjectButton)
addEvent("updateArrestButton", true)
addEventHandler("updateArrestButton", getRootElement(), updateArrestButton)
addEvent("updateSpectateButton", true)
addEventHandler("updateSpectateButton", getRootElement(), updateSpectateButton)
addEvent("updateSpectateButton2", true)
addEventHandler("updateSpectateButton2", getRootElement(), updateSpectateButton2)
addEvent("updateUserInfo", true)
addEventHandler("updateUserInfo", getRootElement(), updateUserInfo)
