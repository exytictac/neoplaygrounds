local screenWidth, screenHeight = guiGetScreenSize()

-- *********************************
-- *  User manager initialization  *
-- *********************************
function userManagerInit(source)
	if (isElement(userManagerWindow)) then
		showCursor(false)
		guiSetVisible(userManagerWindow, false)
		destroyElement(userManagerWindow)
		guiSetInputEnabled(false)
	else
		-- Create the window.
		userManagerWindow = guiCreateWindow((screenWidth / 2 - 250), (screenHeight / 2 - 225), 500, 450, "User manager", false)
	
		-- Create the "Close" button.
		userCloseButton = guiCreateButton(0.88, 0.92, 0.12, 0.06, "Close", true, userManagerWindow)
		userRefreshButton = guiCreateButton(0.75, 0.92, 0.12, 0.06, "Refresh", true, userManagerWindow)

		-- Create the users list.	
		usersList = guiCreateGridList(0.02, 0.06, 0.50, 0.84, true, userManagerWindow)
		userColumn = guiGridListAddColumn(usersList, "User", 0.50)
		accountColumn = guiGridListAddColumn(usersList, "Account", 1.20)
		triggerServerEvent("addUsersToList", resourceRoot, localPlayer)

		-- Create some radio buttons for selecting the class.
		userClassLabel = guiCreateLabel(0.53, 0.06, 0.12, 0.07, "Class:", true, userManagerWindow)
		userClassGuest = guiCreateRadioButton(0.53, 0.11, 0.45, 0.07, "Guest", true, userManagerWindow)
		userClassMember = guiCreateRadioButton(0.53, 0.15, 0.45, 0.07, "VIP", true, userManagerWindow)
		userClassModerator = guiCreateRadioButton(0.53, 0.19, 0.45, 0.07, "Moderator", true, userManagerWindow)
		userClassAdmin = guiCreateRadioButton(0.53, 0.23, 0.45, 0.07, "Administrator", true, userManagerWindow)

		-- Create some buttons.
		userManagmentLabel = guiCreateLabel(0.53, 0.35, 0.30, 0.07, "Managment:", true, userManagerWindow)
		userSetClassButton = guiCreateButton(0.53, 0.40, 0.45, 0.06, "Update class", true, userManagerWindow)
		guiSetFont(userSetClassButton, "default-bold-small")
		userRemoveUserButton = guiCreateButton(0.53, 0.47, 0.45, 0.06, "Remove user", true, userManagerWindow)
		guiSetFont(userRemoveUserButton, "default-bold-small")
		userBlacklistButton = guiCreateButton(0.53, 0.54, 0.45, 0.06, "Add to the blacklist", true, userManagerWindow)
		guiSetFont(userBlacklistButton, "default-bold-small")

		guiSetProperty(userSetClassButton, "Disabled", "True")
		guiSetProperty(userRemoveUserButton, "Disabled", "True")
		guiSetProperty(userBlacklistButton, "Disabled", "True")
		guiSetProperty(userClassGuest, "Disabled", "True")
		guiSetProperty(userClassMember, "Disabled", "True")
		guiSetProperty(userClassModerator, "Disabled", "True")
		guiSetProperty(userClassAdmin, "Disabled", "True")

		showCursor(true)
		guiWindowSetSizable(userManagerWindow, false)
		guiSetVisible(userManagerWindow, true)
	end
end

-- ********************
-- *  Event handlers  *
-- ********************
function onClick()
	if (source == userCloseButton) then
		if (updatePlayerInfoTimer ~= nil) then
			killTimer(updatePlayerInfoTimer)
			updatePlayerInfoTimer = nil
		end
	
		theSelectedPlayer = nil
		guiSetVisible(userManagerWindow, false)
		guiSetInputEnabled(false)
		showCursor(false)
	elseif (source == userSetClassButton) then
		selectedItem = guiGridListGetSelectedItem(usersList)
		if (selectedItem ~= -1) then
			selectedPlayer = guiGridListGetItemText(usersList, selectedItem, userColumn)
			local playerAcc = guiGridListGetItemText(usersList, selectedItem, accountColumn)
			if (guiRadioButtonGetSelected(userClassGuest)) then
				-- Set the player as a guest.
				triggerServerEvent("removePlayerFromGroups", root, playerAcc)
				triggerServerEvent("setPlayerAuth", root,  playerAcc, 0)
				outputChatBox("#FF0000*USER: #FFFF00" .. selectedPlayer:gsub('#%x%x%x%x%x%x', '') .. " is now a guest.", 255, 0, 0, true)
			elseif (guiRadioButtonGetSelected(userClassMember)) then
				-- Set the player as a member.
				triggerServerEvent("removePlayerFromGroups", root, playerAcc)
				triggerServerEvent("setPlayerAuth", root, playerAcc, 1)
				outputChatBox("#FF0000*USER: #FFFF00" .. selectedPlayer:gsub('#%x%x%x%x%x%x', '') .. " is now a VIP.", 255, 0, 0, true)
			elseif (guiRadioButtonGetSelected(userClassModerator)) then
				-- Set the player as a moderator.
				triggerServerEvent("addPlayerToModGroup", root, playerAcc)
				triggerServerEvent("setPlayerAuth", root, playerAcc, 2)
				outputChatBox("#FF0000*USER: #FFFF00" .. selectedPlayer:gsub('#%x%x%x%x%x%x', '') .. " is now a moderator.", 255, 0, 0, true)
			elseif (guiRadioButtonGetSelected(userClassAdmin)) then
				-- Set the player as an administrator.
				triggerServerEvent("addPlayerToAdminGroup", root, playerAcc)
				triggerServerEvent("setPlayerAuth", root, playerAcc, 3)
				outputChatBox("#FF0000*USER: #FFFF00" .. selectedPlayer:gsub('#%x%x%x%x%x%x', '') .. " is now an administrator.", 255, 0, 0, true)
			end
			
			onUpdateUserList()
		else
			outputChatBox("No user selected.", 255, 0, 0, true)
		end
	elseif (source == userRemoveUserButton) then
		selectedItem = guiGridListGetSelectedItem(usersList)
		if (selectedItem ~= -1) then
			local thePlayer = getPlayerFromName(guiGridListGetItemText(usersList, selectedItem, userColumn))
			triggerServerEvent("removeUser", localPlayer, guiGridListGetItemText(usersList, selectedItem, accountColumn))
			onUpdateUserList()
		end
	elseif (source == userBlacklistButton) then
		selectedItem = guiGridListGetSelectedItem(usersList)
		if (selectedItem ~= -1) then
			local theSerial = guiGridListGetItemText(usersList, selectedItem, accountColumn)
			triggerServerEvent("addUserToBlacklist", root, theSerial)
		end
	elseif (source == usersList) then
		selectedItem = guiGridListGetSelectedItem(usersList)
		if (selectedItem ~= -1) then
			guiSetProperty(userSetClassButton, "Disabled", "False")
			guiSetProperty(userRemoveUserButton, "Disabled", "False")
			guiSetProperty(userBlacklistButton, "Disabled", "False")
			guiSetProperty(userClassGuest, "Disabled", "False")
			guiSetProperty(userClassMember, "Disabled", "False")
			guiSetProperty(userClassModerator, "Disabled", "False")
			guiSetProperty(userClassAdmin, "Disabled", "False")
		
			local playerClass = tonumber(guiGridListGetItemData(usersList, selectedItem, userColumn))
			if (playerClass == 0) then
				guiRadioButtonSetSelected(userClassGuest, true)
				guiRadioButtonSetSelected(userClassMember, false)
				guiRadioButtonSetSelected(userClassModerator, false)
				guiRadioButtonSetSelected(userClassAdmin, false)
			elseif (playerClass == 1) then
				guiRadioButtonSetSelected(userClassGuest, false)
				guiRadioButtonSetSelected(userClassMember, true)
				guiRadioButtonSetSelected(userClassModerator, false)
				guiRadioButtonSetSelected(userClassAdmin, false)
			elseif (playerClass == 2) then
				guiRadioButtonSetSelected(userClassGuest, false)
				guiRadioButtonSetSelected(userClassMember, false)
				guiRadioButtonSetSelected(userClassModerator, true)
				guiRadioButtonSetSelected(userClassAdmin, false)
			elseif (playerClass == 3) then
				guiRadioButtonSetSelected(userClassGuest, false)
				guiRadioButtonSetSelected(userClassMember, false)
				guiRadioButtonSetSelected(userClassModerator, false)
				guiRadioButtonSetSelected(userClassAdmin, true)
			end
		else
			guiSetProperty(userSetClassButton, "Disabled", "True")
			guiSetProperty(userRemoveUserButton, "Disabled", "True")
			guiSetProperty(userBlacklistButton, "Disabled", "True")
			guiSetProperty(userClassGuest, "Disabled", "True")
			guiSetProperty(userClassMember, "Disabled", "True")
			guiSetProperty(userClassModerator, "Disabled", "True")
			guiSetProperty(userClassAdmin, "Disabled", "True")
		end
	end
end

function onUpdateUserList()
	guiGridListClear(usersList)
	triggerServerEvent("addUsersToList", resourceRoot, localPlayer)
end

addEvent("addOneUserToList", true)
addEventHandler("addOneUserToList", resourceRoot,
	function(playerName, playerClass, playerAcc)
		local row = guiGridListAddRow(usersList)
		guiGridListSetItemText(usersList, row, userColumn, playerName or "|FAILZ|", false, false)
		guiGridListSetItemData(usersList, row, userColumn, tostring(playerClass))
		if (playerClass == 0) then
			guiGridListSetItemColor(usersList, row, userColumn, 255, 255, 0)
		elseif (playerClass == 1) then
			guiGridListSetItemColor(usersList, row, userColumn, 0, 255, 0)
		elseif (playerClass == 2) then
			guiGridListSetItemColor(usersList, row, userColumn, 255, 128, 0)
		elseif (playerClass == 3) then
			guiGridListSetItemColor(usersList, row, userColumn, 255, 0, 0)
		end
		guiGridListSetItemText(usersList, row, accountColumn, playerAcc, false, false)
	end
)

-- *********************************
-- *  Event handlers registration  *
-- *********************************
addEvent("openUserManager", true)
addEventHandler("openUserManager", resourceRoot, userManagerInit)
addEventHandler("onClientGUIClick", resourceRoot, onClick)
addEventHandler("onUserJoin", root, onUpdateUserList)
addEventHandler("onUserUpdateData", root, onUpdateUserList)
