
-- ***********************************************
-- * TMS Attachments                             *
-- * Written by Tommy (c) 2010                   *
-- ***********************************************

-- *****************
-- *  Attachments  *
-- *****************
function useAttach(thePlayer, command)
    --if (getElementData(thePlayer, "playerClass") == 4) then
        triggerClientEvent(thePlayer, "openAttach", getRootElement())
    --else
        --outputChatBox("You can't use this feature currently because it is buggy.", thePlayer, 255, 0, 0, false)
    --end
end

function createObj(attachID, thePlayer, objID, x, y, z, rx, ry, rz)
    if (isPedInVehicle(thePlayer)) then
        local theVehicle = getPedOccupiedVehicle(thePlayer)
        local px, py, pz = getElementPosition(theVehicle)
        local theObject = createObject(objID, x + px, y + py, z + pz)
        setElementDimension(theObject, getElementDimension(thePlayer))
        attachElements(theObject, theVehicle, x, y, z, rx, ry, rz)
		setElementData(theObject, "vglueable", true, true)
        setElementParent(theObject, theVehicle)
        triggerClientEvent(thePlayer, "storeObj", getRootElement(), attachID, theObject)
    else
        local px, py, pz = getElementPosition(thePlayer)
        local theObject = createObject(objID, x + px, y + py, z + pz)
        setElementDimension(theObject, getElementDimension(thePlayer))
        attachElements(theObject, thePlayer, x, y, z, rx, ry, rz)
		setElementData(theObject, "vglueable", true, true)
        setElementParent(theObject, thePlayer)
        triggerClientEvent(thePlayer, "storeObj", getRootElement(), attachID, theObject)
    end
end

function destroyObj(attachID, thePlayer, theObject)
    if (theObject ~= nil) then
        destroyElement(theObject)
    end
    triggerClientEvent(thePlayer, "storeObj", getRootElement(), attachID, nil)
end

function updateObj(thePlayer, theObject, x, y, z, rx, ry, rz)
    if (isPedInVehicle(thePlayer)) then
        local theVehicle = getPedOccupiedVehicle(thePlayer)
        local px, py, pz = getElementPosition(theVehicle)
        detachElements(theObject, theVehicle)
        setElementPosition(theObject, x + px, y + py, z + pz)
        attachElements(theObject, theVehicle, x, y, z, rx, ry, rz)
    else
        local px, py, pz = getElementPosition(thePlayer)
        detachElements(theObject, thePlayer)
        setElementPosition(theObject, x + px, y + py, z + pz)
        attachElements(theObject, thePlayer, x, y, z, rx, ry, rz)
    end
end

function updateObjId(theObject, objId)
    setElementModel(theObject, objId)
end

function setObjCollision(theObject, state)
    setElementCollisionsEnabled(theObject, state)
end

function setObjScale(theObject, scale)
   setObjectScale(theObject, scale)
end

function setObjAlpha(theObject, a)
   setElementAlpha(theObject, a)
end

-- ****************************
-- * Add all command handlers *
-- ****************************
addCommandHandler("attach", useAttach)

addEvent("createObj", true)
addEventHandler("createObj", getRootElement(), createObj)
addEvent("updateObj", true)
addEventHandler("updateObj", getRootElement(), updateObj)
addEvent("updateObjId", true)
addEventHandler("updateObjId", getRootElement(), updateObjId)
addEvent("destroyObj", true)
addEventHandler("destroyObj", getRootElement(), destroyObj)
addEvent("setObjCollision", true)
addEventHandler("setObjCollision", getRootElement(), setObjCollision)
addEvent("setObjScale", true)
addEventHandler("setObjScale", getRootElement(), setObjScale)
addEvent("setObjAlpha", true)
addEventHandler("setObjAlpha",root, setObjAlpha)