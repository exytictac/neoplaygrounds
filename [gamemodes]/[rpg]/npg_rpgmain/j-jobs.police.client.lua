--[[
	RPG Jobs v2.0.1 [police.client]
	
	Made By: JR10
	
	Copyright (c) 2011
]]

local curTarget
local screenX , screenY = guiGetScreenSize ( )

addEvent('playCD', true)
addEventHandler('playCD', root,
	function(cd)
		playSound(cd..'.mp3', false)
	end
)

addEvent ( "client:setPlayerFollowPlayer" , true )
addEventHandler ( "client:setPlayerFollowPlayer" , root ,
	function ( bool , target )
		if bool then
			curTarget = target
			addEventHandler ( "onClientRender" , root , setPlayerFollowPlayer )
		else
			showCursor(false)
			toggleAllControls(true)
			removeEventHandler ( "onClientRender" , root , setPlayerFollowPlayer )
		end
	end
)

function setPlayerFollowPlayer ( )
	if isPedInVehicle ( curTarget ) then
		local vehicle = getPedOccupiedVehicle ( curTarget )
		local seat = getPedOccupiedVehicleSeat ( curTarget )
		if not warpPedIntoVehicle ( source , vehicle , seat + 1 ) then
			local posX , posY , posZ = getElementPosition ( vehicle )
			setElementPosition ( source , posX , posY , posZ + 1 )
			attachRotationAdjusted ( source , vehicle )
		end
	else
		if isPedInVehicle ( source ) then
			removePedFromVehicle ( source )
		end
		local posX , posY , posZ = getElementPosition ( source )
		local posX2 , posY2 , posZ2 = getElementPosition ( curTarget )
		local rotation = math.deg ( math.atan2 ( posX2 - posX , posY2 - posY ) ) % 360
		setElementRotation ( source , 0 , 0 , 360 - rotation )
		setCameraTarget ( source )
		local distance = getDistanceBetweenPoints2D(posX2, posY2, posX, posY)
		if distance > 22 then
			setElementData(source, "Cuffed", false)
			setElementData(source, "Handcuffer", "")
			showCursor(false)
			toggleAllControls(true)
			removeEventHandler ( "onClientRender" , root , setPlayerFollowPlayer )
		elseif distance > 12 then
			setControlState("sprint", true)
			setControlState("walk", false)
			setControlState("forwards", true)
		elseif distance > 6 then
			setControlState("sprint", false)
			setControlState("walk", false)
			setControlState("forwards", true)
		elseif distance > 1.5 then
			setControlState("sprint", false)
			setControlState("walk", true)
			setControlState("forwards", true)
		elseif distance < 1.5 then
			setControlState("sprint", false)
			setControlState("walk", false)
			setControlState("forwards", false)
		end
	end
end

function Follow(target, player)
	if not isPedInVehicle(player) then
		local px, py, pz = getElementPosition(player)
		local tx, ty, tz = getElementPosition(target)
		local angle = ( 360 - math.deg ( math.atan2 ( ( px - tx ), ( py - ty ) ) ) ) % 360
		setPedRotation(target, angle)
		setCameraTarget(target)
		local distance = getDistanceBetweenPoints2D(px, py, tx, ty)
		if distance > 22 then
			stopFollow(target, player)
			setElementData(target, "Cuffed", false)
			setElementData(target, "Handcuffer", "")
		elseif distance > 12 then
			setControlState(target, "sprint", true)
			setControlState(target, "walk", false)
			setControlState(target, "forwards", true)
			followTimer[target] = setTimer(Follow, 500, 1, target, player)
		elseif distance > 6 then
			setControlState(target, "sprint", false)
			setControlState(target, "walk", false)
			setControlState(target, "forwards", true)
			followTimer[target] = setTimer(Follow, 500, 1, target, player)
		elseif distance > 1.5 then
			setControlState(target, "sprint", false)
			setControlState(target, "walk", true)
			setControlState(target, "forwards", true)
			followTimer[target] = setTimer(Follow, 500, 1, target, player)
		elseif distance < 1.5 then
			setControlState(target, "sprint", false)
			setControlState(target, "walk", false)
			setControlState(target, "forwards", false)
			followTimer[target] = setTimer(Follow, 500, 1, target, player)
		end
	end
end

function attachRotationAdjusted ( from, to )
    local frPosX, frPosY, frPosZ = getElementPosition( from )
    local frRotX, frRotY, frRotZ = getElementRotation( from )
    local toPosX, toPosY, toPosZ = getElementPosition( to )
    local toRotX, toRotY, toRotZ = getElementRotation( to )
    local offsetPosX = frPosX - toPosX
    local offsetPosY = frPosY - toPosY
    local offsetPosZ = frPosZ - toPosZ
    local offsetRotX = frRotX - toRotX
    local offsetRotY = frRotY - toRotY
    local offsetRotZ = frRotZ - toRotZ
    offsetPosX, offsetPosY, offsetPosZ = applyInverseRotation ( offsetPosX, offsetPosY, offsetPosZ, toRotX, toRotY, toRotZ )
    attachElements( from, to, offsetPosX, offsetPosY, offsetPosZ, offsetRotX, offsetRotY, offsetRotZ )
end

function applyInverseRotation ( x,y,z, rx,ry,rz )
    local DEG2RAD = (math.pi * 2) / 360
    rx = rx * DEG2RAD
    ry = ry * DEG2RAD
    rz = rz * DEG2RAD
    local tempY = y
    y =  math.cos ( rx ) * tempY + math.sin ( rx ) * z
    z = -math.sin ( rx ) * tempY + math.cos ( rx ) * z
    local tempX = x
    x =  math.cos ( ry ) * tempX - math.sin ( ry ) * z
    z =  math.sin ( ry ) * tempX + math.cos ( ry ) * z
    tempX = x
    x =  math.cos ( rz ) * tempX + math.sin ( rz ) * y
    y = -math.sin ( rz ) * tempX + math.cos ( rz ) * y
    return x, y, z
end

addEventHandler ( "onClientRender" , root ,
	function ( )
		for index , player in ipairs ( getElementsByType ( "player" ) ) do
			if not getElementData ( player , "Arrested" ) then
				return
			end
			if getElementData(player, "Timeleft") < 1 then
				return
			end
			dxDrawFramedText ( "Time left: " .. getElementData ( player , "Timeleft" ) , ( screenX / 1440 ) * 720 , ( screenY / 900 ) * 200 , ( screenX / 1440 ) * 1440 , ( screenY / 900 ) * 200 , tocolor ( 255 , 255 , 255 , 255 ) , ( screenX / 1440 ) * 3 , "default-bold" , "center" , "center" , false , false , true )
			if getElementData ( player , "Timeleft" ) < 6 then
				playSound ( getElementData ( player , "Timeleft" ) .. ".mp3" , false )
				return
			end
		end
	end
)