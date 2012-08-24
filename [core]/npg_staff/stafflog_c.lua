-- Written by Tommy (c) 2010

local screenWidth, screenHeight = guiGetScreenSize()

-- *******************************
-- *  Staff log initialization   *
-- *******************************
function staffLogInit(source)
    local theWindow = staffLogWindow and guiGetVisible(staffLogWindow)
    if (theWindow == true) then
        showCursor(false)
        guiSetVisible(staffLogWindow, false)
    else
        -- Create the window.
        staffLogWindow = guiCreateWindow((screenWidth / 2 - 300), (screenHeight / 2 - 175), 600, 350, "Staff log", false)
    
        -- Create the "Close" button.
        staffLogCloseButton = guiCreateButton(0.88, 0.90, 0.15, 0.12, "Close", true, staffLogWindow)
        
        -- Create the "Clear list" button.
        staffLogClearButton = guiCreateButton(0.69, 0.90, 0.18, 0.12, "Clear all reports", true, staffLogWindow)

        -- Create the cheat list.       
        staffLogList = guiCreateGridList(0.02, 0.09, 0.98, 0.80, true, staffLogWindow)
        dateColumn = guiGridListAddColumn(staffLogList, "Date", 0.25)
        playerColumn = guiGridListAddColumn(staffLogList, "Player", 0.15)
        typeColumn = guiGridListAddColumn(staffLogList, "Type", 0.25)
        infoColumn = guiGridListAddColumn(staffLogList, "Additional info", 0.30)
        
        triggerServerEvent("initializeReportsList", getRootElement())

        -- Add a label for displaying the number of cheats reported.
        reportsCountLabel = guiCreateLabel(0.02, 0.93, 0.30, 0.12, "...", true, staffLogWindow)
        
        local reportsCount = guiGridListGetRowCount(staffLogList)
        if (reportsCount == 0) then
            guiSetText(reportsCountLabel, "No reports.")
        elseif (reportsCount == 1) then
            guiSetText(reportsCountLabel, "1 report.")
        else
            guiSetText(reportsCountLabel, tostring(reportsCount) .. " reports.")
        end

        showCursor(true)
        guiWindowSetSizable(staffLogWindow, false)
        guiSetVisible(staffLogWindow, true)
    end
end

-- ********************
-- *  Event handlers  *
-- ********************
function addReportToList(theDate, thePlayer, reportType, moreInfo)
    local row = guiGridListAddRow(staffLogList)
    if (row) then
        guiGridListSetItemText(staffLogList, row, dateColumn, theDate, false, false)
        guiGridListSetItemText(staffLogList, row, playerColumn, thePlayer, false, false)
        guiGridListSetItemText(staffLogList, row, typeColumn, reportType, false, false)
        guiGridListSetItemText(staffLogList, row, infoColumn, moreInfo, false, false)
    end

    local reportsCount = guiGridListGetRowCount(staffLogList)
    if (reportsCount == 0) then
        guiSetText(reportsCountLabel, "No reports.")
    elseif (reportsCount == 1) then
        guiSetText(reportsCountLabel, "1 report.")
    else
        guiSetText(reportsCountLabel, tostring(reportsCount) .. " reports.")
    end
end

function staffLog_onClose()
    if (source == staffLogCloseButton) then
        guiSetVisible(staffLogWindow, false)
        showCursor(false)
    end
end

function staffLog_onClear()
    if (source == staffLogClearButton) then
        guiSetText(reportsCountLabel, "No reports.")
        guiGridListClear(staffLogList)
        triggerServerEvent("deleteAllReports", getRootElement())
    end
end

-- *********************************
-- *  Event handlers registration  *
-- *********************************
addEvent("openStaffLog", true)
addEventHandler("openStaffLog", getResourceRootElement(getThisResource()), staffLogInit)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), staffLog_onClose)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), staffLog_onClear)

addEvent("addReportToList", true)
addEventHandler("addReportToList", getRootElement(), addReportToList)