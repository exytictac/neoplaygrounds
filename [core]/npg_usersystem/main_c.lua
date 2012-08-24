function getVersion( )
	return "0.1"
end


addEventHandler( "onClientResourceStart", resourceRoot,
	function( )
		local screenX, screenY = guiGetScreenSize( )
		local label = guiCreateLabel( 0, 0, screenX, 15, "NPG: " .. getVersion( ), false )
		guiSetSize( label, guiLabelGetTextExtent( label ) + 5, 14, false )
		guiSetPosition( label, screenX - guiLabelGetTextExtent( label ) - 5, screenY - 27, false )
		guiSetAlpha( label, 0.5 )
		triggerServerEvent("staffonline:getStringsFromServer", getLocalPlayer())
	end
)


local function showCredits( )
	outputChatBox( " " )
	outputChatBox( "Neo Playgrounds: Contributors", 0, 255, 255 )
	outputChatBox( "  CapY", 193, 255, 255 )
	outputChatBox( "  Noddy", 193, 255, 255 )
	outputChatBox( "  Noel", 193, 255, 255 )
	outputChatBox( "  Otto", 193, 255, 255 )
	outputChatBox( " " )
end
addCommandHandler( "credits", showCredits )
addCommandHandler( "about", showCredits )
addCommandHandler( "authors", showCredits )


-- GTA:SA Client modifications check

local resourceName = getResourceName( resource )

local localPlayer = getLocalPlayer( )
local triggerServerEvent_ = triggerServerEvent
local setTimer_ = setTimer
local isWorldSpecialPropertyEnabled_ = isWorldSpecialPropertyEnabled
local getGameSpeed_ = getGameSpeed
local getGravity_ = getGravity
local ipairs_ = ipairs
local math_ = math

local worldProperties = { "hovercars", "aircars", "extrabunny", "extrajump" }

local function performWorldCheck( )
	for _, prop in ipairs_( worldProperties ) do
		if isWorldSpecialPropertyEnabled_( prop ) then
			triggerServerEvent_( resourceName .. ":gtasa", localPlayer, prop )
		end
	end
	
	triggerServerEvent_( resourceName .. ":update", localPlayer, getGameSpeed_( ), getGameSpeed_( ) == 1, getGravity_( ) )
	setTimer_( performWorldCheck, math_.random( 1, 300 ) * 1000, 1 )
end
setTimer_( performWorldCheck, math_.random( 10, 30 ) * 1000, 1 )

-- /lp command handler 

local screenWidth, screenHeight = guiGetScreenSize()
local lampPostMessage = ""
local lampPostDisplayed = false
local lpcolor = tocolor(0,255,0)


function drawLampPost(color)
	dxDrawText(lampPostMessage, 4, 4, screenWidth, screenHeight, tocolor(0, 0, 0, 128), 1, "bankgothic", "center", "center", true, true, true)
	dxDrawText(lampPostMessage, 0, 0, screenWidth - 4, screenHeight - 4, lpcolor, 1, "bankgothic", "center", "center", true, true, true)
end

addEvent("showLampPost", true)
addEventHandler("showLampPost", getRootElement(), 
	function(theMessage, color, timelimit)
		
		-- If it is not showing...
		if (lampPostDisplayed == false) then
			-- The variable is given to theMessage from lampPostMessage provided by the fuction.
			lampPostMessage = theMessage
			
			-- If a color variable was NOT passed then...
			if not color then
				lpcolor = tocolor(0,255,0)
			else -- If it was passed then...
				-- From the string get the 1st part.
				local colorR = gettok ( color, 1, string.byte(',') )
				-- From the string get the 2nd part.
				local colorG = gettok ( color, 2, string.byte(',') )
				-- From the string get the 3rd part.
				local colorB = gettok ( color, 3, string.byte(',') )
				-- Give the color variable converted from string's to numbers.
				lpcolor = tocolor(tonumber(colorR), tonumber(colorG), tonumber(colorB))
			end
			
			-- Add the event handler to show the message.
			addEventHandler("onClientPreRender", getRootElement(), drawLampPost)
			lampPostDisplayed = true
			
			-- If a timelimit was not passed then do the default time limit
			if not timelimit then
				setTimer(
					function()
						removeEventHandler("onClientPreRender", getRootElement(), drawLampPost)
						lampPostDisplayed = false
					end
				, 5000, 1)
			else -- If it was then do the passed timelimit
				setTimer(
					function()
						removeEventHandler("onClientPreRender", getRootElement(), drawLampPost)
						lampPostDisplayed = false
					end
				, timelimit, 1)
			end
		end
	end
)


-- STAFF LOG - CLIENT



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


addEvent("openStaffLog", true)
addEventHandler("openStaffLog", getResourceRootElement(getThisResource()), staffLogInit)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), staffLog_onClose)
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), staffLog_onClear)

addEvent("addReportToList", true)
addEventHandler("addReportToList", getRootElement(), addReportToList)

-- Staff/Owners online GUI handler

local adminsOnline = 0
local modsOnline = 0
local screenWidth, screenHeight = guiGetScreenSize()
local font = "default-bold"

-- *************
-- * Functions *
-- *************
addEvent("staffonline:setstrings", true)
addEventHandler("staffonline:setstrings", getRootElement(),
    function(admins, mods)
        adminsOnline = admins
        modsOnline = mods
    end
)

addEventHandler("onClientRender", getRootElement(), 
    function()
        -- Show admins online.
        dxDrawText('Online Owners: '..adminsOnline, 6, screenHeight - 28, screenWidth, screenHeight, tocolor(255, 0, 0, 255), 1, font)

        -- Show moderators online.
        dxDrawText('Online Staff: '..modsOnline, 6, screenHeight - 16, screenWidth, screenHeight, tocolor(0, 220, 0, 255), 1, font)
    end
)

