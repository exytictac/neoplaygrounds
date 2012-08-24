--returns whether the player in the specified group (or higher)
function playerIsInClass(player, group)
	local class = exports.exports:getPlayerClass(player)
	if class == group then
		return true
	elseif group == "2" then
		return class == "3" or class == "4"
	elseif group == "3" then
		return class == "4"
	else
		return false
	end
end

function getChannelFromName(name)
	for i, channel in ipairs(channels) do
		if channel.name == name then
			return channel, i
		end
	end
end

function updateSelectedChannels()
	selectedChannels = {}
	for i, channel in ipairs(channels) do
		if channel.selected and not channel.broadcastOnly then
			selectedChannels[#selectedChannels + 1] = channel
		end
	end
end

function isGroupChannel(channel)
	if not channel.ref then
		return false
	else
		return string.sub(channel.ref, 1, 6) == "group:"
	end
end