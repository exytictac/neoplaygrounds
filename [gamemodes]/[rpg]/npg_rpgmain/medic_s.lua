local medicVehicle = 416

addEventHandler ( "onClientVehicleStartEnter", resourceRoot,
	function ( thePlayer )
		if not getElementData ( thePlayer, "gamemode" ) == "rpg" then return end
			if getElementModel ( thePlayer ) == medicVehicle then
				if not isPlayerInTeam ( thePlayer, "Medic" ) then 
					return outputChatBox ( "You are not a medic", thePlayer ) 
				end
			end
	end
)
		

addCommandHandler ( "heal", 
function ( thePlayer, _, targetPlayer )
if getElementData ( thePlayer, "gamemode" ) ~= "rpg" then return end	
local target = findPlayer(targetPlayer, thePlayer)
	if not target then 
		return 
	end
	if not isPlayerInTeam ( thePlayer, "Medic" ) then 
		return triggerEvent ( "onMedicOutput", thePlayer )
	end
		if not target then 
			return outputChatBox("Syntax: /heal <player partial name>", thePlayer)
		end
			if target == thePlayer then 
				return outputChatBox("You can't heal yourself", thePlayer) 
			else
				outputChatBox ( "* You healed " ..getPlayerName(target), thePlayer, 0, 255,0 )
				setElementHealth ( target, 100 )
			end
			local tx, ty, tz = getElementPosition(target)
			if not isPlayerInRangeOfPoint(thePlayer, tx, ty, tz, 3) then 
				return outputChatBox("You are too far from "..getPlayerName(target), thePlayer) 
			end


end
)