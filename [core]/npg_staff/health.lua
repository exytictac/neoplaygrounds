--[[
addEventHandler("onPlayerDamage", getRootElement(),
	function(attacker, weapon, bodypart, loss)
		if (getElementDimension(source) == 0) then
			if (getElementHealth(source) == 100) then
				-- If the health is still 100, we report it.
				triggerEvent("reportToStaffLog", getRootElement(), source, "Health hack", "(none)")
			end
		end
	end
);
]]
addEventHandler("onPlayerWasted", getRootElement(),
	function(ammo, attacker, weapon, bodypart)
		if (getElementDimension(source) == 1) then
			if (getElementHealth(source) == 100) then
				-- If the health is still 100, we report it.
				triggerEvent("reportToStaffLog", getRootElement(), source, "Health hack", "(none)")
			end
		end
	end
);
