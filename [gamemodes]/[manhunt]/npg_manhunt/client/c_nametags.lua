--[[
	Type: Gamemode
	Started: 6th July (Wednesday) 2011
	Finished: ...
	Official Developer: noddy

	You may edit this script to modify functionality to your liking, however you must 
	state what you modified.
]]
-- Thanks to Talidan and arc_ this was found from arc_'s race resource, for license (if exists) go to that resource.
local nametags = {}
local g_screenX,g_screenY = guiGetScreenSize()
local bHideNametags = false

local NAMETAG_SCALE = 0.3 --Overall adjustment of the nametag, use this to resize but constrain proportions
local NAMETAG_ALPHA_DISTANCE = 50 --Distance to start fading out
local NAMETAG_DISTANCE = 120 --Distance until we're gone
local NAMETAG_ALPHA = 120 --The overall alpha level of the nametag
--The following arent actual pixel measurements, they're just proportional constraints
local NAMETAG_TEXT_BAR_SPACE = 2
local NAMETAG_WIDTH = 50
local NAMETAG_HEIGHT = 5
local NAMETAG_TEXTSIZE = 0.7
local NAMETAG_OUTLINE_THICKNESS = 1.2
--
local NAMETAG_ALPHA_DIFF = NAMETAG_DISTANCE - NAMETAG_ALPHA_DISTANCE
NAMETAG_SCALE = 1/NAMETAG_SCALE * 800 / g_screenY 

-- Ensure the name tag doesn't get too big
local maxScaleCurve = { {0, 0}, {3, 3}, {13, 5} }
-- Ensure the text doesn't get too small/unreadable
local textScaleCurve = { {0, 0.8}, {0.8, 1.2}, {99, 99} }
-- Make the text a bit brighter and fade more gradually
local textAlphaCurve = { {0, 0}, {25, 100}, {120, 190}, {255, 190} }

function createPlayerNametag(player)
	nametags[player] = true
end

function destroyPlayerNametag(player)
	nametags[player] = nil
end

addEventHandler("onClientRender", root,
	function()
		-- Hideous quick fix --
		for i,player in ipairs(getElementsByType("player")) do
			if player ~= me and getElementData(player, "gamemode")=="manhunt" then
				setPlayerNametagShowing(player, true)
				if not nametags[player] then
					createPlayerNametag ( player )
				end
			end
		end
		if bHideNametags then
			return
		end
		local x,y,z = getCameraMatrix()
		for player in pairs(nametags) do 
			while true do
				if not isPedInVehicle(player) or isPlayerDead(player) then
					setPlayerNametagShowing ( player, true )
					break
				end
				local vehicle = getPedOccupiedVehicle(player)
				if not vehicle then return end
				if getVehicleController(vehicle) ~= player then
					setPlayerNametagShowing ( player, true )
					break
				end
				setPlayerNametagShowing ( player, false )
				local px,py,pz = getElementPosition ( vehicle )
				local pdistance = getDistanceBetweenPoints3D ( x,y,z,px,py,pz )
				if pdistance <= NAMETAG_DISTANCE then
					--Get screenposition
					local sx,sy = getScreenFromWorldPosition ( px, py, pz+0.95, 0.06 )
					if not sx or not sy then break end
					--Calculate our components
					local scale = 1/(NAMETAG_SCALE * (pdistance / NAMETAG_DISTANCE))
					local alpha = ((pdistance - NAMETAG_ALPHA_DISTANCE) / NAMETAG_ALPHA_DIFF)
					alpha = (alpha < 0) and NAMETAG_ALPHA or NAMETAG_ALPHA-(alpha*NAMETAG_ALPHA)
					scale = math.evalCurve(maxScaleCurve,scale)
					local textscale = math.evalCurve(textScaleCurve,scale)
					local textalpha = math.evalCurve(textAlphaCurve,alpha)
					local outlineThickness = NAMETAG_OUTLINE_THICKNESS*(scale)
					--Draw our text
					local r,g,b = 255,255,255
					local team = getPlayerTeam(player)
					if team then
						r,g,b = getTeamColor(team)
					end
					local offset = (scale) * NAMETAG_TEXT_BAR_SPACE/2
					dxDrawText ( getPlayerName(player), sx, sy - offset, sx, sy - offset, tocolor(r,g,b,textalpha), textscale*NAMETAG_TEXTSIZE, "default", "center", "bottom", false, false, false )
					--We draw three parts to make the healthbar.  First the outline/background
					local drawX = sx - NAMETAG_WIDTH*scale/2
					drawY = sy + offset
					local width,height =  NAMETAG_WIDTH*scale, NAMETAG_HEIGHT*scale
					dxDrawRectangle ( drawX, drawY, width, height, tocolor(0,0,0,alpha) )
					--Next the inner background 
					local health = getElementHealth(vehicle)
					health = math.max(health - 250, 0)/750
					local p = -510*(health^2)
					local r,g = math.max(math.min(p + 255*health + 255, 255), 0), math.max(math.min(p + 765*health, 255), 0)
					dxDrawRectangle ( 	drawX + outlineThickness, 
										drawY + outlineThickness, 
										width - outlineThickness*2, 
										height - outlineThickness*2, 
										tocolor(r,g,0,0.4*alpha) 
									)
					--Finally, the actual health
					dxDrawRectangle ( 	drawX + outlineThickness, 
										drawY + outlineThickness, 
										health*(width - outlineThickness*2), 
										height - outlineThickness*2, 
										tocolor(r,g,0,alpha) 
									)			
				end
				break
			end
		end
	end
)


---------------THE FOLLOWING IS THE MANAGEMENT OF NAMETAGS-----------------
addEvent("onClientPlayerSelectGamemode", true)
addEventHandler("onClientPlayerSelectGamemode", root, function(gm)
		if gm~="manhunt" then return end
		for i,player in ipairs(getElementsByType"player") do
			if player ~= me then
				createPlayerNametag(player)
			end
		end
	end
)

addEventHandler ( "onClientPlayerQuit", root,
	function()
		destroyPlayerNametag(source)
	end
)


addEvent ( "onClientScreenFaded", true )
addEventHandler ( "onClientScreenFaded", root,
	function(inout)
		bHideNametags = not inout -- true for fade in.
	end
)