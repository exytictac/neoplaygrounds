misc = exports['misc']

-- ********************
-- * Command handlers *
-- ********************
addCommandHandler("usermanager",
	function(source)
		if (misc:isPlayerLoggedIn(source)) then
			local theAccount = getPlayerAccount(source)
			local theAccountName = getAccountName(theAccount)
			if (isObjectInACLGroup("user." .. theAccountName, aclGetGroup("Admin"))) then
				triggerClientEvent(source, "openUserManager", root)
			end
		elseif (misc:getAuth(source) == 3) then
			outputChatBox("#FF0000*INFO: #FFFF00You must be logged in to open the user manager.", source, 0, 0, 0, true)
		end
	end
)

-- ********************
-- *  Event handlers  *
-- ********************
addEvent("addUsersToList", true)
addEventHandler("addUsersToList", resourceRoot,
	function(admin)
		for _,a in pairs(getAccounts()) do
			if not admin then return end
			local player = getAccountPlayer(a)
			if player and getElementType(player) == "player" then
				setAccountData(a, "name", getPlayerName(player):gsub('#%x%x%x%x%x%x', ''))
			end
			
			-- Get player's nickname.
			local auth = tonumber(getAccountData(a, "auth", 0)) or 0
			local name = getAccountData(a, "name")
			local accn = getAccountName(a)
			triggerClientEvent(admin, "addOneUserToList", resourceRoot, name, auth, accn)
		end
	end
)

addEvent("setPlayerAuth", true)
addEventHandler("setPlayerAuth", resourceRoot,
	function(an, class)
		local a = getAccount(an)
		setAccountData(a, "auth", class)
		local p = getAccountPlayer(a)
		if (p) then
			setElementData(p, "auth", class, true)
			setPlayerNametagColor(p, unpack(classCol[class] or {255,255,0}))
			setPlayerNametagShowing(p, true)
			if (playerClass == 0) then
				outputChatBox("#FF0000*USER: #FFFF00You are now a guest.", p, 255, 0, 0, true)
			elseif (playerClass == 1) then
				outputChatBox("#FF0000*USER: #FFFF00You are now a VIP.", p, 255, 0, 0, true)
			elseif (playerClass == 2) then
				outputChatBox("#FF0000*USER: #FFFF00You are now a moderator.", p, 255, 0, 0, true)
			elseif (playerClass == 3) then
				outputChatBox("#FF0000*USER: #FFFF00You are now an administrator.", p, 255, 0, 0, true)
			end
		end
		triggerEvent("updateUserAuth", root, playerAccount, playerClass)
	end
)

addEvent("removeUser", true)
addEventHandler("removeUser", root,
	function(a)
		triggerEvent("removeUserData", source, a)
	end
)

addEvent("removePlayerFromGroups", true)
addEventHandler("removePlayerFromGroups", resourceRoot,
	function(pl)
		for _, theAccount in ipairs(getAccounts()) do
			if (getAccountName(theAccount) == pl) then
				-- Remove the player if he is in "Moderator" group.
				if (isObjectInACLGroup("user." .. pl, aclGetGroup("Moderator"))) then
					aclGroupRemoveObject(aclGetGroup("Moderator"), "user." .. pl)
				end

				-- Remove the player if he is in "Admin" group.
				if (isObjectInACLGroup("user." .. pl, aclGetGroup("Admin"))) then
					aclGroupRemoveObject(aclGetGroup("Admin"), "user." .. pl)
				end
				
				stopResource(getResouceFromName("admin"))
				setTimer(startResource,500, 1, getResouceFromName("admin"))

				-- Update ACL file.
				aclSave()
				
				return
			end
		end
	end
)

addEvent("addPlayerToModGroup", true)
addEventHandler("addPlayerToModGroup", resourceRoot,
	function(selectedPlayer)
		for _, theAccount in ipairs(getAccounts()) do
			if (getAccountName(theAccount) == selectedPlayer) then
				-- Add the player to the "Moderator" group.
				if (not isObjectInACLGroup("user." .. selectedPlayer, aclGetGroup("Moderator"))) then
					aclGroupAddObject(aclGetGroup("Moderator"), "user." .. selectedPlayer)
				end

				-- Remove the player if he is in "Admin" group.
				if (isObjectInACLGroup("user." .. selectedPlayer, aclGetGroup("Admin"))) then
					aclGroupRemoveObject(aclGetGroup("Admin"), "user." .. selectedPlayer)
				end
		
				-- Update ACL file.
				aclSave()
				
				return
			end
		end
	end
)

addEvent("addPlayerToAdminGroup", true)
addEventHandler("addPlayerToAdminGroup", resourceRoot,
	function(selectedPlayer)
		for _, theAccount in ipairs(getAccounts()) do
			if (getAccountName(theAccount) == selectedPlayer) then
				-- Add the player to the "Moderator" group.
				if (not isObjectInACLGroup("user." .. selectedPlayer, aclGetGroup("Moderator"))) then
					aclGroupAddObject(aclGetGroup("Moderator"), "user." .. selectedPlayer)
				end

				-- Add the player to the "Admin" group.
				if (not isObjectInACLGroup("user." .. selectedPlayer, aclGetGroup("Admin"))) then
					aclGroupAddObject(aclGetGroup("Admin"), "user." .. selectedPlayer)
				end
		
				-- Update ACL file.
				aclSave()
				
				return
			end
		end
	end
)

addEvent("addUserToBlacklist", true)
addEventHandler("addUserToBlacklist", root, 
	function(thePlayer)
		--[[ Feature cumming soon
		local blacklistNode = xmlLoadFile("blacklist.xml")
		if (blacklistNode) then
			serialNode = xmlCreateChild(blacklistNode, "serial")
			serial = getPlayerSerial(thePlayer)
			xmlNodeSetValue(accountNode, serial)
			xmlSaveFile(blacklistNode)
			xmlUnloadFile(blacklistNode)
			outputChatBox("#FF0000*USER: #FFFF00" .. getPlayerName(thePlayer):gsub('#%x%x%x%x%x%x', '') .. " has been added to the blacklist.", root, 0, 0, 0, true)
		end]]		
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function()
		for _,p in pairs(getElementsByType"player") do
			bindKey(p, 'f4', 'down', 'usermanager')
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		bindKey(source, 'f4', 'down', 'usermanager')
	end
)