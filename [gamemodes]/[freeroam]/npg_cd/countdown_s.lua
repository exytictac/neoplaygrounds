addEventHandler("onResourceStart", getResourceRootElement(),
	function()
		for i,v in ipairs(getElementsByType("player")) do
			setElementData(v, "countdown:using", false, true)
		end
	end
)

addEventHandler("onPlayerJoin", root, function()
		setElementData(source, "countdown:using", false, true)
	end
)

-- *****************
-- *   Functions   *
-- *****************
function startCountDown(me)
	if getElementData(me, "countdown:using") ~= true then
		triggerClientEvent("startCountDown", root, me)
		setElementData(me, "countdown:using", true, true)
		setTimer(setElementData, 5000, 1, me, "countdown:using", false, true)
	end
end

addCommandHandler("cd", startCountDown)
