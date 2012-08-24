-- This script is open and is owned by Remi-X, please give credits to him!

local obj = {}
local h = {}
local c = {}
local beer = {}
local b = {}
local r = {}
local d = {}
local m = {}
local bp = {}
local attachment = {}

function createBeerBottle ( player, x, y, z, attachTo )
    if beer[player] then destroyElement ( beer[player] ) end
    beer[player] = createObject ( 1484, x, y, z )
    setElementInterior(beer[player], INT)
	setElementDimension(beer[player], DIM)
	setElementCollisionsEnabled(beer[player], false)
	setObjectScale ( beer[player], 2 )
    bp[player] = {x,y,z}
    if isElement ( attachTo ) then
        if getElementType ( attachTo ) == "player"  or
           getElementType ( attachTo ) == "ped"      or
           getElementType ( attachTo ) == "vehicle" then
           attachElements ( beer[player], attachTo ) end
    end
    attachment[player] = attachTo
    if obj[player] then
		if obj[player][1] then
			for i,v in ipairs ( obj[player] ) do
				destroyElement ( v )
			end 
		end 
	end
    obj[player] = {}
end

addCommandHandler ( "boom", 
    function ( player )
        if b[player] then return end
        if not beer[player] then return end
        for i=1,5 do
            local flare = createObject ( 354, unpack ( bp[player] ) )
			setElementInterior(flare, getElementInterior(   beer[player])  )
		setElementCollisionsEnabled (flare, false)
            if attachment[player] then attachElements ( flare, attachment[player] ) end
            table.insert ( obj[player], flare )
        end
        --m[player] = createMarker ( pos[player][1], pos[player][2], pos[player][3], "checkpoint", 1, 255, 255, 255, 0 )
        --table.insert ( obj[player], m[player] )
        c[player] = createColCircle ( bp[player][1], bp[player][2], 10 )
        if attachment[player] then attachElements ( c[player], attachment[player] ) end
        h[player] = bp[player][3]
        b[player] = true
        --setTimer ( function ( )
        --    local _,_,_,a = getMarkerColor ( m[player] )
        --    setMarkerColor ( m[player], 255, 255, 255, a+12.5 )
        --end, 100, 20 )
        setTimer ( function ( )
            setTimer ( function ( )
                local pwn = getElementsWithinColShape ( c[player] )
                for i,v in ipairs ( pwn ) do 
                    local xv, yv, zv = getElementVelocity ( v )
                    if xv and yv and zv then
                        if zv < .08 then zv = .08 end
                        setElementVelocity ( v, xv, yv, zv*1.15 )
                    end
                end
                bp[player] = {getElementPosition ( beer[player] )}
                createExplosion ( bp[player][1], bp[player][2], h[player], 0, player )
                h[player] = h[player]+2
            end, 100, 20 )
            setTimer ( function ( )
                for i,v in ipairs ( obj[player] ) do destroyElement ( v ) end
                obj[player] = {}
                b[player] = false
            end, 2500, 1 )
        end, 2000, 1 )
    end
)

addCommandHandler ( "beam",
    function ( player )
        if b[player] or not bp[player] then return end
        for i=1,5 do
            local flare = createObject ( 354, unpack ( bp[player] ) )
			
            setElementCollisionsEnabled ( flare, false )
            if attachment[player] then attachElements ( flare, attachment[player] ) end
            table.insert ( obj[player], flare )
        end
        r[player] = -36
        b[player] = true
        setTimer ( function ( )
            setTimer ( function ( )
                r[player] = r[player] + 36
                if not d[r[player]] then d[r[player]] = 5
                else d[r[player]] = d[r[player]] + 5 end
                bp[player] = {getElementPosition ( beer[player] )}
                for i=2,11,3 do
                    local px, py = getXYInFrontOfPos ( bp[player][1], bp[player][2], r[player]-i, i )
                    createExplosion ( px, py, bp[player][3], 0, player )
                end
            end, 250, 30 )
            setTimer ( function ( )
                for i,v in ipairs ( obj[player] ) do destroyElement ( v ) end
                obj[player] = {}
                d = {}
                b[player] = false
            end, 250*30+1000, 1 )
        end, 2000, 1 )
    end
)

function getXYInFrontOfPos( x, y, r, d )
    r = math.rad ( -r )
    x=x+(math.sin(r)*d)
    y=y+(math.cos(r)*d)
    return x,y
end

addEvent ( "mh:createBeer", true )
addEventHandler ( "mh:createBeer", root, createBeerBottle )