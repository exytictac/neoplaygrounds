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

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), 
    function()
        setTimer(
            function()
                triggerServerEvent("staffonline:getStringsFromServer", getLocalPlayer())
            end
        , 1000, 1)
    end
)