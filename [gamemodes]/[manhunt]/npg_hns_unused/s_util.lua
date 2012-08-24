_D = outputDebugString
local ie = isElement

function isElement(element, type)
	if element and ie(element) then
		return getElementType(element, type)
	end
end

function math.round(number)
  return math.floor(number + 0.5)
end

function table.containsValue(haystack, needle)
	for _,value in ipairs(haystack) do
		if value == needle then
			return true
		end
	end
	return false
end
function table.findValue(haystack, needle)
	if not haystack or not needle then
		return nil
	end
	for pos,value in ipairs(haystack) do
		if value == needle then
			return pos
		end	
	end
	return nil
end

function iif(a,b,c)
	if a then
		return b
	else
		return c
	end
	return nil
end

function getPlayerClass(p)
	return getElementData(p, "class") or 1
end

function getElements(tab)
	if type(tab) == "string" then
		tab = string.split(tab, string.byte(" "))
	end
	local ret = {}
	local index = 0
	for _,ele in ipairs(tab) do
		for i,v in ipairs(getElementsByType(ele)) do
			table.insert(ret, index+1, v)
		end
	end
	return ret
end

function moveElements(type, ...)
	local args = {...}
	if type == "dimension" then
		local old = args[1]
		local new = args[2]
		for i,v in ipairs(getElements({"player", "vehicle", "object"})) do
			if getElementDimension(v) == old then
				setElementDimension(v, new)
			end
		end
	end
end

function RGBtoHEX(...)
	args = {...}
	for i,v in pairs(args) do
		v = tonumber(v) or -1
		if v < 0 or v > 255 then
			return "#FFFF00"
		end
	end
	if args[4] then
		return string.format("#%.2X%.2X%.2X%.2X", args[1],args[2],args[3],args[4])
	else
		return string.format("#%.2X%.2X%.2X", args[1],args[2],args[3])
	end
end

function msg(p, pre,post)
	outputChatBox("#FF0000[#00FF00Man#FF0000hunt]:#ffff00 "..pre or "".."#ffff00"..post or "", p or root, 0, 0, 0, true)
end

function gprn(p)
	local r,g,b = getPlayerNametagColor(p)
	return RGBtoHEX(r,g,b)..getPlayerName(p)
end