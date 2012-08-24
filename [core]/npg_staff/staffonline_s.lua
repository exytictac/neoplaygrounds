local adminsOnline = 0
local moderatorsOnline = 0

function updateAdminsOnline()
	adminsOnline = 0

	for i, thePlayer in ipairs(getElementsByType("player")) do
		if getPlayerClass(thePlayer) >= 3 then
			adminsOnline = adminsOnline+1
		end
	end
end

function updateModeratorsOnline()
	moderatorsOnline = 0

	for i, thePlayer in ipairs(getElementsByType("player")) do
		if tonumber(getPlayerClass(thePlayer)) == 2 then
			moderatorsOnline = moderatorsOnline + 1
		end
	end
end

function sendStrings()
	triggerClientEvent("staffonline:setstrings", getRootElement(), adminsOnline, moderatorsOnline)
end
function updateStrings()
	setTimer(updateAdminsOnline, 1000, 1)
	setTimer(updateModeratorsOnline, 1000, 1)
	setTimer(sendStrings, 2000, 1)
end
addEvent("staffonline:getStringsFromServer", true)
addEventHandler("staffonline:getStringsFromServer", getRootElement(),updateStrings)
addEventHandler("onPlayerLogout", getRootElement(),updateStrings)
addEventHandler("onPlayerQuit", getRootElement(),updateStrings)
addEventHandler("onPlayerChangeNick", getRootElement(),updateStrings)
addEventHandler("onPlayerLogin", getRootElement(), updateStrings)

addEventHandler("onElementDataChange", getRootElement(),
	function(dataName)
		if dataName == "hideTag" or dataName == "stealthMode" then
			updateStrings()
		end
	end
)