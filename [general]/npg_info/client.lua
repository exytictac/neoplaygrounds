--[[INFORMATION]]--
local player = getLocalPlayer()
local barInterfaces = {}
local finalBarAlpha, barAlpha, barShowing = 150, 0, false

outputChatBox('try /cbar when in gm, its in npg_info')

function __( ... )
    return exports.npg_lang:__( ... );
end

function getPlayerGamemode(pl)
	return pl and getElementData(pl, "gamemode") or false
end

function isPlayerReady(pl)
	return getPlayerGamemode(pl) and true or false
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    gui = {}
    
    intializeInterface()
    
    if fileExists('radio.xml') then
        radioSound = playSound('http://server.mtasa.pl:8000/autodj.mp3.m3u')
    end
    
    if getElementData(localPlayer,'gamemode') then
        showInterface()
        barShowing=true
    end
    local sw,sh = guiGetScreenSize()
    local wWidth, wHeight = 600,570
    local leeft = sw/2 - wWidth/2
    local toop = sh/2 - wHeight/2
    
    gui["wnd"] = guiCreateWindow ( sw/2 - 305.5, sh/2 - 322.5, wWidth, wHeight, '', false )
    gui["wnd-button"] = guiCreateButton(481,535,108,26, '',false,gui["wnd"])
    gui["wnd-image"] = guiCreateStaticImage ( 12,23,575,154,"infologo.png",false,gui["wnd"])
    gui["wnd-label"] = guiCreateLabel(15,220,563,311,'',false,gui["wnd"])
    gui["wnd-label2"] = guiCreateLabel(15,199,202,27,'',false,gui["wnd"])
    gui["wnd-label3"] = guiCreateLabel(16,415,276,82,'',false,gui["wnd"])
    gui["wnd-label4"] = guiCreateLabel(15,534,465,23,'',false,gui["wnd"])
    guiLabelSetHorizontalAlign ( gui["wnd-label"], "left", true )
    guiSetVisible ( gui["wnd"], false )
    guiSetFont(gui["wnd-label2"],"default-bold-small")
    guiSetFont(gui["wnd-label3"],"default-bold-small")
    guiSetFont(gui["wnd-label4"],"default-small")
    
    addEventHandler ( "onClientGUIClick", gui["wnd-button"], onClick)
end)




function updateInfowndStrings(new,old)
    guiSetText( gui["wnd"], __('About-Title'))
    guiSetText( gui["wnd-button"], __("Close"))
    guiSetText( gui["wnd-label"] , __('Server info'))
    guiSetText( gui["wnd-label2"] , __('Server Title'))
    guiSetText( gui["wnd-label4"] , __('Contact'))
    guiSetText ( gui["wnd-label3"] , __('Webpage').."\n".. __('Forums').. "\n"..__('Bugtracker') )
end
addEvent('onClientLanguageChange')
addEventHandler('onClientLanguageChange', root, updateInfowndStrings)



function showInterface()
    for i,v in pairs(barInterfaces) do
        guiSetVisible(v, true)
        Animation.createAndPlay(v, Animation.presets.guiFadeIn(600))
    end
    guiSetVisible(barInterfaces['loginLabel'], false)
    guiSetVisible(barInterfaces['loginSignout'], false)
end

function showLoginInterface()
    barShowing = true
	
	if isPlayerReady ( player ) then
		guiSetVisible(barInterfaces['loginLabel'], false)
		guiSetVisible(barInterfaces['loginSignout'], false)
	else
		guiSetVisible(barInterfaces['loginLabel'], true)
		guiSetVisible(barInterfaces['loginSignout'], true)
		guiSetVisible(barInterfaces['bar'], true)
		Animation.createAndPlay(barInterfaces['bar'], Animation.presets.guiFadeIn(600))
		Animation.createAndPlay(barInterfaces['loginLabel'], Animation.presets.guiFadeIn(600))
		Animation.createAndPlay(barInterfaces['loginSignout'], Animation.presets.guiFadeIn(600))
	end
end
addEvent('onClientPlayerLogin', true)
addEventHandler('onClientPlayerLogin', root, showLoginInterface)

addEvent('onClientPlayerSelectGamemode', true)
addEventHandler('onClientPlayerSelectGamemode', root, showInterface)

function hideInterface(bAnim)
    for i,v in pairs(barInterfaces) do
        guiSetAlpha(v, 1)
        if bAnim then
            Animation.createAndPlay(v, Animation.presets.guiFadeOut(300))
            setTimer(guiSetVisible, 350, 1, v, false)
        else
            guiSetVisible(v, false)
        end
    end
end


function onClick(b,s)
    if b~='left' and s~='up' then return end
    if getElementData(player,"gamemode") and isCursorShowing() and source==barInterfaces['infobtn'] then
        if guiGetVisible(gui['wnd']) then
            setTimer ( guiSetVisible, 300, 1, gui["wnd"], false)
            Animation.createAndPlay(gui["wnd"], Animation.presets.guiFadeOut(300))
            return
        end
        updateInfowndStrings()
        guiSetVisible ( gui["wnd"], true )
        Animation.createAndPlay(gui["wnd"], Animation.presets.guiFadeIn(600))
    elseif source==gui["wnd-button"] then
        setTimer ( guiSetVisible, 300, 1, gui["wnd"], false)
        Animation.createAndPlay(gui["wnd"], Animation.presets.guiFadeOut(300))
    elseif source==barInterfaces['loginSignout'] then
        if fileExists('@:npg_core/localdata.npg') then
            fileDelete('@:npg_core/localdata.npg')
            exports.npg_textactions:sendMessage('Your credentials have been forgotten')
        end
        exports.npg_textactions:sendMessage('Please reconnect to login as a different user')
    elseif source==barInterfaces['radio'] then
        if radioSound then
            destroyElement(radioSound)
            radioSound = nil
            if fileExists('radio.xml') then
                fileDelete('radio.xml')
            end
        else
            radioSound = playSound('http://server.mtasa.pl:8000/autodj.mp3.m3u')
            xmlSaveFile(xmlCreateFile('radio.xml','save'))
        end
    end
end

function interfaces()
	return barInterfaces
end

function add(name, item)
    barInterfaces[name] = item
end


function intializeInterface()
    local sw,sh = guiGetScreenSize()
    local w,h=1024/sw,768/sh
    barInterfaces['bar'] = guiCreateStaticImage(0, sh-37, sw, 35, "bar.png", false )
    
    barInterfaces['loginLabel'] = guiCreateLabel(150,0,100,35,"Welcome, ".. getPlayerName ( localPlayer ),false, barInterfaces['bar'])
    guiLabelSetVerticalAlign(barInterfaces['loginLabel'],"center")
    guiLabelSetColor(barInterfaces['loginLabel'], 0, 0, 0)
    
    barInterfaces['loginSignout'] = guiCreateButton( sw/2,0,120,35,"Not you?",false, barInterfaces['bar'])
    addEventHandler ( "onClientGUIClick", barInterfaces['loginSignout'], onClick)

    barInterfaces['radio'] = guiCreateStaticImage(sw/2,0,35,35,"radio.png",false, barInterfaces['bar'])
    addEventHandler ( "onClientGUIClick", barInterfaces['radio'], onClick)

    barInterfaces['infobtn'] = guiCreateStaticImage(sw/2 - 60,0,55,37,"logo.png",false, barInterfaces['bar'])
    addEventHandler ( "onClientGUIClick", barInterfaces['infobtn'], onClick)
    
    for i,v in pairs(barInterfaces) do
        guiSetAlpha(v, 0)
        guiSetVisible(v, false)
    end
end


addCommandHandler('cbar', function()
        if not getElementData(localPlayer, 'gamemode') then return end
        if barShowing then
            hideInterface(true)
        else
            showInterface()
        end
        barShowing = not barShowing
    end
)
