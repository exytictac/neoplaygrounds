-- ***********************************************
-- * NPG - General                               *
-- * Written by NPG Team  (c) 2011               *
-- ***********************************************

local showMyIcon = true
local chattingPlayers = {}
local drawDistance = 1000
local chatIconFor = {}

local screenSizex, screenSizey = guiGetScreenSize()
local guix = screenSizex * 0.1
local guiy = screenSizex * 0.1
local globalscale = 1
local globalalpha = .85

addEvent("afk:updatelist", true )

local function showTextIcon()
	local playerx,playery,playerz = getElementPosition ( localPlayer )
	for player, truth in pairs(chattingPlayers) do
		
		if isElement(player) then
		
			if (player == localPlayer) then
				if(not showMyIcon) then
					return
				end
			end
		
			if not getElementData(player, "stealthMode") then
				if(truth) then
					local chatx, chaty, chatz = getElementPosition( player )
					if(isPedInVehicle(player)) then
						chatz = chatz + .5
					end
					local dist = getDistanceBetweenPoints3D ( playerx, playery, playerz, chatx, chaty, chatz )
					if dist < drawDistance then
						if( isLineOfSightClear(playerx, playery, playerz, chatx, chaty, chatz, true, false, false, false )) then
							local screenX, screenY = getScreenFromWorldPosition ( chatx, chaty, chatz+1.2 )
							
							local scaled = screenSizex * (1/(2*(dist+5))) *.85
							local relx, rely = scaled * globalscale, scaled * globalscale
							guiSetAlpha(chatIconFor[player], globalalpha)
							if(screenX and screenY) then
								guiSetVisible(chatIconFor[player], true)
								guiSetSize(chatIconFor[player], relx, rely, false)
								guiSetPosition(chatIconFor[player], screenX, screenY, false)
							else
								guiSetAlpha(chatIconFor[player], 0)
							end
						end
					end
				end
			end
		end
	end
end

local function updateList(newEntry, newStatus)
	chattingPlayers[newEntry] = newStatus
	if not chatIconFor[newEntry] then
		chatIconFor[newEntry] = guiCreateStaticImage(0, 0, guix, guiy, "afk.png", false )
	end
	guiSetVisible(chatIconFor[newEntry], false)
end

addEventHandler ( "afk:updatelist", getRootElement(), updateList )
addEventHandler ( "onClientRender", getRootElement(), showTextIcon )

addEventHandler("onClientPlayerDamage", root, function(a)
		if (getElementData(source, "invincible") == true) then
			cancelEvent()
			return
		end
	end
)