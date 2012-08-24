--[[CUSTOM EVENTS]]--
addEvent ( "onPlayerTryLogin", true )
addEvent ( "onPlayerTryRegister", true )

--addEvent ( "onPlayerSelectCharacter", true )
--addEvent ( "onPlayerChooseCharacter", true )
---------------------

--[[VARIABLES]]--
root = getRootElement ( )
local matrixes = {
    { 1383.60, -882.4, 65.50, 1419.10, -808.8, 86.8 },
    { 46.1000, -153.8, 82.20, -10.600, -84.30, 37.9 },
    { 2045.20, 1518.7, 38.10, 2005.50, 1549.8, 13.2 },
    { -1910.2, -2306, 17, -1910, 738, 157 },
    { -2265.8, 224.20, 55.40, -2318.9, 138.90, 35.0 },
}
-----------------

--[[CUSTOM FUNCTIONS
function saveAccountCharacterData ( acc, player )
    local p = player or getAccountPlayer(acc)
    local x, y, z = getElementPosition ( p )
    setAccountData ( acc, "roleplay.char"..tostring ( getElementData ( p, "charID" ) ), toJSON ( { getElementData ( p, "name" ), getElementData ( p, "age" ), getElementData ( p, "cash" ), getElementData ( p, "job" ), getElementModel ( p ), x, y, z, getPedRotation ( p ) } ) ) --Name, Age, Cash, Job, Skin, PosX, PosY, PosZ
end
function loadAccountCharacterData ( acc, index )
    if index > 0 and index < 4 then
        return fromJSON ( getAccountData ( acc, "roleplay.char"..tostring ( index ) ) )
	end
end
------------------------


addEventHandler ( "onPlayerSelectCharacter", root,
    function ( index )
	    local acc = getPlayerAccount ( source )
	    if not isGuestAccount ( acc ) then
		    triggerClientEvent ( source, "onClientPlayerSelectCharacter", source, loadAccountCharacterData ( acc, index ) )
		end
	end )
	
addEventHandler ( "onPlayerChooseCharacter", root,
    function ( index )
	    local acc = getPlayerAccount ( source )
	    if not isGuestAccount ( acc ) then
		    local alldata = loadAccountCharacterData ( acc, index )
		    fadeCamera ( source, false )
			setElementData ( source, "name", alldata[1], true )
			setElementData ( source, "age", alldata[2], true )
			setElementData ( source, "cash", alldata[3], true )
			setElementData ( source, "job", alldata[4], true )
			setElementData ( source, "roleplay.newUser", getAccountData ( acc, "roleplay.newUser" ), true )
			setElementData ( source, "charID", index, true )
			triggerEvent("onPlayerRequestBonus", source, "roleplay", 1)
			setTimer ( setCameraTarget, 1100, 1, source, source )
			setTimer ( spawnPlayer, 1150, 1, source, alldata[6], alldata[7], alldata[8], alldata[9], alldata[5] )
			setTimer ( fadeCamera, 1200, 1, source, true )
			setTimer ( showChat, 1300, 1, source, true )
			if getElementData ( source, "roleplay.newUser" ) == true then
			    setTimer ( setElementPosition, 1150, 1, source, 1685.7, -2333.3, 13.2 )
			end
		end
    end )

addEventHandler ( "onPlayerQuit", root,
    function ( )
		if getElementData(source, "gamemode") ~= "roleplay" then return end
	    local acc = getPlayerAccount ( source )
	    if not isGuestAccount ( acc ) and getCameraTarget ( source ) == source then
		    saveAccountCharacterData ( acc, source )
		end
    end )]]--
-----------------------------------------------------------

