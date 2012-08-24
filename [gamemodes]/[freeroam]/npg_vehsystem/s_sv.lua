----------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////--
----------------------------------------------------------------------------
addCommandHandler("sv",
        function(me, cmd, ...)
                if getResourceFromName("gamemanager") then if exports.gamemanager:isFeatureDisabled(me, "sv") then
                        return end
                end
                if isPedDead(me) then return end
                
                local carName = table.concat({...}, " ")
                local px, py, pz, model = getElementPosition(me)
                
                if not carName == "" then return errMsg(me,"No vehicle specified") end
                if carName == "none" then
                        if getPedOccupiedVehicle(source) then destroyElement(getPedOccupiedVehicle(source)) end
                        return
                end
                
                if tonumber(carName) then
                        model = math.floor(tonumber(carName))
                else
                        model = getVehicleModelFromName(carName)
                end
                
                if not model then
                        errMsg(me,"Invalid vehicle ('" .. carName .. "')")
                        return
                end
                
                local vehicle = getPedOccupiedVehicle(me)
                
                if vehicle then
                        if not getVehicleController(vehicle) == me then return end
                        setPlayerVehicle(me, model)
                        setTimer(warpPedIntoVehicle, 70, 1, me, getPedOccupiedVehicle(me))
                else
                        givePlayerVehicle(me, model)
                        setTimer(warpPedIntoVehicle, 70, 1, me, getPedOccupiedVehicle(me))
                end
        end
)

--

function givePlayerVehicle(me, model)
        if isPedInVehicle(me) then return setPlayerVehicle(me, model) end
        
        for _,v in ipairs(getElementsByType("vehicle")) do
                if (getElementData(v, "vowner") == getPlayerSerial(me)) then
                        destroyElement(v)
                end
        end
        
        local px,py,pz = getElementPosition(me)
        local veh = createVehicle(model, px, py, pz, 0, 0, 0)
        
        setElementInterior(veh, getElementInterior(me))
        setElementDimension(veh, getElementDimension(me))
        
        setVehicleRotation(veh, 0, 0, getPedRotation(me))
        warpPedIntoVehicle(me, veh)
        setElementData(veh, "vowner", getPlayerSerial(me), false)
end

function setPlayerVehicle(me, model)
        local veh = getPedOccupiedVehicle(me)
        if veh then
                setElementModel(veh, model)
                setElementData(veh, "vowner", getPlayerSerial(me), false)
                fixVehicle(veh)
        end
end

function destroyVehicle(vehicle)
    local check = false
        for _,gPlayer in ipairs(getElementsByType("player")) do
                if (getPedOccupiedVehicle(gPlayer) == vehicle) then
                        if (getPedOccupiedVehicleSeat(gPlayer) == 0) then
                                check = true
                        end
                end
        end
        if (isElement(vehicle) and getElementType(vehicle) == "vehicle" and check == false) then
                destroyElement(vehicle)
        end
end

addEventHandler("onVehicleStartEnter", root, function(me, _, _, door)
                if isVehicleLocked(source) then
                        errMsg(me,"Vehicle is locked")
                        cancelEvent()
                        return
                end
                setElementData(source, "vowner", getPlayerSerial(me), false)
                if (getVehicleType(source) == "Train") then
                        setTrainDerailable(source, false)
                end
        end
)

--[[local function areOccupantsInsideVehicle(v)
        local o,r = getVehicleOccupants(v)
        for i=0, getVehicleMaxSeats(v) do
                if isElement(r[i]) then
                        r = true
                end
        end
        return r
end]]

addEventHandler("onPlayerQuit", root, function()
                for _,v in ipairs(getElementsByType("vehicle")) do
                        if getElementData(v, "vowner") == getPlayerSerial(source) then
                                if areOccupantsInsideVehicle(v) then
                                        local p = getVehicleOccupants(v)[1]
                                        if getElementType(p) == "player" then
                                                setElementData(v, "vowner", getPlayerSerial(p))
                                        end
                                else
                                        destroyElement(v)
                                end
                        end
                end
        end
)

----------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////--
----------------------------------------------------------------------------
