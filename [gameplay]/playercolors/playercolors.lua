local lowerBound,upperBound = unpack(get"color_range")
g_Root = getRootElement ()
g_ResourceRoot = getResourceRootElement ( getThisResource () )

addEventHandler ( "onResourceStart", g_ResourceRoot,
	function()
		for i,player in ipairs(getElementsByType"player") do
			processPlayer ( player )
		end
	end
)

function processPlayer ( player )
	player = player or source
	local r, g, b = math.random(lowerBound, upperBound), math.random(lowerBound, upperBound), math.random(lowerBound, upperBound)
	setPlayerNametagColor(player, r, g, b)
end
addEventHandler ( "onPlayerJoin", g_Root, processPlayer )

getPlayerColor = getPlayerNametagColor
getPlayerColour = getPlayerNametagColor
