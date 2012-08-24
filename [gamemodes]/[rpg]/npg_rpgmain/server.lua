function savePlayerData(player, acc)
	if getPlayerTeam(player) then
		setAccountData(acc, "team", getTeamName(getPlayerTeam(player)))
	else
		setAccountData(acc, "team", nil)
	end
	if getElementData(player, "gotMerchandise") then
		setAccountData(acc, "gotMerchandise", true)
		setAccountData(acc, "merchandiseAmmount", getElementData(player, "merchandiseAmmount"))
	else
		setAccountData(acc, "gotMerchandise", false)
	end
	if getElementData(player, "duty.Team") ~= false then
		setAccountData(acc, "duty.Team", getElementData(player, "duty.Team"))
	end
	setAccountData(acc, "WantedLevel", getPlayerWantedLevel(player))
end

function loadPlayerData(player, acc)
	if getAccountData(acc, "gotMerchandise") then
		setElementData(player, "gotMerchandise", true)
		setElementData(player, "merchandiseAmmount", getAccountData(acc, "merchandiseAmmount"))
	else
		setElementData(player, "gotMerchandise", false)
	end
	if not getAccountData(acc, "team") == false then
		setPlayerTeam(player, getTeamFromName(getAccountData(acc, "team")))
	end
	if getAccountData(acc, "duty.Team") ~= false then
		setElementData(player, "duty.Team", getAccountData(acc, "duty.Team"))
	end
	if getAccountData (acc, "WantedLevel") then
		setPlayerWantedLevel(player, getAccountData(acc, "WantedLevel"))
		else return nil
	end
end



addEvent ( "onRPGEnter", true )
addEventHandler ( "onRPGEnter", root, 
	function ( _, acc)
		local acc = getPlayerAccount( source )
		if acc then
			-- SPAWN THE PLAYER
			local pos = getAccountData ( acc, "rpg.position" ) or '1725 -1855 15'
			local x,y,z = unpack(split(pos, ' ') or {})
			local dim = tonumber( getAccountData(acc, 'rpg.dimension') ) or 100
			local modelID = getAccountData ( acc, "rpg.skin" )
			local interior = getAccountData ( acc, "rpg.interior" )
			if dim<100 or dim>400 then dim = 100 end
			spawnPlayer ( source, x,y,z, 0, modelID, interior, dim )
			setElementDimension ( source, dim )
			
			--GIVE MONEY
			local playerMoney = tonumber( getAccountData( acc, "rpg.money" ) ) or 1000
			setPlayerMoney ( source, playerMoney )
			
			-- DO OTHER STUFF
			setCameraTarget ( source, player )
			setTimer ( setAccountData, 500, 1, acc, "rpg.enabled", true )
			setTimer ( setAccountData, 1000, 1, acc, "rpg.newUser", false )
			
			--SHOW COMPONENTS
			showPlayerHudComponent ( source, "radar", true )
			showPlayerHudComponent ( source, "health", true ) 
			showPlayerHudComponent ( source, "money", true )
			showPlayerHudComponent ( source, "clock", true ) 
			
			--TEAM
			loadPlayerData(source, acc)
			
			--DOWNLOAD MAP
			triggerClientEvent ( source, "onClientPlayerRPGMapDownload", source )

		else
			kickPlayer( source, 'The server was unable to handle your request because it failed to detect your account. Please check your account and trying again (ERROR #MTAS1:1)')
		end
	end
)

function getPlayersFromGamemode( gm )
   local tab = {}
   for i,v in ipairs(getElementsByType'player') do
     if getElementData(v, 'gamemode') == gm then table.insert(tab, v) end 
   end
   return tab
end


--USAGE
--for i,v in ipairs(getPlayersFromGamemode('rpg')) do
  --  outputChatBox('Hi '..getPlayerName(v)..', we hope you enjoy the RPG gamemode!', v)
--end


addEventHandler ( "onPlayerQuit", root, 
	function (acc, _)
	if getElementData ( source, "gamemode" ) ~= "rpg" then return end
		local acc = getPlayerAccount(source)
			if ( acc ) then
				local playerMoney = getPlayerMoney ( source )
				local x,y,z = getElementPosition ( source )
				local modelID = getElementModel ( source )
				local dimension = getElementDimension ( source )
				local dimension = getElementInterior ( source )
				local pos = x..' '..y..' '..z
				setAccountData ( acc, "rpg.money", playerMoney )
				setAccountData ( acc, "rpg.position", pos )--nub
				setAccountData ( acc, "rpg.skin", modelID )
				setAccountData ( acc, "rpg.dimension", dimension )
				setAccountData ( acc, "rpg.interior", interior )
				savePlayerData(source, acc)
			end
	end
)



addEventHandler("onResourceStop", resourceRoot,
	function()
		for i,v in ipairs(getPlayersFromGamemode('rpg')) do
			if not isGuestAccount(getPlayerAccount(v)) then
				savePlayerData(v, getPlayerAccount(v))
			end
		end
	end
)



function spawnhospital(player)
	if not isElement(player) then return end
	local x,y,z = getElementPosition(player)
	local sf = getDistanceBetweenPoints3D (x,y,z,-2655.16,639.467,14.4545)
    local lv = getDistanceBetweenPoints3D (x,y,z,1607.23,1816.24,10.82)
    local ls = getDistanceBetweenPoints3D (x,y,z,2035.995,-1403.73,17.27)
	local spawnpoint
	if sf < lv then
		if sf < ls then
			spawnpoint = {-2655.16,639.467 ,14.4545}
		else
			spawnpoint = {2035.995,-1403.73,17.27  }
		end
	else
		if lv < ls then
			spawnpoint = {1607.23 ,1816.24  ,10.82 }
		else
			spawnpoint = {2035.995,-1403.73 ,17.27 }
		end
	end
	repeat until spawnPlayer ( player, unpack(spawnpoint), 180, getElementModel(player), 0, 0)
	setElementPosition(player, unpack(spawnpoint))
	--fadeCamera(player, true)
	setCameraTarget(player, player)
	showChat(player, true)
	setPlayerNametagShowing(player, false)
	setElementDimension ( player, 100 )
end

function killspawn(player)
	showChat(player,false)
	fadeCamera(player,false, 1, 255,0,0)
	setTimer(fadeCamera, 500, 1, player, true, 1)
	local x,y,z = getElementPosition(player)
	setCameraMatrix(player,x+2.3360512256622, y-0.4053855240345,z+18.492063522339, x-17.207632064819,y+4.8971672058105, -79.436111450195, 0, 70)
	setTimer(fadeCamera   ,  3000, 1, player, false, 4)
	setTimer(spawnhospital,  7500, 1, player)
	setTimer(fadeCamera   ,  8000, 1, player, true,  1)
end

addEventHandler("onPlayerWasted", root,
	function()
	if getElementData ( source, "gamemode" ) ~= "rpg" then return end
		setTimer(killspawn, 500, 1, source)
	end
)