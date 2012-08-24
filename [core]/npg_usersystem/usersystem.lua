misc = exports['misc']

-- ***************************
-- *   Events registration   *
-- ***************************
addEvent("onUserJoin", true)
addEvent("onUserJoinFirstTime", true)
addEvent("onUserUpdate", true)


-- ***************
-- *  Functions  *
-- ***************
addEvent("loadUserData", true)
addEventHandler("loadUserData", root, 
	function(thePlayer)
	    local account = getPlayerAccount(thePlayer)
		-- Set player class.
		local classNode = getAccountData(account, "auth")
		setElementData(thePlayer, "auth", tonumber(classNode) or 0)
	
		-- Set player money.
		local moneyNode = getAccountData(account, "money")
		setPlayerMoney(thePlayer, tonumber(moneyNode) or 0)
		
		-- Set ban boolean status 
		local ban = getAccountData(account, "banned")
		setElementData(thePlayer, "ban", tonumber(ban) or false)

		-- Set player skin.
		local skinNode = getAccountData(account, "skin")
		setPedSkin(thePlayer, tonumber(skinNode) or 0)
		setElementData(thePlayer, "skin", tonumber(skinNode) or 0)

		-- Set warn level.
		local warnNode = getAccountData(account, "warning")
		setElementData(thePlayer, "warning", tonumber(warnNode) or 0)
		
		-- Set timespent
		local ts = getAccountData(account, "timeSpent")
		setElementData(thePlayer, "timeSpent", tonumber(ts)or 0)
		
		-- Email
		local email = getAccountData(account, "email")
		setElementData(thePlayer, "email", tonumber(email) or false)

		-- Set name
		setAccountData(account, "name", getPlayerName(thePlayer))
		
		-- Set points
		local points = getAccountData(account, "points")
		setElementData ( thePlayer, "points", tonumber(points) or 0 )
		
		-- Set achievements
		local achievements = getAccountData(account, "achievements")
		setElementData ( thePlayer, "achievements", tonumber(achievements) or 0 )
	end
)

addEvent("updateUserAuth", true)
addEventHandler("updateUserAuth", root, 
	function(playerAccount, auth)		
		triggerEvent("onUserUpdateData", root)
	end
)

addEvent("removeUserData", true)
addEventHandler("removeUserData", root,
	--[[
		SOURCE: CLIENT ADMIN
		ARG1  : ACCOUNT NAME
	]]--
	function(name)
		--if getElementData(source, "auth") ~= 3 then return end -- or report?
		local a = getAccount(name)
		if a then
			local p = getAccountPlayer(a)
			if p then
				kickPlayer(p)
			end
			removeAccount(a)
			return
		end
		outputChatBox('Account not found!', source)
	end
)

addEvent("saveUserData", true)
addEventHandler("saveUserData", root, 
	function(thePlayer)
	    local account = getPlayerAccount(thePlayer)
		-- Save player class.
		setAccountData(account, "auth", tostring(getElementData(thePlayer, "auth") or 0))
	
		-- Save player money.
		if misc:getGamemodeName ( thePlayer ) == "rpg" then
			setAccountData ( account, "rpgmoney", tostring(getPlayerMoney(thePlayer)))
		elseif misc:getGamemodeName ( thePlayer ) == "freeroam" then
			setAccountData ( account, "freeroammoney", tostring(getPlayerMoney(thePlayer)))
		elseif misc:getGamemodeName ( thePlayer ) == "manhunt" then
			setAccountData ( account, "mhmoney", tostring(getPlayerMoney(thePlayer)))
		end

		-- Save player skin.
		if misc:getGamemodeName ( thePlayer ) == "rpg" then
			setAccountData(account, "skin", tostring(getPedSkin(thePlayer)))
		else
			cancelEvent ( )
		end

		-- Save warn level.
		setAccountData(account, "warning", tostring(getElementData(thePlayer, "warning")))
		
		-- Last username
		setAccountData(account, "name", tostring(getPlayerName(thePlayer):gsub('#%x%x%x%x%x%x', '')))
		
		
		-- Save time spent on the server.
		setAccountData(account, "timeSpent", tostring(getElementData(thePlayer, "timeSpent")))
		
		-- Email
		setAccountData(account, "email", tostring(getElementData(thePlayer, "email")))
		
		-- Save points
		setAccountData(account, "points", tostring(getElementData(thePlayer, "points")))
		
		-- Save achievements
		setAccountData(account, "achievements", tostring(getElementData(thePlayer,"achievements")))
		
		triggerEvent("onUserUpdateData", root)
	end
)

addEvent("buildUserData", true)
addEventHandler("buildUserData", root,
	function(a, email)
		acc = getPlayerAccount(source)
		setAccountData ( acc, "rpg.newUser", true )
		setAccountData ( acc, "freeroam.newUser", true )
		setAccountData ( acc, "manhunt.newUser", true )
		setAccountData ( acc, "race.newUser", true )
		setAccountData ( acc, "koth.newUser", true )
		setAccountData ( acc, "email", tostring( email ) )
		setAccountData ( acc, "general.rulesRead", false )
		setAccountData ( acc, "points", 0 )
		setAccountData ( acc, "warning", 0 )
		--setAccountData ( acc, "achievements", 0 ) -- not used for now -- Aero.
	end
)