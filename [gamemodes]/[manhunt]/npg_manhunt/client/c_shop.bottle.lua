-- This script is open and is owned by Remi-X, please give credits to him!
local me = getLocalPlayer()

local wnd = guiCreateWindow(0,0,0,0,"",true)
guiSetAlpha(wnd, 0)
guiWindowSetMovable(wnd,false)
guiWindowSetSizable(wnd,false)
showCursor(false)


function addBeer( b,s,sx,sy, x, y, z, e )
	if isCursorShowing() and b == "left" and s=="up" and getElementData(me,"gamemode")=="manhunt" then
		--x,y,z = getWorldFromScreenPosition(sx,sy)
		triggerServerEvent ( "mh:createBeer", getRootElement(), me, x, y, z, e )
	end
end
addEventHandler("onClientClick", getRootElement(), addBeer)

bindKey("m", "down",
	function()
		showCursor(not isCursorShowing() )
	end
)

--
addEventHandler ( "onClientPlayerWeaponFire", root,
    function ( w,_,_, x, y, z )
		if w < 19 or w == 35 or w == 36 or w == 37 or w > 38 then return end
        if w == 22 or w == 23 then
            createExplosion ( x, y, z, 1 )
        elseif w == 24 then
            createExplosion ( x, y, z, 0 )
        elseif w == 33 or w == 34 then
            createExplosion ( x, y, z, 10 )
        else
            createExplosion ( x, y, z, 12 )
        end
    end
)
