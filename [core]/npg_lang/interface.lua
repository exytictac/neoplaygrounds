-- Awesomeus language system.
-- Copyright 2012 Neo Playgrounds
-- If you are reading this, then please die. ALL YOUR BASE ARE BELONG TO US.

local languages = {
    {'en','English'},
    {'hr','Croatian'},
    {'pl', 'Polish'},
    {'es', 'Spanish'},
    {'nl', 'Dutch'}
}

local flagX, flagY = 32, 32
local sx, sy = guiGetScreenSize()

function lang()
    return getElementData(localPlayer,'language') or 'en'
end

local leFlag = guiCreateStaticImage((1280/sx)*1170, 0,flagX, flagY, ':npg_lang/flags/'..lang()..'.png', false, exports.npg_info:interfaces()['bar'])

function importFlag(res)
	if res==getThisResource() or res==getResourceFromName('npg_info') then
		exports.npg_info:add('flag', leFlag)
	end
end
addEventHandler('onClientResourceStart', root, importFlag)

local function languageIndex(l)
    for i,v in ipairs(languages) do
        if v[1] == l then
            return i-1
        end
    end
end

local function toggleWindow()
	if guiGetVisible(GUIEditor_Window[1]) then
        guiSetVisible(GUIEditor_Window[1], false)
    return
    end
    outputChatBox('Type the command again to hide the window')
    guiSetVisible(GUIEditor_Window[1], true)
    guiGridListSetSelectedItem(GUIEditor_Grid[1], languageIndex(lang()), 1)
end
addCommandHandler('lang', toggleWindow)
addCommandHandler('language', toggleWindow)

addEventHandler('onClientGUIClick', root, function(b,s)
    if b~='left' and s~='up' then return end
    if source == leFlag then
        outputChatBox('Press the flag again to hide the window')
        toggleWindow()
    elseif source == GUIEditor_Grid[1] then
        local item,c = guiGridListGetSelectedItem ( GUIEditor_Grid[1])
        if item == -1 then
            guiGridListSetSelectedItem(GUIEditor_Grid[1], languageIndex(lang()), 1)
            return
        end
        local newlang = guiGridListGetItemData(GUIEditor_Grid[1],item,c)
        setElementData(localPlayer, 'language',newlang, true)
    end
end)

addEvent('onClientLanguageChange')
addEventHandler('onClientLanguageChange', root, function(new,old)
    old, new = languages[languageIndex(old)+1][2], languages[languageIndex(new)+1][2]
    exports.npg_textactions:sendMessage('Language changed from '..old..' to '..new)
end)

addEventHandler('onClientElementDataChange', localPlayer, function(new,old)
    if new == 'language' and source==localPlayer then
        triggerEvent('onClientLanguageChange', localPlayer, lang(), old)
        
        guiStaticImageLoadImage(leFlag, 'flags/'..lang()..'.png')
        
        if guiGetVisible(GUIEditor_Window[1]) then
            guiStaticImageLoadImage(GUIEditor_Image[1], 'flags/'..lang()..'.png')
        end
    end
end)

GUIEditor_Window = {}
GUIEditor_Label = {}
GUIEditor_Grid = {}
GUIEditor_Image = {}

GUIEditor_Window[1] = guiCreateWindow(0.4148,0.3475,0.1594,0.36,"Change your language",true)
guiWindowSetMovable(GUIEditor_Window[1],false)
guiWindowSetSizable(GUIEditor_Window[1],false)
GUIEditor_Grid[1] = guiCreateGridList(0.0441,0.2743,0.9069,0.6944,true,GUIEditor_Window[1])
guiGridListSetSelectionMode(GUIEditor_Grid[1],2)
guiGridListSetSortingEnabled (GUIEditor_Grid[1], false)
guiGridListAddColumn(GUIEditor_Grid[1],"Language",1)

for i,v in ipairs(languages) do
    local row = guiGridListAddRow(GUIEditor_Grid[1])
    guiGridListSetItemText(GUIEditor_Grid[1],row,1,v[2],false, false)
    guiGridListSetItemData(GUIEditor_Grid[1],row,1,v[1])
end


GUIEditor_Image[1] = guiCreateStaticImage(0.4755,0.125,0.2157,0.1007,"flags/"..lang()..".png",true,GUIEditor_Window[1])
guiSetSize(GUIEditor_Image[1], flagX, flagY, false)
GUIEditor_Label[1] = guiCreateLabel(0.2892,0.1389,0.4853,0.0799,"Flag:",true,GUIEditor_Window[1])


guiSetVisible(GUIEditor_Window[1], false)