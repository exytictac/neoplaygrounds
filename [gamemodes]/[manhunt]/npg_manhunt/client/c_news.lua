-- This script is open and is owned by The_GTA and Jesseunit, please give credits to them!

local start = getTickCount();
local duration = 30000;
local screenWidth, screenHeight = guiGetScreenSize();
local font = "bankgothic";
local scale = 0.6;

local newsMsg = {
"Manhunt, hunt down the vehicles of the bowl!",
"Press M to toggle cursor!"
}

local text = getRandomFromTable(newsMsg)

function drawNews()
	--local now = getTickCount();
	--local time = now - start;
	--local width = dxGetTextWidth(text, scale, font);

	dxDrawRectangle(0, screenHeight-27, screenWidth, 27, tocolor(0, 0, 0, 150));

	--[[if time > duration then
		start = now;

		text = getRandomFromTable(newsMsg) ;
	end

	dxDrawText(text, math.mod(time, duration) / duration * (screenWidth + width) - width, screenHeight-25, 0, 0, tocolor(255, 200, 0, 255), scale, font)]]
end