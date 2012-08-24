
-- ******************************************
-- * Written by Tommy (c) 2010              *
-- ******************************************


function noThanks(pl)
	local thePlayerNick = getPlayerName(pl)
	setPlayerName(thePlayerNick, string.gsub(thePlayerNick:gsub('#%x%x%x%x%x%x', ''),"npg",""))
end

-- ******************
-- * Event handlers *
-- ******************

addEventHandler("onPlayerJoin", getRootElement(),
	function()
		local n = getPlayerName(source)
		setPlayerName(source, string.gsub(n:gsub("#%x%x%x%x%x%x", ""), "npg", ""))
	end
)

addEventHandler("onPlayerChangeNick", getRootElement(), 
	function(_,n)
		if string.find(string.lower(n),"npg") then
			if ( hasObjectPermissionTo ( source, "general.adminpanel", true ) ) then
				outputChatBox ( "You aren't allowed to use this tag", source, 0,255,0 )
			else
				cancelEvent()
			end
			if string.find(n,"#%x%x%x%x%x%x") then
				cancelEvent()
				setPlayerName(source, n:gsub('#%x%x%x%x%x%x', ''))
			end
		end
	end
)