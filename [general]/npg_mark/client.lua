local distance = 6000
local screenSizeX, screenSizeY = guiGetScreenSize()
local scale = 7
local find = {}
 
 
function renderHandleFollow()
    for i,v in pairs(find) do
        if isElement(i) then
            local x, y, z = getElementPosition( i )
            local px, py, pz = getElementPosition ( localPlayer )
            local dist = math.floor(getDistanceBetweenPoints3D ( px, py, pz, x, y, z ))
            if (dist < distance and isLineOfSightClear( px, py, pz, x, y, z,false, false, false, false )) then
                local screenX, screenY = getScreenFromWorldPosition ( x, y, z+0.5 )
                local scaled = screenSizeX * (1/(2*(dist+5))) *.85
                local relX, relY = scaled * scale, scaled * scale
                if ( screenX and screenY ) then
                    dxDrawText( getPlayerName(i)..":"..dist, screenX+20, screenY, relX, relY, tocolor ( 0, 255, 0, 255 ), 1.3, "arial" )
                    dxDrawRectangle(screenX, screenY-20, 20,20, tocolor(255,127,0,255))
                    
                    dxDrawLine(screenX, screenY, screenX+20, screenY, tocolor(255,0,0,255), 3) -- tl to tr
                    dxDrawLine(screenX, screenY, screenX, screenY-20, tocolor(255,255,0,255), 3) -- tl to bl
                    dxDrawLine(screenX+20, screenY-20, screenX+20, screenY, tocolor(255,127,0,255), 3) -- tr to br
                    dxDrawLine(screenX, screenY-20, screenX+20, screenY-20, tocolor(0,255,0,255), 3) -- bl to br
                    
                end
            end
        else
            find[i] = nil
        end
    end
end
addEventHandler("onClientRender", root, renderHandleFollow)
 
function renderStart (_, pl)
    local p = findPlayer(pl)
    if isElement(p) then
        if p == getLocalPlayer() then
            outputChatBox('You need help.', 255, 0, 0)
        else
            if find[p] then
                find[p] = nil
                outputChatBox('Marking for this player has been disabled.')
            else
                find[p] = true
                outputChatBox('Marking for this player has been enabled.')
            end
        end
    else
        outputChatBox('Invalid Player name', 255, 0, 0)
    end
end
addCommandHandler ( "mark", renderStart )
 
 
 
function findPlayer(namepart)
    local player = getPlayerFromName(namepart)
    if player then
        return player
    end
    for _,player in ipairs(getElementsByType("player")) do
        if string.find(string.gsub(getPlayerName(player):lower(),"#%x%x%x%x%x%x", ""), namepart:lower(), 1, true) then
            return player
        end
    end
    return false
end
