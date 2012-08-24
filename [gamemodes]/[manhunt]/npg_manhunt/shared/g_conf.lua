function destroyBlipsAttachedTo(player)
	local attached = getAttachedElements(player)
	if attached then
		for k, element in ipairs(attached) do
			if getElementType(element) == "blip" then
				destroyElement(element)
			end
		end
	end
end

function getRandomFromTable(t)
	return t[math.random(#t)]
end

function iif(a,b,c)
	if a then
		return b
	else
		return c
	end
	return nil
end

function math.lerp(from,to,alpha)
    return from + (to-from) * alpha
end

function math.evalCurve( curve, input )
	-- First value
	if input<curve[1][1] then
		return curve[1][2]
	end
	-- Interp value
	for idx=2,#curve do
		if input<curve[idx][1] then
			local x1 = curve[idx-1][1]
			local y1 = curve[idx-1][2]
			local x2 = curve[idx][1]
			local y2 = curve[idx][2]
			-- Find pos between input points
			local alpha = (input - x1)/(x2 - x1);
			-- Map to output points
			return math.lerp(y1,y2,alpha)
		end
	end
	-- Last value
	return curve[#curve][2]
end