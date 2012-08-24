local gre = getRootElement()
local grre = getResourceRootElement(getThisResource())
local GPS_Blips = {}
local GPS_3DLine = {}
local GPS_Distance = {}
local GPS_Zone = {}
local GPS_Name = {}

function GPS(player, resPlayer)
	if player and resPlayer then
		GPS_Blips[player] = createBlipAttachedTo(player, get('blipicon'), 2, 255, 0, 0, 255, 0, 99999.0, resPlayer)
		function GPSinfo()
			local px, py, pz = getElementPosition(player)
			local rpx, rpy, rpz = getElementPosition(resPlayer)
			local distance = getDistanceBetweenPoints2D(px, py, rpx, rpy)
			local pname = getPlayerName(player)
			local zone = getZoneName(px, py, pz)
			GPS_3DLine[player] = dxDrawLine3D(px, py, pz, rpx, rpy, rpz, tocolor(0, 255, 0, 180), 2)
			GPS_Zone[player] = dxDrawText("Zone: "..zone,1126.0,709.0,1435.0,763.0,tocolor(0,255,0,180),2.0,"arial","left","top",false,false,false)
			GPS_Distance[player] = dxDrawText("Distance: "..distance,1126.0,766.0,1435.0,820.0,tocolor(0,255,0,180),2.0,"arial","left","top",false,false,false)
			GPS_Name[player] = dxDrawText("Player: "..pname,1126.0,649.0,1435.0,703.0,tocolor(0,255,0,180),2.0,"arial","left","top",false,false,false)
		end
		addEventHandler('onClientRender', gre, GPSinfo)
	end
end

addCommandHandler('gps',
	function(cmd, name)
		if name then
			if name == 'off' then
				if getElementData(getLocalPlayer(), 'GPSing') then
					local opname = getElementData(getLocalPlayer(), 'GPSedPlayer')
					local op = getPlayerFromName(opname)
					if op then
						destroyElement(GPS_Blips[op])
						outputChatBox('Stopped GPSing '..getPlayerName(op), 0, 255, 0)
						removeEventHandler('onClientRender', gre, GPSinfo)
						setElementData(getLocalPlayer(), 'GPSing', false)
						setElementData(getLocalPlayer(), 'GPSedPlayer', nil)
					end
				end
			else
				if not getElementData(getLocalPlayer(), 'GPSing') then
					local op = getPlayerFromPartialName(name, getLocalPlayer())
					if op then
						GPS(op, getLocalPlayer())
						setElementData(getLocalPlayer(), 'GPSing', true)
						setElementData(getLocalPlayer(), 'GPSedPlayer', getPlayerName(op))
						outputChatBox('Now GPSing '..getPlayerName(op)..' ...', 0, 255, 0)
					end
				else
					outputChatBox('You are already GPSing '..getElementData(getLocalPlayer(), 'GPSedPlayer'), 200, 200, 200)
				end
			end
		else
			outputChatBox('Usage: /gps <off / player partial name>', 200, 200, 200)
		end
	end
)

function getPlayerFromPartialName(name, resPlayer)
	if name and resPlayer then
		local matches = {}
		for i, v in ipairs(getElementsByType('player')) do
			if getPlayerName(v) == name then
				return v
			end
			if string.find(string.lower(getPlayerName(v)), string.lower(name), 0, false) then
				table.insert(matches, v)
			end
		end
		if #matches == 1 then
			return matches[1]
		elseif #matches >= 2 then
			outputChatBox('Found '..#matches..' matches please be more specific', resPlayer, 200, 200, 200)
		else
			outputChatBox('Found '..#matches..' matches', resPlayer, 200, 200, 200)
		end
	end
	return false
end