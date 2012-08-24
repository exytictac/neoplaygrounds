
-- ***********************************************
-- * AFS Extras / Countdown                      *
-- * Written by Tommy (c) 2010                   *
-- ***********************************************

local screenWidth, screenHeight = guiGetScreenSize()
local me = getLocalPlayer()
local countDown = {}
local countDownColors = {
	[0] = {0, 255, 0, 255},
	[1] = {255, 0, 0, 255},
	[2] = {255, 0, 0, 255},
	[3] = {255, 0, 0, 255}
}

-- ******************
-- * Event handlers *
-- ******************
function drawCountDown()
	local playerX, playerY, playerZ = getElementPosition(me)
	for id, playerItem in ipairs(getElementsByType("player")) do
		if (getElementData(playerItem, "countdown:using") == true) then
			
			local imgX, imgY, imgZ = getElementPosition(playerItem)
			if (isPedInVehicle(playerItem)) then
				imgZ = imgZ + .5
			end
			local dist = getDistanceBetweenPoints3D(playerX, playerY, playerZ, imgX, imgY, imgZ)
			if (dist <= 80) then
				if (isLineOfSightClear(playerX, playerY, playerZ, imgX, imgY, imgZ, true, false, false, false)) then
					local screenX, screenY = getScreenFromWorldPosition(imgX, imgY, imgZ + 1.2)
					if (screenX and screenY) then

						color = tocolor( unpack(countDownColors[countDown[playerItem]]) )
					
						if (countDown[playerItem] == 0) then
							--dxDrawText("GO!", screenX + 8, screenY + 8, screenX + 118, screenY + 88, tocolor(0, 0, 0, 128), 3, "pricedown", "center", "top", true, true, true)
							dxDrawText("GO!", screenX, screenY, screenX + 110, screenY + 80, color, 3, "pricedown", "center", "top", true, true, true)
						else
							--dxDrawText(tostring(countDown+1), screenX + 8, screenY + 8, screenX + 88, screenY + 88, tocolor(0, 0, 0, 128), 3, "pricedown", "center", "top", true, true, true)
							dxDrawText(tostring(countDown[playerItem]), screenX, screenY, screenX + 80, screenY + 80, color, 3, "pricedown", "center", "top", true, true, true)
						end
					end
				end
			end
		end
	end
end

addEvent("startCountDown", true)
addEventHandler("startCountDown", getRootElement(), 
	function(player)
		countDown[player] = 4
		setTimer(
			function()
				countDown[player] = countDown[player] - 1
				playSoundFrontEnd(countDown[player]==0 and 45 or 44)
			end
		, 1000, 4)
	end
)

addEventHandler("onClientPreRender", getRootElement(), drawCountDown)