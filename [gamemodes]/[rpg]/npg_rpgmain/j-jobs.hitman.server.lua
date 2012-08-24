--[[
	RPG Jobs v2.0.1 [hitman.server]
	
	Made By: JR10
	
	Copyright (c) 2011
]]

addCommandHandler("contract",
	function(source, _, name, amount)
	if getElementData ( source, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(source, "Hitman") then return outputChatBox("You can't put a contract on players because your a hitman", source, 192, 192, 192) end
		if not name or not amount then return outputChatBox("Syntax: /contract <partial name> <amount>", source, 192, 192, 192) end
		local target = findPlayer(name, source)
		if target then
			if isPlayerInTeam(source, "Hitman") then return outputChatBox("You can't put a contract on that player because he is a hitman", source, 192, 192, 192) end
			if tonumber(amount) == nil then return outputChatBox("Type in a correct amount", source, 192, 192, 192) end
			amount = tonumber(amount)
			if getPlayerMoney(source) < amount then return outputChatBox("You can't afford that much", source, 192, 192, 192) end
			if amount < 1000 then return outputChatBox("You can't put a contract with less than $1000", source, 192, 192, 192) end
			setElementData(target, "gotContract", true)
			setElementData(target, "contractAmmount", amount)
			takePlayerMoney(source, amount)
			outputChatBox("Contract: "..getPlayerName(source).." has put a contract on "..getPlayerName(target).." for $"..amount, root, 150, 150, 150)
			for index , hitman in ipairs ( getPlayersInTeam ( getTeamFromName ( "Hitman" ) ) ) do
				outputChatBox ( "Hitman Claude: Go get him boys!" , hitman , settingHitmanTeamColor [ 1 ], settingHitmanTeamColor [ 2 ] , settingHitmanTeamColor [ 3 ] )
			end
		end
	end
)

addEventHandler("onPlayerWasted", root,
	function(_,killer)
	if getElementData ( source, "gamemode" ) ~= "rpg" then return end
		if not getElementData(source, "gotContract") then return end
		if not isPlayerInTeam(killer, "Hitman") then return end
		outputChatBox(getPlayerName(killer).." has fulfilled the contract on "..getPlayerName(source).." for $"..getElementData(source, "contractAmmount"), root, 150, 150, 150)
		givePlayerMoney(killer, getElementData(source, "contractAmmount"))
		setElementData(source, "gotContract", false)
		setElementData(source, "contractAmmount", 0)
	end
)

addCommandHandler("contracts",
	function(player)
	if getElementData ( source, "gamemode" ) ~= "rpg" then return end
		if isPlayerInTeam(player, "Hitman") then
			outputChatBox("==== Contracted Players: ====", player, 255, 255, 0)
			for i, v in ipairs(getElementsByType("player")) do
				if getElementData(v, "gotContract") then
					outputChatBox(getPlayerName(v).." #FFFF00("..getElementData(v, "contractAmmount")..")", player, 255, 255, 255, true)
				end
			end
		else
			outputChatBox("You are not a hitman", player)
		end
	end
)