local _dt = dxDrawText
me = getLocalPlayer()
screenWidth, screenHeight = guiGetScreenSize()
root = getRootElement()
resRoot = getResourceRootElement(getThisResource())
MH_DIMENSION = 420

function iif(a,b,c) if a then return b else return c end return nil end

string.split = function(beads, seperator)
	local result = {}
	seperator = seperator == "." and "%." or seperator
	for part in beads:gmatch("(.-)" .. seperator) do
		result[#result + 1] = part
	end
	result[#result + 1] = beads:match(".*" .. seperator .. "(.*)$") or beads
	return result
end

function getKeyNameFromAction(action)
	local aKeys = getBoundKeys(action)
	if not aKeys then
		return "'" .. action .. "'"
	else
		for key,_ in pairs(aKeys) do
			if key and key ~= "" then
				return "'" .. key .. "' ('" .. action .. "')"
			end
		end
		return "'" .. action .. "'"
	end
end

function isElementInWater(ped)
	local bInWater = isElementInWater(ped)
	if bInWater then
		return true
	else
		local x, y, z = getElementPosition(ped)
		return testLineAgainstWater(x, y, z, x, y, z + 500)
	end
end

function dxDrawText(str, ax, ay, bx, by, color, scale, font)
  local pat = "(.-)#(%x%x%x%x%x%x)"
  local s, e, cap, col = str:find(pat, 1)
  local last = 1
  while s do
    if s ~= 1 or cap ~= "" then
      local w = dxGetTextWidth(cap, scale, font)
      _dt(cap, ax, ay, ax + w, by, color, scale, font)
      ax = ax + w
      color = tocolor(tonumber("0x"..string.sub(col, 1, 2)), tonumber("0x"..string.sub(col, 3, 4)), tonumber("0x"..string.sub(col, 5, 6)), 255)
    end
    last = e+1
    s, e, cap, col = str:find(pat, last)
  end
  if last <= #str then
    cap = str:sub(last)
    local w = dxGetTextWidth(cap, scale, font)
    _dt(cap, ax, ay, ax + w, by, color, scale, font)
  end
end

function dxDrawBorderedText(outlineSize, outlineColor, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
	if not outlineColor then outlineColor = 0x000000FF end
	if not color then color = 0xFFFFFFFF end
    for oX = -1*outlineSize, outlineSize do
		for oY = -1*outlineSize, outlineSize do
			dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, outlineColor, scale, font, alignX, alignY, clip, wordBreak, postGUI)
		end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end