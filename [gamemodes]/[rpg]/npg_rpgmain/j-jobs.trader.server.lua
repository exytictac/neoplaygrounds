--[[
    RPG Jobs v2.0.1 [trader.server]
    
    Made By: JR10
    
    Copyright (c) 2011
]]

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


local ship = createObject(8493,3045.65185547,-2593.31494141,16.79500961,0.00000000,0.00000000,360.00000000)
local ship_B = createObject(9159,3045.43115234,-2593.20288086,16.50687408,0.00000000,0.00000000,360.00000000)
attachRotationAdjusted( ship_B, ship)
setElementData ( ship , "atLS" , true )
local TInfo = createPickup(2730.2861328125, -2451.3955078125, 17.593746185303, 3, 1239, 0)
local TMrchMrk1 = createMarker(2782.6396484375, -2418.2216796875, 12.634921073914, "cylinder", 1.7, 255, 255, 0, 255)
local TMrchMrk2 = createMarker(2782.8056640625, -2456.48828125, 12.634881019592, "cylinder", 1.7, 255, 255, 0, 255)
local TMrchMrk3 = createMarker(2783.26171875, -2494.56640625, 12.655804634094, "cylinder", 1.7, 255, 255, 0, 255)
local TPToShipMrk = createMarker(2745.2236328125, -2576.4384765625, 2, "cylinder", 1.7, 100, 100, 100, 255)
local TCol1 = createColTube ( 2720.7001953125, -2405.712890625, 12.4609375, 20, 20)
local TCol2 = createColTube ( 2721.3876953125, -2504.275390625, 12.486897468567, 20, 20)
local TPToDock = createMarker(3044.6176757813, -2627.2993164063, 7.9825096130371, "cylinder", 1.7, 100, 100, 100, 255)
local sellMerchandiseMrk = createMarker(2359.861328125, 533.91015625, 0.796875, "cylinder", 1.7, 255, 255, 0, 255)
setElementDimension ( TInfo, 100 )
setElementDimension ( TMrchMrk1, 100 )
setElementDimension ( TMrchMrk2, 100 )
setElementDimension ( TMrchMrk3, 100 )
setElementDimension ( TPToShipMrk, 100 )
setElementDimension ( TCol1, 100 )
setElementDimension ( TCol2, 100 )
setElementDimension ( TPToDock, 100 )
setElementDimension ( sellMerchandiseMrk, 100 )
setElementDimension ( ship, 100 )
setElementDimension ( ship_B, 100 )

function BuyMerchandise(player)
    if isPlayerInTeam(player, "Trader") then
        if isElementWithinMarker(player, TMrchMrk1) or isElementWithinMarker(player, TMrchMrk2) or isElementWithinMarker(player, TMrchMrk3) then
            triggerClientEvent(player, "showBuyMerchandiseWnd", player)
        end
    else
        return end
end

addEventHandler("onRPGEnter", root,
    function(_, account)
        bindKey(source, "F4", "up", BuyMerchandise)
    end
)

addEventHandler("onResourceStart", resourceRoot,
    function()
        if getElementData ( source, "gamemode" ) ~= "rpg" then return end
            if not isGuestAccount(getPlayerAccount(v)) then
                bindKey(v, "F4", "up", BuyMerchandise)
            end
    end
)

setTimer (
    function ( )
        createBlipAttachedTo(ship, settingShipBlip)
        createBlipAttachedTo(sellMerchandiseMrk, settingSellMerchandiseMarkerBlip)
    end
, 100 , 1 )

addEventHandler("onPickupHit", TInfo,
    function(src)
    if getElementData ( src, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(src, "Trader") then
            outputChatBox("Welcome to Trader HQ", src, 255, 255, 0)
        end
    end
)

addEventHandler("onMarkerHit", TPToShipMrk,
    function(hitElement)
    if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(hitElement, "Trader") then
            fadeCamera(hitElement, false)
            setTimer(setElementPosition, 1000, 1, hitElement, 3045.1831054688, -2607.2407226563, 5.5059471130371)
            setTimer(fadeCamera, 1000, 1, hitElement, true)
        end
    end
)

addEventHandler("onMarkerHit", TPToDock,
    function(hitElement)
    if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(hitElement, "Trader") then
            fadeCamera(hitElement, false)
            setTimer(setElementPosition, 1000, 1, hitElement, 2734.4326171875, -2576.6298828125, 4)
            setTimer(fadeCamera, 1000, 1, hitElement, true)
        end
    end
)

addEventHandler("onColShapeHit", TCol1,
    function(hitElement, dim)
    if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(hitElement, "Trader") then
            local gate = getElementByID("LSTGate1")
            moveObject(gate, 1500, 2720.3056640625, -2417.99909375, 12.4681224823)
        end
    end
)

addEventHandler("onColShapeLeave", TCol1,
    function(hitElement, dim)
    if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(hitElement, "Trader") then
            local gate = getElementByID("LSTGate1")
            moveObject(gate, 1500, 2720.3056640625, -2409.7463378906, 12.4681224823)
        end
    end
)

addEventHandler("onColShapeHit", TCol2,
    function(hitElement, dim)
    if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(hitElement, "Trader") then
            local gate = getElementByID("LSTGate2")
            moveObject(gate, 1500, 2720.23046875, -2516.9333984375, 12.492005348206)
        else
            return
        end
    end
)

addEventHandler("onColShapeLeave", TCol2,
    function(hitElement, dim)
    if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(hitElement, "Trader") then
            local gate = getElementByID("LSTGate2")
            moveObject(gate, 1500, 2720.23046875, -2508.2338867188, 12.492005348206)
        else
            return
        end
    end
)

addEventHandler("onMarkerHit", TMrchMrk1,
    function(hitElement)
    if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(hitElement, "Trader") then
            outputChatBox("Click on F4 to buy merchandise", hitElement, 255, 255, 0)
        end
    end
)

addEventHandler("onMarkerHit", TMrchMrk2,
    function(hitElement)
    if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(hitElement, "Trader") then
            outputChatBox("Click on F4 to buy merchandise", hitElement, 255, 255, 0)
        end
    end
)

addEventHandler("onMarkerHit", TMrchMrk3,
    function(hitElement)
    if getElementData ( hitElement, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(hitElement, "Trader") then
            outputChatBox("Click on F4 to buy merchandise", hitElement, 255, 255, 0)
        end
    end
)

addEvent("BuyMerchandise", true)
addEventHandler("BuyMerchandise", root,
    function(ammount)
        if not client then return end
        if not getElementData(client, "gotMerchandise") then
            ammount = tonumber(ammount)
            setElementData(client, "gotMerchandise", true)
            setElementData(client, "merchandiseAmmount", ammount)
            outputChatBox("You spent #00FF00$"..ammount.." #FFFFFFon merchandise go to the ship to sail", client, 255, 255, 255, true)
            takePlayerMoney(client, ammount)
        else
            local ammount_C = getElementData(client, "merchandiseAmmount")
            if string.len(ammount_C + tonumber(ammount)) <= 7 then
                ammount = tonumber(ammount)
                setElementData(client, "gotMerchandise", true)
                setElementData(client, "merchandiseAmmount", ammount + ammount_C)
                outputChatBox("You spent #00FF00$"..ammount + ammount_C.." #FFFFFFon merchandise go to the ship to sail", client, 255, 255, 255, true)
                takePlayerMoney(client, ammount)
            else
                outputChatBox("You have bought enough merchandise go to the ship to sail", client, 192, 192, 192)
            end
        end
    end
)

addCommandHandler("merchandise",
    function(src, cmd)
    if getElementData ( src, "gamemode" ) ~= "rpg" then return end
        if getElementData(src, "gotMerchandise") then
            outputChatBox("You spent #00FF00$"..getElementData(src, "merchandiseAmmount").."#FFFFFF on merchandise go to the ship to sail", src, 255, 255, 255, true)
        else
            outputChatBox("You don't have any merchandise", src, 192, 192, 192)
        end
    end
)
--sailing (moving the ship) command
addCommandHandler("sail",
    function(src, cmd)
    if getElementData ( src, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(src, "Trader") then
            if getElementData ( ship , "atLV" ) then
                outputChatBox ( "The ship is already at LV" , src )
                return
            end
            local sx, sy, sz = getElementPosition(ship)
            if isPlayerInRangeOfPoint(src, sx,sy,sz,35) then
                if getElementData(src, "gotMerchandise") then
                    if not getElementData(ship, "moving") then
                        moveObject(ship, 240000, 3081.7802734375, 440.63671875, 13.2831835746765)
                        movingTimer1 = setTimer(setElementRotation, 240000, 1, ship, 0, 0, -270)
                        movingTimer2 = setTimer(moveObject, 240000, 1, ship, 30000,2363.837890625, 516.2529296875, 13.5234065055847)
                        outputChatBox("The ship is now moving", src, 255,255, 0)
                        setElementData(ship, "moving", true)
                        movingTimer3 = setTimer(setElementData, 270000, 1, ship, "moving", false)
                        setTimer (
                            function ( ) 
                                removeElementData ( ship , "atLS" )
                                setElementData ( ship , "atLV" , true )
                            end
                        , 270000 , 1 )
                    else
                        outputChatBox("The ship is already moving", src, 192, 192, 192)
                    end
                else
                    outputChatBox("You dont have any merchandise buy merchandise first", src, 192, 192, 192)
                end
            else
                outputChatBox("You are too far from the ship", src)
            end
        else
            outputChatBox("You are not a trader", src)
        end
    end
)
--sailing back
addCommandHandler("sailback",
    function(src, cmd)
    if getElementData ( src, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(src, "Trader") then
            if getElementData ( ship , "atLS" ) then
                outputChatBox ( "The ship is already at LS" , src )
                return
            end
            local sx, sy, sz = getElementPosition(ship)
            if isPlayerInRangeOfPoint(src, sx,sy,sz,35) then
                if not getElementData(ship, "moving") then
                    setElementData(ship, "moving", true)
                    setElementRotation(ship, 0, 0, 270)
                    moveObject(ship, 30000, 3081.7802734375, 440.63671875, 13.2831835746765)
                    movingTimer4 = setTimer(setElementRotation, 30000, 1, ship, 0, 0, 180)
                    movingTimer5 = setTimer(moveObject, 30000, 1, ship, 240000, 3045.65185547, -2593.31494141, 16.79500961 )
                    movingTimer6 = setTimer(setElementData, 270000, 1, ship, "moving", false)
                    movingTimer7 = setTimer(outputChatBox, 270100, 1, "The ship has arrived", src, 255, 255, 0)
                    movingTimer8 = setTimer(setElementRotation, 270100, 1, ship, 0, 0, 360)
                    setTimer (
                        function ( ) 
                            removeElementData ( ship , "atLV" )
                            setElementData ( ship , "atLS" , true )
                        end
                    , 270000 , 1 )
                else
                    outputChatBox("The ship is already moving", src, 192, 192, 192)
                end
            else
                outputChatBox("You are too far from the ship", src, 192, 192, 192)
            end
        else
            outputChatBox("You are not a trader", src, 192, 192, 192)
        end
    end
)

addEventHandler("onMarkerHit", sellMerchandiseMrk,
    function(src)
    if getElementData ( src, "gamemode" ) ~= "rpg" then return end
        if isPlayerInTeam(src, "Trader") then
            if getElementData(src, "gotMerchandise") then
                setElementData(src, "gotMerchandise", false)
                givePlayerMoney(src, getElementData(src, "merchandiseAmmount") * 3)
                outputChatBox("You have sold the merchandise and earned #00FF00$"..getElementData(src, "merchandiseAmmount") * 3, src, 255, 255, 255, true)
                setElementData(src, "merchandiseAmmount", 0)
            else
                outputChatBox("You don't have any merchandise", src, 192, 192, 192)
            end
        end
    end
)

addEventHandler ( "onMarkerHit", marker[2],	
	function ( hElement )
	local x,y,z = getElementPosition ( gate[2] )
		if isPlayerInTeam ( hElement, "Trader" )  then
			moveObject ( gate[2], 1000, x, y - 10, z )
		else
			cancelEvent ( )
		end
	end
)

addEventHandler ( "onMarkerLeave", marker[2],
	function  ( lElement )
	local x,y,z = getElementPosition ( gate[2] )
		if isPlayerInTeam ( lElement, "Trader" )  then
			moveObject ( gate[2], 1000, x, y + 10, z )
		else
			cancelEvent ( )
		end
	end
)

addEventHandler ( "onMarkerHit", marker[1],
	function ( hElement )
	local x,y,z = getElementPosition ( gate[1] )
		if isPlayerInTeam ( hElement, "Trader" )  then
			moveObject ( gate[1], 1000, x, y + 10, z )
		else
			cancelEvent ( )
		end
	end
)
    
addEventHandler ( "onMarkerLeave", marker[1], 
	function ( lElement )
	local x,y,z = getElementPosition ( gate[1] )
		if isPlayerInTeam ( lElement, "Trader" )  then
			moveObject ( gate[1], 1000, x, y - 10, z )
		else
			cancelEvent ( )
		end
	end
)