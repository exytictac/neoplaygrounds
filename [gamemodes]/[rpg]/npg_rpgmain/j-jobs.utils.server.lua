--[[
	RPG Jobs v2.0.1 [utils.server]
	
	Made By: JR10
	
	Copyright (c) 2011
]]

function getPlayersFromGamemode( gm )
   local tab = {}
   for i,v in ipairs(getElementsByType'player') do
     if getElementData(v, 'gamemode') == gm then table.insert(tab, v) end 
   end
   return tab
end

RPGDimension = 100
addEvent ( "onRPGEnter", true )
function onResourceStart()
	if getElementData ( source, "gamemode" ) ~= "rpg" then 
		local team = createTeam("Police", settingPoliceTeamColor [ 1 ] , settingPoliceTeamColor [ 2 ] , settingPoliceTeamColor [ 3 ])
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		team = createTeam("Mechanic", settingMechanicTeamColor [ 1 ] , settingMechanicTeamColor [ 2 ] , settingMechanicTeamColor [ 3 ] )
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		team = createTeam("Trader", settingTraderTeamColor [ 1 ] , settingTraderTeamColor [ 2 ] , settingTraderTeamColor [ 3 ])
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		team = createTeam("Hitman", settingHitmanTeamColor [ 1 ], settingHitmanTeamColor [ 2 ] , settingHitmanTeamColor [ 3 ] )
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		team = createTeam("Seeker", settingSeekerTeamColor [ 1 ] , settingSeekerTeamColor [ 2 ] , settingSeekerTeamColor [ 3 ])
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		team = createTeam("Off Duty Workers", settingOffdutyTeamColor [ 1 ] , settingOffdutyTeamColor [ 2 ], settingOffdutyTeamColor [ 3 ])
		team = createTeam("Taxi Driver", settingTaxiTeamColor [ 1 ] , settingTaxiTeamColor [ 2 ], settingTaxiTeamColor [ 3 ])
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		team = createTeam("Bus Driver", settingBusTeamColor [ 1 ] , settingBusTeamColor [ 2 ], settingBusTeamColor [ 3 ])
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		team = createTeam("Military", settingMilitaryTeamColor [ 1 ] , settingMilitaryTeamColor [ 2 ], settingMilitaryTeamColor [ 3 ])
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		team = createTeam("Medic", settingMedicTeamColor [ 1 ] , settingMedicTeamColor [ 2 ], settingMedicTeamColor [ 3 ])
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		team = createTeam("Limo Driver", settingLimoTeamColor [ 1 ] , settingLimoTeamColor [ 2 ], settingLimoTeamColor [ 3 ])
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		team = createTeam("Pizza Driver", settingPizzaTeamColor [ 1 ] , settingPizzaTeamColor [ 2 ], settingPizzaTeamColor [ 3 ])
		setTeamFriendlyFire(team, settingFriendlyFireForTeams)
		
		for index , player in ipairs (getPlayersInGamemode ( 'rpg' )) do
			if not isGuestAccount ( getPlayerAccount ( player ) ) then
				setTimer ( function ( ) loadPlayerData ( player , getPlayerAccount ( player ) ) end , 100 , 1 )
			end
		end
	else
		return 
	end
end
addEventHandler ( "onResourceStart", resourceRoot, onResourceStart ) 
addEventHandler( "onRPGEnter", root, onResourceStart )

local jobsTable = {
	{ "Police" , settingPoliceCharName , settingPoliceCharSkinID , 249.8349609375 , 64.794921875 , 1003.640625 , 6 , 1 , 90 , settingPoliceTeamColor } ,
	{ "Trader" , settingTraderCharName , settingTraderCharSkinID , 2730.0078125 , -2448.9501953125 , 17.593746185303 , 0 , 100 , 270 , settingTraderTeamColor } ,
	{ "Mechanic" , settingMechanicCharName , settingMechanicCharSkinID , 1019.3642578125 , -1030.1787109375 , 32.068668365479 , 0 , 100 , 185 , settingMechanicTeamColor } ,
	{ "Hitman" , settingHitmanCharName , settingHitmanCharSkinID , 1658.2431640625 , -1343.298828125 , 17.437274932861 , 0 , 100 , 90 , settingHitmanTeamColor } ,
	{ "Seeker" , settingSeekerCharName , settingSeekerCharSkinID , 1310.185546875 , -1367.7626953125 , 13.540292739868 , 0 , 100 , 180 , settingSeekerTeamColor } ,
	{ "Taxi Driver" , settingTaxiCharName , settingTaxiCharSkinID , 1813.84253, -1902.89282, 13.09054 , 0 , 100 , 180 , 
	settingTaxiTeamColor } ,
	{ "Bus Driver" , settingBusCharName , settingBusCharSkinID , 1097.46985, -1796.40710, 13.60466, 0 , 100 , 180 , 
	settingBusTeamColor } ,
	{ "Military" , settingMilitaryCharName , settingMilitaryCharSkinID , 2701.91211, -2397.53784, 13.63281, 0 , 100 , 180 , 
	settingMilitaryTeamColor } , 
	{ "Limo Driver" , settingLimoCharName , settingLimoCharSkinID , 1696.18848, -1616.73340, 13.54688, 0 , 100 , 180 , 
	settingLimoTeamColor } , 
	{ "Medic" , settingMedicCharName , settingMedicCharSkinID , 1177.58691, -1319.79858, 14.07804, 0 , 100 , 180 , 
	settingMedicTeamColor },
	{ "Pizza Driver", settingPizzaCharName, settingPizzaCharSkinID, 2094.11572, -1810.48669, 13.55028, 0, 100, 180, 
	settingPizzaTeamColor }
	
}

for index , teamData in ipairs ( jobsTable ) do
	local teamName , charName , charSkin , posX , posY , posZ , interior , dimension , rotation , RGBTable = unpack ( teamData )
	local ped = createPed ( charSkin , posX , posY , posZ )
	if not ped then
		outputChatBox('qaisjpDebugSystem: INDEX:'..index..' c#c1:'..teamName)
	end
	setElementRotation ( ped , 0 , 0 , rotation )
	setElementInterior ( ped , interior )
	setElementDimension ( ped , dimension )
	setElementData ( ped , "charName" , charName )
	setElementData ( ped , "teamName" , teamName )
	setElementData ( ped , "RGB" , RGBTable )
	setElementFrozen ( ped , true )
	addEventHandler ( "onElementClicked" , ped ,
		function ( button , state , player )
			if button ~= "left" or state ~= "up" then
				return
			end
			local teamName = getElementData ( source , "teamName" )
			if teamName == "Police" then
				if getPlayerWantedLevel ( player ) > 0 then
					outputChatBox ( "You are wanted" , player )
					return
				end
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingPoliceTeamColor )
			elseif teamName == "Trader" then
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingTraderTeamColor )
			elseif teamName == "Mechanic" then
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingMechanicTeamColor )
			elseif teamName == "Hitman" then
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingHitmanTeamColor )
			elseif teamName == "Seeker" then
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingSeekerTeamColor )
			elseif teamName == "Taxi Driver" then
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingTaxiTeamColor )
			elseif teamName == "Bus Driver" then
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingBusTeamColor )
			elseif teamName == "Military" then
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingMilitaryTeamColor )
			elseif teamName == "Limo Driver" then
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingLimoTeamColor )
			elseif teamName == "Medic" then
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingMedicTeamColor )
			elseif teamName == "Pizza Driver" then
				triggerClientEvent ( player , "client:showTeamCheckGUI" , player , teamName , settingMedicTeamColor )
			end
		end
	)
end

setTimer (
	function ( )
		b1 = createBlip ( 1544.599609375, -1675.6923828125, 13.558725357056 , settingPoliceHQBlip )
			setElementDimension ( b1, RPGDimension )
		b2 = createBlip ( 2730.0078125 , -2448.9501953125 , 17.593746185303 , settingTraderHQBlip )
			setElementDimension ( b2, RPGDimension )
		b3 = createBlip ( 1658.2431640625 , -1343.298828125 , 17.437274932861 , settingHitmanHQBlip )
			setElementDimension ( b3, RPGDimension )
		b4 =createBlip ( 1019.3642578125 , -1030.1787109375 , 32.068668365479 , settingMechanicHQBlip )
			setElementDimension ( b4, RPGDimension )
		b5 = createBlip ( 1310.185546875 , -1367.7626953125 , 13.540292739868 , settingSeekerHQBlip )
			setElementDimension ( b5, RPGDimension )
		b6 = createBlip ( 1813.84253, -1902.89282, 13.09054 , settingTaxiHQBlip )
			setElementDimension ( b6, RPGDimension )
		b7 = createBlip ( 1097.46985, -1796.40710, 13.60466 , settingBusHQBlip )
			setElementDimension ( b7, RPGDimension )
		b8 = createBlip ( 1696.18848, -1616.73340, 13.54688, settingLimoHQBlip )
			setElementDimension ( b8, RPGDimension )
		b9 = createBlip ( 2701.91211, -2397.53784, 13.63281, settingMilitaryHQBlip )
			setElementDimension ( b9, RPGDimension )
		b10 = createBlip ( 1177.58691, -1319.79858, 14.07804, settingMedicHQBlip )
			setElementDimension ( b10, RPGDimension )
		b11 = createBlip ( 2094.11572, -1810.48669, 13.55028, settingPizzaHQBlip )
			setElementDimension ( b11, RPGDimension )
	end
, 100 , 1 )

function findTeam(name, resPlayer)
	local matches = {}
	for i, v in ipairs(getElementsByType("team")) do
		if getTeamName(v) == name then
			return v
		end
		local teamName = getTeamName(v):lower()
		if teamName:find(name:lower(), 0) then
			table.insert(matches, v)
		end
	end
	if #matches == 1 then
		return matches[1]
	else
		outputChatBox("Found "..#matches.." teams with that partial name", resPlayer)
	end
	return false
end

function findPlayer ( partialName , resPlayer )
	if partialName and resPlayer then
		local matches = {}
		for i, player in ipairs ( getElementsByType ( "player" ) ) do
			if getPlayerName ( player ) == partialName then
				return player
			end
			if getPlayerName ( player ) : gsub ( "#%x%x%x%x%x%x" , "" ) : lower ( ) : find ( partialName : lower ( ) ) then
				table.insert ( matches , player )
			end
		end
		if #matches == 1 then
			return matches [ 1 ]
		else
			outputChatBox ( "Found "..#matches.." matches" , resPlayer , 255 , 0 , 0 )
		end
	else
		outputDebugString ( "findPlayer Missing Arguments In Resource " .. getResourceName ( getThisResource ( ) ) , 3)
	end
	return false
end

function isPlayerInTeam(src, TeamName)
	if src and isElement ( src ) and getElementType ( src ) == "player" then
		local team = getPlayerTeam(src)
		if team then
			if getTeamName(team) == TeamName then
				return true
			else
				return false
			end
		end
	end
end

function isPlayerAdmin(player, right)
	if right then
		if hasObjectPermissionTo ( player, right, false ) then
			return true
		else
			return false
		end
	else
		outputDebugString("isPlayerAdmin Missing Arguments", 3)
	end
end

function isPlayerInRangeOfPoint(player, x, y, z, range)
	local px, py, pz = getElementPosition(player)
	return ((x-px)^2+(y-py)^2+(z-pz)^2)^0.5 <= range
end

function isPlayerInStandardTeams(player)
	if getPlayerTeam(player) then
		if getTeamName(getPlayerTeam(player)) == "Police" or  getTeamName(getPlayerTeam(player)) == "Trader" or getTeamName(getPlayerTeam(player)) == "Hitman" or getTeamName(getPlayerTeam(player)) == "Mechanic" or getTeamName ( getPlayerTeam ( player ) ) == "Seeker" or getTeamName ( getPlayerTeam ( player ) ) == "Bus Driver" or getTeamName ( getPlayerTeam ( player ) ) == "Taxi Driver" or getTeamName ( getPlayerTeam ( player ) ) == "Limo Driver" or getTeamName ( getPlayerTeam ( player ) ) == "Military" or getTeamName ( getPlayerTeam ( player ) ) == "Medic" or getTeamName ( getPlayerTeam ( player ) ) == "Pizza Driver" then
			return true
		else
			return false
		end
	end
end

addCommandHandler("setteam",
	function(player, _, targetName, teamName, skin)
		if isPlayerAdmin(player, "function.banPlayer") then
			if not targetName or not teamName then return outputChatBox("Syntax: /setteam <player partial name> <team partial name ('nil' to remove the player from his team)>", player) end
			local target = findPlayer(targetName, player)
			if target then
				if teamName == "nil" then
					setPlayerTeam(target, nil)
					outputChatBox(getPlayerName(target).." was removed from his team by "..getPlayerName(player), root, 255, 0, 0)
				else
					local team = findTeam(teamName, player)
					if team then
						local r, g, b = getTeamColor(team)
						setPlayerTeam(target, team)
						outputChatBox(getPlayerName(target).." was moved to "..getTeamName(team).." team by "..getPlayerName(player), root, r, g, b)
					end
				end
			end
		else
			outputChatBox("You are not authorized to use this command", player)
		end
	end
)





addEventHandler("onPlayerQuit", root,
	function()
	if getElementData ( source, "gamemode" ) ~= "rpg" then return end
		if isGuestAccount(getPlayerAccount(source)) then return end
		savePlayerData(source, getPlayerAccount(source))
	end
)

addEventHandler("onPlayerLogout", root,
	function(account, _)
		savePlayerData(source, account)
	end
)

addEventHandler("onPlayerSpawn", root,
	function()
	if getElementData ( source, "gamemode" ) == "rpg" then 
		if isPlayerInTeam(source, "Mechanic") then
			setElementModel(source, 50)
			giveWeapon(source, 41, 3000)
		end
		if isPlayerInTeam(source, "Hitman") then
			setElementModel(source, 299)
			giveWeapon(source, 30, 300)
			giveWeapon(source, 18, 20)
		end
		if isPlayerInTeam(source, "Police") then
			setElementModel(source, 265)
			giveWeapon(source, 3)
			giveWeapon(source, 22, 300)
			giveWeapon(source, 16, 20)
		end
		if isPlayerInTeam(source, "Bus Driver") then
			setElementModel(source, 61)
		end
		if isPlayerInTeam(source,"Taxi Driver") then
			setElementModel(source, 253)
		end
		if isPlayerInTeam(source,"Military") then
			setElementModel(source, 287)
			giveWeapon ( source, 31, 500 )
		end
		if isPlayerInTeam(source,"Limo Driver") then
			setElementModel(source, 255)
		end
		if isPlayerInTeam(source,"Medic") then
			setElementModel(source, 274)
		end
		if isPlayerInTeam ( source, "Seeker" ) then
			setElementModel( source, 249 )
		end
		if isPlayerInTeam ( source, "Pizza Driver" ) then
			setElementModel( source, 155 )
		end
	else
		return end
	end
)

addEvent ( "server:sendSettings" , true )
addEventHandler ( "server:sendSettings" , root ,
	function ( )
		triggerClientEvent ( source , "client:recieveSettings" , source , settingTraderTeamColor , settingMechanicTeamColor , settingHitmanTeamColor, settingPoliceTeamColor, settingMilitaryTeamColor, settingBusTeamColor, settingMedicTeamColor, settingLimoTeamColor, settingTaxiTeamColor, settingPizzaTeamColor, settingOffdutyTeamColor , settingShowCursor , settingDutyKey )
	end
)

addEvent ( "server:setPlayerTeam" , true )
addEventHandler ( "server:setPlayerTeam" , root ,
	function ( teamName )
		if getPlayerTeam ( source ) == getTeamFromName ( teamName ) then
			outputChatBox ( "You are already in " .. teamName .. " team" , source )
			return
		end
		setPlayerTeam ( source , getTeamFromName ( teamName ) )
		local r , g , b = getTeamColor ( getTeamFromName ( teamName ) )
		outputChatBox ( getPlayerName ( source ) .. " has joined " .. teamName .. " team" , root , r , g , b )
		if teamName == "Mechanic" then
			setElementModel(source, 50)
			giveWeapon(source, 41, 3000)
		elseif teamName == "Hitman" then
			setElementModel(source, 299)
			giveWeapon(source, 30, 300)
			giveWeapon(source, 18, 20)
		elseif teamName == "Police" then
			setElementModel(source, 265)
			giveWeapon(source, 3)
			giveWeapon(source, 22, 300)
			giveWeapon(source, 16, 20)
		elseif teamName == "Bus Driver" then
			setElementModel(source, 61)
		elseif teamName == "Taxi Driver" then
			setElementModel(source, 253)
		elseif teamName == "Military" then
			setElementModel(source, 287)
			giveWeapon (source, 31, 500 )
		elseif teamName == "Limo Driver" then
			setElementModel(source, 255)
		elseif teamName == "Medic" then
			setElementModel(source, 274)
		elseif teamName == "Seeker" then
			setElementModel(source, 249)
		elseif teamName == "Pizza Driver" then
			setElementModel(source, 155)
		end
	end
)

addEvent ( "server:Duty" , true )
addEventHandler ( "server:Duty" , root ,
	function ( )
		local teamName = getTeamName ( getPlayerTeam ( source ) )
		if teamName == "Off Duty Workers" then
			setPlayerTeam(source, getTeamFromName(getElementData(source, "duty.Team")))
			local r , g , b = getTeamColor ( getPlayerTeam ( source ) ) 
			outputChatBox(getPlayerName(source)..' is now on duty!', root, r, g, b)
		else
			setElementData(source, "duty.Team", getTeamName(getPlayerTeam(source)))
			setPlayerTeam(source, getTeamFromName("Off Duty Workers"))
			setElementModel ( source,math.random(1,180))
			local r , g , b = getTeamColor ( getPlayerTeam ( source ) ) 
			outputChatBox(getPlayerName(source)..' is now off duty!', root, r , g , b)
		end
	end
)

local busIDs = {[431] = true, [437] = true}
local policeIDs = {[491] = true,  [598] = true, [599] = true, [597] = true, [596] = true}
local militaryIDs = {[433] = true, [470] = true}
local taxiIDs = {[420] = true, [438] = true}
local medicID = 416
local limoID = 409
 
addEventHandler("onVehicleStartEnter",root,
function ()
        if getElementData ( source, "gamemode" ) == "rpg" then
			if getElementModel[policeIDs(source)] then
                if not isPlayerInTeam(source, "Police") then
                        cancelEvent()
                        outputChatBox ( "You are not a Police Officer", source, 255,0,0 )
                end
			elseif getElementModel[busIDs(source)] then
                if isPlayerInTeam(source, "Bus Driver") then
                        local x, y, z = getNewBusLocation(thePlayer, 1)
                        setElementData(thePlayer,"busData",1)
                else
                        cancelEvent()
                        return outputChatBox ( "You are not a Bus Driver", source, 255,0,0 )
                end
			elseif getElementModel[taxiIDs(source)] then
                if isPlayerInTeam(source,"Taxi Driver") then
                       
                        local x, y, z = getNewTaxiLocation(thePlayer, 1)
                        setElementData(thePlayer,"taxiData",1)
                else
                        cancelEvent()
                        return outputChatBox ( "You are not a Taxi Driver", source, 255,0,0 )
                end
			elseif getElementModel[militaryIDs(source)] then
                if not isPlayerInTeam(source,"Military") then
                        cancelEvent()
                        return outputChatBox ( "You are not a Soldier", source, 255,0,0 )      
                end
			elseif getElementModel(source) == limoID then
                if not isPlayerInTeam(source,"Limo Driver") then
                        cancelEvent()
                        return outputChatBox ( "You are not a Limo Driver", source, 255,0,0 )
                end
			elseif getElementModel(source) == medicID then
                if not isPlayerInTeam(source,"Medic") then
                        cancelEvent()
                        return outputChatBox ( "You are not a Medic", source, 255,0,0 )
                end
			end
        end
end
)