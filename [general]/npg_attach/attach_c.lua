
-- *************************************************
-- * Written by Tommy and Qais (c) 2011            *
-- * GTFO CANNONBALL IS AWESOME - DONT STEAL THIS  *
-- * PLEASEEEEEEEEEEEE                             *
-- *************************************************

local screenWidth, screenHeight = guiGetScreenSize()
local mtaVersion                = getVersion()
local me                        = getLocalPlayer()
local scriptVersion             = "1.28"

local attachObjectID            = { }
local attachObject              = { }
local attachName                = { }
local attachState               = { }
local attachX                   = { }
local attachY                   = { }
local attachZ                   = { }
local attachRotX                = { }
local attachRotY                = { }
local attachRotZ                = { }
local attachCollision           = { }
local attachScale               = { }
local attachAlpha              = { }

local totalAttachs              = 81

addEvent("callAttachGUI", true)

-- ************************************
-- *  Attachs window initialization   *
-- ************************************
function attachInit(source)
    local theWindow = guiGetVisible(attachWindow)
    if (theWindow == true) then
        showCursor(false)
        guiSetVisible(attachWindow, false)
    else
        -- Create the window.
        attachWindow = guiCreateWindow(390, screenHeight - 315, 400, 320, "Attachments", false)
    
        -- Create the "Close" button.
        closeButton = guiCreateButton(0.72, 0.90, 0.24, 0.10, "Close", true, attachWindow)

        -- Create the attachments list.     
        attachList = guiCreateGridList(0.02, 0.09, 0.45, 0.75, true, attachWindow)
        guiGridListSetSortingEnabled(attachList, false)

        attachColumn = guiGridListAddColumn(attachList, "Attachment", 1)
        --stateColumn = guiGridListAddColumn(attachList, "State", 0.20)

        local i = 0
        while (i < totalAttachs) do
            local row = guiGridListAddRow(attachList)
            if (row) then
                guiGridListSetItemText(attachList, row, attachColumn, attachName[i], false, false)
                --guiGridListSetItemText(attachList, row, stateColumn, attachState[i], false, false)
                
                if (mtaVersion.number >= 260) then
                    if (attachState[i] == "on") then
                        guiGridListSetItemColor(attachList, row, attachColumn, 0, 255, 0)
                        --guiGridListSetItemColor(attachList, row, stateColumn, 0, 255, 0)
                    else
                        guiGridListSetItemColor(attachList, row, attachColumn, 255, 0, 0)
                        --guiGridListSetItemColor(attachList, row, stateColumn, 255, 0, 0)
                    end
                end
            end
            i = i + 1
        end
        
        attachID = -1
        attachCollisionCheck = guiCreateCheckBox(0.48, 0.07, 0.40, 0.06, "Enable collision", false, true, attachWindow)

        -- Create buttons for moving objects.
        moveLabel = guiCreateLabel(0.50, 0.14, 0.15, 0.10, "Move:", true, attachWindow)
        upButton = guiCreateButton(0.60, 0.20, 0.09, 0.09, "Up", true, attachWindow)
        guiSetFont(upButton, "default-bold-small")
        leftButton = guiCreateButton(0.50, 0.30, 0.09, 0.09, "Left", true, attachWindow)
        guiSetFont(leftButton, "default-bold-small")
        rightButton = guiCreateButton(0.70, 0.30, 0.09, 0.09, "Right", true, attachWindow)
        guiSetFont(rightButton, "default-bold-small")
        downButton = guiCreateButton(0.60, 0.30, 0.09, 0.09, "Down", true, attachWindow)
        guiSetFont(downButton, "default-bold-small")
        frontButton = guiCreateButton(0.83, 0.20, 0.09, 0.09, "Front", true, attachWindow)
        guiSetFont(frontButton, "default-bold-small")
        backButton = guiCreateButton(0.83, 0.30, 0.09, 0.09, "Back", true, attachWindow)
        guiSetFont(backButton, "default-bold-small")

        -- Create buttons for rotating objects.
        rotXLabel = guiCreateLabel(0.50, 0.56, 0.15, 0.7, "Rotate X:", true, attachWindow)
        downRotXButton = guiCreateButton(0.65, 0.56, 0.06, 0.06, "<", true, attachWindow)
        guiSetFont(downRotXButton, "default-bold-small")
        upRotXButton = guiCreateButton(0.72, 0.56, 0.06, 0.06, ">", true, attachWindow)
        guiSetFont(upRotXButton, "default-bold-small")
        
        rotYLabel = guiCreateLabel(0.50, 0.63, 0.15, 0.7, "Rotate Y:", true, attachWindow)
        downRotYButton = guiCreateButton(0.65, 0.63, 0.06, 0.06, "<", true, attachWindow)
        guiSetFont(downRotYButton, "default-bold-small")
        upRotYButton = guiCreateButton(0.72, 0.63, 0.06, 0.06, ">", true, attachWindow)
        guiSetFont(upRotYButton, "default-bold-small")
        
        rotZLabel = guiCreateLabel(0.50, 0.70, 0.15, 0.7, "Rotate Z:", true, attachWindow)
        downRotZButton = guiCreateButton(0.65, 0.70, 0.06, 0.06, "<", true, attachWindow)
        guiSetFont(downRotZButton, "default-bold-small")
        upRotZButton = guiCreateButton(0.72, 0.70, 0.06, 0.06, ">", true, attachWindow)
        guiSetFont(upRotZButton, "default-bold-small")

        scaleLabel = guiCreateLabel(0.50, 0.77, 0.15, 0.7, "Scale:", true, attachWindow)
        downScaleButton = guiCreateButton(0.65, 0.77, 0.06, 0.06, "-", true, attachWindow)
        guiSetFont(downScaleButton, "default-bold-small")
        upScaleButton = guiCreateButton(0.72, 0.77, 0.06, 0.06, "+", true, attachWindow)
        guiSetFont(upScaleButton, "default-bold-small")

        alphaLabel = guiCreateLabel(0.50, 0.84, 0.15, 0.7, "Alpha:", true, attachWindow)
        downAlphaButton = guiCreateButton(0.65, 0.84, 0.06, 0.06, "-", true, attachWindow)
        guiSetFont(downAlphaButton, "default-bold-small")
        upAlphaButton = guiCreateButton(0.72, 0.84, 0.06, 0.06, "+", true, attachWindow)
        guiSetFont(upAlphaButton, "default-bold-small")

        -- Create buttons for changing object ID (only for staff).
        objIdLabel = guiCreateLabel(0.50, 0.47, 0.15, 0.7, "Object ID:", true, attachWindow)
        objIdEdit = guiCreateEdit(0.65, 0.45, 0.14, 0.08, tostring(attachObjectID[totalAttachs - 1]), true, attachWindow)
        guiSetFont(objIdEdit, "default-bold-small")
        objIdSetButton = guiCreateButton(0.80, 0.45, 0.08, 0.08, "Set", true, attachWindow)
        guiSetFont(objIdSetButton, "default-bold-small")
        guiSetVisible(objIdLabel, false)
        guiSetVisible(objIdEdit, false)
        guiSetVisible(objIdSetButton, false)

        -- Create labels which contains the version number.
        version1Label = guiCreateLabel(0.04, 0.88, 0.30, 0.10, "Attach - Version "..scriptVersion, true, attachWindow)
        version2Label = guiCreateLabel(0.04, 0.92, 0.30, 0.10, "Written by Tommy and Qais", true, attachWindow)
        guiSetFont(version1Label, "default-small")
        guiSetFont(version2Label, "default-small")

        showCursor(true)
        guiWindowSetSizable(attachWindow, false)
        guiSetVisible(attachWindow, true)
    end
end

addEventHandler("callAttachGUI", root, attachInit)

-- ********************
-- *  Event handlers  *
-- ********************
function onClose()
    if (source == closeButton) then
        guiSetVisible(attachWindow, false)
        showCursor(false)
    end
end

function onClick()
    if (source == attachList) then
        attachID = guiGridListGetSelectedItem(attachList)
        if (attachState[attachID] == "on") then
            if (guiGridListGetSelectedItem(attachList) ~= -1) then
                guiCheckBoxSetSelected(attachCollisionCheck, attachCollision[attachID])
            end
        end
        
        if (attachID == (totalAttachs - 1)) then
            guiSetVisible(objIdLabel, true)
            guiSetVisible(objIdEdit, true)
            guiSetVisible(objIdSetButton, true)
        else
            guiSetVisible(objIdLabel, false)
            guiSetVisible(objIdEdit, false)
            guiSetVisible(objIdSetButton, false)
        end
    elseif (source == attachCollisionCheck) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachCollision[attachID] = guiCheckBoxGetSelected(attachCollisionCheck)
            --setElementCollisionsEnabled(attachObject[attachID], attachCollision[attachID])
            triggerServerEvent("setObjCollision", getRootElement(), attachObject[attachID], attachCollision[attachID])
        end
    elseif (source == upButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachZ[attachID] = attachZ[attachID] + 0.1
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == downButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachZ[attachID] = attachZ[attachID] - 0.1
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == leftButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachX[attachID] = attachX[attachID] - 0.1
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == rightButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachX[attachID] = attachX[attachID] + 0.1
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == frontButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachY[attachID] = attachY[attachID] + 0.1
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == backButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachY[attachID] = attachY[attachID] - 0.1
triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == upRotXButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachRotX[attachID] = attachRotX[attachID] + 11
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == downRotXButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachRotX[attachID] = attachRotX[attachID] - 11
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == upRotYButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachRotY[attachID] = attachRotY[attachID] + 11
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == downRotYButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachRotY[attachID] = attachRotY[attachID] - 11
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == upRotZButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachRotZ[attachID] = attachRotZ[attachID] + 11
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == downRotZButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            attachRotZ[attachID] = attachRotZ[attachID] - 11
            triggerServerEvent("updateObj", getRootElement(), me, attachObject[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
        end
    elseif (source == objIdSetButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            local number = tonumber(guiGetText(objIdEdit))
            if (number >= 1 and number <= 18000) then
                attachObjectID[attachID] = number
                triggerServerEvent("updateObjId", getRootElement(), attachObject[attachID], attachObjectID[attachID])
                guiSetText(objIdEdit, tostring(number))
            end
        end
    elseif (source == downScaleButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            if (attachScale[attachID] > 0.25) then
                attachScale[attachID] = attachScale[attachID] - 0.1
                triggerServerEvent("setObjScale", getRootElement(), attachObject[attachID], attachScale[attachID])
            end
        end
    elseif (source == upScaleButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            if (attachScale[attachID] < 8) then
                attachScale[attachID] = attachScale[attachID] + 0.1
                triggerServerEvent("setObjScale", getRootElement(), attachObject[attachID], attachScale[attachID])
            end
        end
    elseif (source == downAlphaButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            if (attachAlpha[attachID] > 20) then
                attachAlpha[attachID] = attachAlpha[attachID] - 4
                triggerServerEvent("setObjAlpha", getRootElement(), attachObject[attachID], attachAlpha[attachID])
            end
        end
    elseif (source == upAlphaButton) then
        if (attachID ~= -1 and attachState[attachID] == "on") then
            if (attachAlpha[attachID] < 255) then
                attachAlpha[attachID] = attachAlpha[attachID] + 4
                triggerServerEvent("setObjAlpha", getRootElement(), attachObject[attachID], attachAlpha[attachID])
            end
        end
    end
end

function onDoubleClick()
    if (source == attachList) then
        attachID = guiGridListGetSelectedItem(attachList)
        selectedAttach = guiGridListGetItemText(attachList, attachID, attachColumn)
        if (attachID ~= -1) then
            if (attachObject[attachID] == nil) then
                attachState[attachID] = "on"
                attachScale[attachID] = 1
                triggerServerEvent("createObj", getRootElement(), attachID, me, attachObjectID[attachID],  attachX[attachID], attachY[attachID], attachZ[attachID], attachRotX[attachID], attachRotY[attachID], attachRotZ[attachID])
            else
                attachState[attachID] = "off"
                triggerServerEvent("destroyObj", getRootElement(), attachID, me, attachObject[attachID])
                
                attachCollision[attachID] = false
                attachScale[attachID] = 1
            end

            --guiGridListSetItemText(attachList, attachID, stateColumn, attachState[attachID], false, false)
            if (mtaVersion.number >= 260) then
                if (attachState[attachID] == "on") then
                    guiGridListSetItemColor(attachList, attachID, attachColumn, 0, 255, 0)
                    --guiGridListSetItemColor(attachList, attachID, stateColumn, 0, 255, 0)
                else
                    guiGridListSetItemColor(attachList, attachID, attachColumn, 255, 0, 0)
                    --guiGridListSetItemColor(attachList, attachID, stateColumn, 255, 0, 0)
                end
            end
        end
    end
end

function storeObj(id, theObject)
    attachObject[id] = theObject
    if (theObject ~= nil) then
        --setElementCollisionsEnabled(theObject, false)
        triggerServerEvent("setObjCollision", getRootElement(), theObject, false)
    end
end
-- ****************************
-- * Add all command handlers *
-- ****************************
addEvent("openAttach", true)
addEventHandler("openAttach", getRootElement(), attachInit)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onClose)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onClick)
addEventHandler("onClientGUIDoubleClick", getResourceRootElement(getThisResource()), onDoubleClick)

addEvent("storeObj", true)
addEventHandler("storeObj", getRootElement(), storeObj)
-- * Attachment initialization *
-- *****************************
function initializeAttach()
    local thePlayer = me


    local i = 0
    while (i < totalAttachs) do
        attachState[i] = "off"
        attachCollision[i] = false
        attachX[i], attachY[i], attachZ[i], attachRotX[i], attachRotY[i], attachRotZ[i] = 0, 0, 0, 0, 0, 0
        attachObject[i] = nil
        attachScale[i] = 1
        attachAlpha[i] = 255
        i = i + 1
    end

    attachObjectID[0] = 2738
    attachName[0] = "Toilet"
    attachRotZ[0] = 180

    attachObjectID[1] = 1607
    attachName[1] = "Dolphin"

    attachObjectID[2] = 2635
    attachName[2] = "Table"
    attachY[2] = 1.5
    attachZ[2] = -0.25

    attachObjectID[3] = 1582
    attachName[3] = "Pizza box"
    attachY[3] = 1.5

    attachObjectID[4] = 2456
    attachName[4] = "Burger Shot sign"
    attachZ[4] = 1.3

    attachObjectID[5] = 2993
    attachName[5] = "Green flag"
    attachRotZ[5] = 270
    attachZ[5] = 0.95

    attachObjectID[6] = 1337
    attachName[6] = "Recycle bin"
    attachY[6] = 1
    attachZ[6] = -0.25
    
    attachObjectID[7] = 1264
    attachName[7] = "Black bag"
    attachY[7] = 1
    attachZ[7] = -0.25

    attachObjectID[8] = 1518
    attachName[8] = "TV"
    attachY[8] = 1.5

    attachObjectID[9] = 2404
    attachName[9] = "Surfboard"
    attachRotX[9] = 270
    attachZ[9] = -1

    attachObjectID[10] = 3461
    attachName[10] = "Fire"

    attachObjectID[11] = 1443
    attachName[11] = "Adult sign"
    attachZ[11] = 1.3
    
    attachObjectID[12] = 1753
    attachName[12] = "Sofa 1"
    attachY[12] = -0.25
    attachZ[12] = -1
    attachRotZ[12] = 180

    attachObjectID[13] = 1771
    attachName[13] = "Bed"
    attachY[13] = 0.75

    attachObjectID[14] = 1240
    attachName[14] = "Heart"
    attachY[14] = 1.5

    attachObjectID[15] = 1247
    attachName[15] = "Star"
    attachY[15] = 1.5

    attachObjectID[16] = 1712
    attachName[16] = "Sofa 2"
    attachY[16] = -0.25
    attachZ[16] = -1
    attachRotZ[16] = 180

    attachObjectID[17] = 14446
    attachName[17] = "Bed 2"
    attachY[17] = 0.75
    attachRotZ[17] = 180

    attachObjectID[18] = 2780
    attachState[18] = "off"
    attachName[18] = "Smoke Machine"
    attachY[18] = -1.5
    attachZ[18] = -0.5

    attachObjectID[19] = 1839
    attachName[19] = "Hi-fi"
    attachY[19] = 1.5

    attachObjectID[20] = 3168
    attachName[20] = "Mobile home"
    attachZ[20] = -1
    attachRotZ[20] = 180

    attachObjectID[21] = 2406
    attachName[21] = "Surfboard 2"
    attachRotX[20] = 270
    attachZ[21] = -1

    attachObjectID[22] = 1486
    attachName[22] = "Beer"
    attachY[22] = 1.5

    attachObjectID[23] = 1550
    attachName[23] = "Money bag"
    attachY[23] = 1
    attachZ[23] = -0.25

    attachObjectID[24] = 2779
    attachName[24] = "Video game"
    attachY[24] = 1
    attachZ[24] = -1

    attachObjectID[25] = 1609
    attachName[25] = "Turtle"

    attachObjectID[26] = 3385
    attachName[26] = "Light"
    attachZ[26] = 1
    
    attachObjectID[27] = 3525
    attachName[27] = "Torch"
    attachRotZ[27] = 180
    attachY[27] = 1
    attachZ[27] = 1

    attachObjectID[28] = 7093
    attachName[28] = "Erotic sign"
    attachY[28] = 1.5
    attachZ[28] = 6

    attachObjectID[29] = 1231
    attachName[29] = "Street lamp"
    attachZ[29] = 1.5

    attachObjectID[30] = 1000
    attachName[30] = "Car spoiler 1"
    attachZ[30] = 1.5

    attachObjectID[31] = 1001
    attachName[31] = "Car spoiler 2"
    attachZ[31] = 1.5

    attachObjectID[32] = 1002
    attachName[32] = "Car spoiler 3"
    attachZ[32] = 1.5

    attachObjectID[33] = 1003
    attachName[33] = "Car spoiler 4"
    attachZ[33] = 1.5

    attachObjectID[34] = 1241
    attachName[34] = "Adrenaline"
    attachY[34] = 1
    attachZ[34] = 1

    attachObjectID[35] = 1274
    attachName[35] = "Dollar"
    attachZ[35] = 1

    attachObjectID[36] = 1318
    attachName[36] = "Arrow"
    attachRotZ[36] = 90
    attachZ[36] = 1.5

    attachObjectID[37] = 1276
    attachName[37] = "Tiki statue"
    attachY[37] = 1
    attachZ[37] = 1

    attachObjectID[38] = 1608
    attachName[38] = "Shark"

    attachObjectID[39] = 1222
    attachName[39] = "Barrel (non explosive)"
    attachY[39] = 1.5
    attachZ[39] = -0.5

    attachObjectID[40] = 1225
    attachName[40] = "Barrel (Explosive)"
    attachY[40] = 1.5
    attachZ[40] = -0.5

    attachObjectID[41] = 2222
    attachName[41] = "Donuts"
    attachY[41] = 1.5

    attachObjectID[42] = 2803
    attachName[42] = "Bag of meat"
    attachY[42] = 1

    attachObjectID[43] = 1262
    attachName[43] = "Traffic lights"

    attachObjectID[44] = 1765
    attachName[44] = "Chair"
    attachY[44] = -0.25
    attachZ[44] = -1

    attachObjectID[45] = 2964
    attachName[45] = "Pool table"
    attachRotZ[45] = 90
    attachY[45] = 1.5
    attachZ[45] = -1

    attachObjectID[46] = 1210
    attachName[46] = "Briefcase"
    attachY[46] = 1

    attachObjectID[47] = 2630
    attachName[47] = "Bike"
    attachY[47] = 1
    attachZ[47] = -1
    attachRotZ[47] = 90

    attachObjectID[48] = 1851
    attachName[48] = "Dice"
    attachY[48] = 1

    attachObjectID[49] = 1254
    attachName[49] = "Skull"
    attachY[49] = 1

    attachObjectID[50] = 1596
    attachName[50] = "Satellite"
    attachY[50] = 1

    attachObjectID[51] = 1440
    attachName[51] = "Boxes with trash bags"
    attachY[51] = 2

    attachObjectID[52] = 1655
    attachName[52] = "Ramp"
    attachY[52] = 2

    attachObjectID[53] = 621
    attachName[53] = "Palm tree"
    attachZ[53] = -1

    attachObjectID[54] = 1568
    attachName[54] = "Chinatown lamp-post"
    attachZ[54] = -1

    attachObjectID[55] = 1598
    attachName[55] = "Beach ball"
    attachY[55] = 1

    attachObjectID[56] = 3031
    attachName[56] = "Radio receiver"
    attachY[56] = 1

    attachObjectID[57] = 3056
    attachName[57] = "Horse shoe"
    attachY[57] = 1

    attachObjectID[58] = 3082
    attachName[58] = "Military green thing"
    attachY[58] = 1

    attachObjectID[59] = 3092
    attachName[59] = "Dead tied cop"
    attachY[59] = 1

    attachObjectID[60] = 3243
    attachName[60] = "Teepee"
    attachY[60] = 1

    attachObjectID[61] = 1437
    attachName[61] = "Big leaning ladder"
    attachY[61] = 1

    attachObjectID[62] = 1481
    attachName[62] = "Grill"
    attachY[62] = 1

    attachObjectID[63] = 1425
    attachName[63] = "Detour sign"
    attachY[63] = 1

    attachObjectID[64] = 16410
    attachName[64] = "Grave stones"
    attachY[64] = 1

    attachObjectID[65] = 1340
    attachName[65] = "Chili Dogs Stand"
    attachY[65] = 1.2
    attachRotZ[65] = 90

    attachObjectID[66] = 2918
    attachName[66] = "Mine"
    attachY[66] = 1

    attachObjectID[67] = 1211
    attachName[67] = "Fire hydrant"
    attachY[67] = 1

    attachObjectID[68] = 1686
    attachName[68] = "Fuel distributor"
    attachY[68] = 1.2
    attachRotZ[68] = 90

    attachObjectID[69] = 1248
    attachName[69] = "U.F.O."
    attachY[69] = 1

    attachObjectID[70] = 800
    attachName[70] = "Bush"
    attachZ[70] = 1

    attachObjectID[71] = 2985
    attachName[71] = "Machine gun"
    attachY[71] = 1
    attachRotZ[71] = 90

    attachObjectID[72] = 3077
    attachName[72] = "Blackboard"
    attachY[72] = 1
    attachZ[72] = -1

    attachObjectID[73] = 2114
    attachName[73] = "Basket ball"
    attachY[73] = 1

    attachObjectID[74] = 1257
    attachName[74] = "Bus stop"

    attachObjectID[75] = 1238
    attachName[75] = "Traffic cone"
    attachY[75] = 1

    attachObjectID[76] = 1432
    attachName[76] = "Round table with chairs"
    attachY[76] = 1

    attachObjectID[77] = 1515
    attachName[77] = "Poker machine"
    attachY[77] = 1

    attachObjectID[78] = 2899
    attachName[78] = "Stinger"
    attachY[78] = 3
    attachZ[78] = -0.8
    
    attachObjectID[79] = 330
    attachName[79] = "Cell Phone"

    attachObjectID[80] = 1582
    attachName[80] = "(User defined)"
end

function destroyAllAttach()
    local i = 0
    while i < totalAttachs do
        if attachObject[i] ~= nil then
            triggerServerEvent("destroyObj", getRootElement(), i, me, attachObject[i])
        end
        i = i + 1
    end
end

addEventHandler("onClientResourceStart", getRootElement(), 
    function(resource)
        if (resource == getThisResource()) then
            initializeAttach()
        end
    end
)

addEventHandler("onClientResourceStop", getRootElement(), 
    function(resource)
        if (resource == getThisResource()) then
            destroyAllAttach()
            initializeAttach()
        end
    end
)

addEventHandler("onClientPlayerQuit", getRootElement(),
    function()
        if (source == me) then
            destroyAllAttach()
        end
    end
)

addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
        if (thePlayer == me) then
            destroyAllAttach()
            initializeAttach()
        end
    end
)

addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
        if (thePlayer == me) then
            destroyAllAttach()
            initializeAttach()
        end
    end
)

addEventHandler("onClientElementDestroy", getRootElement(),
    function()
        if (getElementType(source) == "vehicle" and getPedOccupiedVehicle(me) == source) then
            destroyAllAttach()
            initializeAttach()
        end
    end
)

function isAttachOpened()
    local ham = guiGetVisible(attachWindow)
    return ham
end

function closeAttach()
    ham = guiSetVisible(attachWindow, false)
    return ham
end
function showAttach()
    ham =  guiSetVisible(attachWindow, true)
    return ham
end

function getAttachWindow()
    return attachWindow
end