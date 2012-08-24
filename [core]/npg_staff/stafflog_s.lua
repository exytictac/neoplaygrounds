
-- ******************************************
-- * AFS Staff / Staff log                  *
-- * Written by Tommy (c) 2010              *
-- ******************************************

local reportsCount = 0

local reportDate = { }
local reportPlayer = { }
local reportType = { }
local reportInfo = { }

-- *******************
-- *    Functions    *
-- *******************
function getPlayerClass(thePlayer)
    return getElementData(thePlayer, "auth") or 0
end

function isPlayerLogged(thePlayer)
    local theAccount = getElementData(thePlayer, "account")
    if (theAccount == false) then
        return false
    else
        return true
    end
end

addCommandHandler("stafflog",
    function(source)
        if (getPlayerClass(source) >= 2) then
            triggerClientEvent(source, "openStaffLog", getRootElement())
        end
    end
)

function initializeReportsList()
    local i = 0
    while (i < reportsCount) do
        triggerClientEvent(source, "addReportToList", getRootElement(), reportDate[i], reportPlayer[i], reportType[i], reportInfo[i])
        i = i + 1
    end
end

addEvent("reportToStaffLog", true)
addEventHandler("reportToStaffLog", getRootElement(),
    function(thePlayer, typeReport, moreInfo)
        local time = getRealTime()

        reportDate[reportsCount] = tostring(time.hour) .. ":" .. tostring(time.minute) .. ":" .. tostring(time.second) .. ", " .. tostring(time.year) + 1900 .. "-" .. tostring(time.month) .. "-" .. tostring(time.monthday)
        reportPlayer[reportsCount] = getPlayerName(thePlayer)
        reportType[reportsCount] = typeReport
        reportInfo[reportsCount] = moreInfo

        local playerReportsCount = getElementData(thePlayer, "reportsCount")
        if (playerReportsCount == false) then
            playerReportsCount = 1
        else
            playerReportsCount = playerReportsCount + 1
        end
        setElementData(thePlayer, "reportsCount", playerReportsCount)

        triggerClientEvent(thePlayer, "addReportToList", getRootElement(), reportDate[reportsCount], reportPlayer[reportsCount], reportType[reportsCount], reportInfo[reportsCount])
        reportsCount = reportsCount + 1
    end
)

function deleteAllReports()
    reportDate = { }
    reportPlayer = { }
    reportType = { }
    reportInfo = { }
    reportsCount = 0

    local playersList = getElementsByType("player")
    for i, thePlayer in pairs(playersList) do
        setElementData(thePlayer, "reportsCount", 0)
    end
end

addEventHandler("onPlayerJoin", getRootElement(),
    function()
        setElementData(source, "reportsCount", 0)
    end
)

addEventHandler("onResourceStart", getResourceRootElement(),
    function()
        local playersList = getElementsByType("player")
        for i, thePlayer in pairs(playersList) do
            setElementData(thePlayer, "reportsCount", 0)
            bindKey(thePlayer, 'F5', 'down', 'stafflog')
        end
    end
)

addEvent("initializeReportsList", true)
addEventHandler("initializeReportsList", getRootElement(), initializeReportsList)
addEvent("deleteAllReports", true)
addEventHandler("deleteAllReports", getRootElement(), deleteAllReports)

addEventHandler("onPlayerJoin", getRootElement(),
    function()
        bindKey(source, 'F5', 'down', 'stafflog')
    end
)
