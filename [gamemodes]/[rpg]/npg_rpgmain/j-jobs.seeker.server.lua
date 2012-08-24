--[[
	RPG Jobs v2.0.1 [seeker.server]
	
	Made By: JR10
	
	Copyright (c) 2011
]]

RPGDimension = 100

local newAssignM = createMarker ( 1305.0126953125 , -1369.9697265625 , 12.568832397461 , "cylinder" , 2 , 255 , 153 , 0 )
setElementDimension ( newAssignM, RPGDimension )

addEventHandler ( "onMarkerHit" , newAssignM ,
	function ( hElement , mDim )
		if not mDim or getElementType ( hElement ) ~= "player" or not getPlayerTeam ( hElement ) or getTeamName ( getPlayerTeam ( hElement ) ) ~= "Seeker" or isPedInVehicle ( hElement ) then
			return
		end
		local rand = math.random ( #bcTable )
		local bcData = bcTable [ rand ]
		local posX , posY , posZ = unpack ( bcData )
		local prize = getDistanceBetweenPoints3D ( 1305.0126953125 , -1369.9697265625 , 12.568832397461 , posX , posY , posZ ) * settingBriefcasePrize
		prize = string.format ( "%.f" , prize )
		triggerClientEvent ( hElement , "client:showNAGUI" , hElement , prize )
		setElementData ( hElement , "naIndex" , rand )
	end
)

addEvent ( "server:startAssign" , true )
addEventHandler ( "server:startAssign" , root ,
	function ( )
		if getTeamName ( getPlayerTeam ( source ) ) ~= "Seeker" then
			return
		end
		if getElementData ( source , "gAssignment" ) then
			outputChatBox ( "You have to wait 10 minutes before taking a new assignment" , source , 200 , 200 , 200 )
			for index , briefcase in ipairs ( getElementsByType ( "pickup" , resourceRoot ) ) do
				if getElementData ( briefcase , "player" ) == source then
					destroyElement ( briefcase )
					break
				end
			end
			return
		end
		local bcData = bcTable [ getElementData ( source , "naIndex" ) ]
		local posX , posY , posZ = unpack ( bcData )
		local bc = createPickup ( posX , posY , posZ , 3 , 1210 )
		setElementDimension ( bc, RPGDimension )
		setElementData ( bc , "player" , source )
		setElementData ( source , "gAssignment" , true )
		outputChatBox ( "You have 10 minutes to find the briefcase" , source , 255 , 153 , 0 , true )
		addEventHandler ( "onPickupHit" , bc ,
			function ( player )
				if not getPlayerTeam ( player ) or getTeamName ( getPlayerTeam ( player ) ) ~= "Seeker" or getElementData ( bc , "player" ) ~= player then
					cancelEvent ( )
					return
				end
				local posX , posY , posZ = getElementPosition ( source )
				local prize = getDistanceBetweenPoints3D ( 1305.0126953125 , -1369.9697265625 , 12.568832397461 , posX , posY , posZ ) * settingBriefcasePrize
				prize = string.format ( "%.f" , prize )
				givePlayerMoney ( player , prize )
				outputChatBox ( "You have found the briefcase and earned #00FF00$" .. prize , player , 255 , 153 , 0 , true )
				triggerClientEvent ( player , "client:playCashSound" , player )
				destroyElement ( source )
			end
		)		
		setCameraMatrix ( source , posX - 30 , posY , posZ + 30 , posX , posY , posZ )
		setElementFrozen ( source , true )
		triggerClientEvent ( source , "client:showLocation" , source , true , getZoneName ( posX , posY , posZ , false ) , getZoneName ( posX , posY , posZ , true ) )
		setTimer (
			function ( player )
				setCameraTarget ( player )
				setElementFrozen ( player , false )
				local posX2 , posY2 , posZ2 = getElementPosition ( player )
				setElementPosition ( player , posX2 + 2 , posY2 , posZ2 + 1 )
				triggerClientEvent ( player , "client:showLocation" , player , false )
			end
		, 5000 , 1 , source )
		setTimer (
			function ( player , bc )
				removeElementData ( player , "gAssignment" )
				destroyElement ( bc )
				outputChatBox ( "You have failed to find the briefcase" , player , 200 , 200 , 200 )
			end
		, 600000 , 1 , source , bc )
	end
)